//
//  AddressSettingViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/15/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources

class AddressSettingViewController: UIViewController {
  var onAddressChanged: ((Address) -> Void)?
  
  private let disposeBag = DisposeBag()
  
  private var newAddress: Address?
  private let addressListSubject = BehaviorSubject<[Address]>(value: [])
  private var addressId = 0
  
  private let navigationBarView = CustomNavigationBarView(navigationBarType: .normal)
  private let headerView = MyPageSectionHeaderView()
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.itemSize = .init(width: UIScreen.main.bounds.width - 40, height: 164)
    $0.collectionViewLayout = flowLayout
    $0.register(AddressCollectionViewCell.self,forCellWithReuseIdentifier: AddressCollectionViewCell.className)
    $0.isHidden = true
  }
  private let addButton = UIButton().then {
    $0.setTitle("+ 배송지 등록", for: .normal)
    $0.titleLabel?.font = .body2Sb18
    $0.backgroundColor = .white
    $0.makeCornerRound(radius: 10)
    $0.makeBorder(width: 1, color: .gray3)
    $0.setTitleColor(.gray4, for: .normal)
    $0.isHidden = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchAddress()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if let newAddress = self.newAddress {
      onAddressChanged?(newAddress)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchAddress()
    setUI()
    configureCollectionView()
    bind()
  }
  
  private func setUI() {
    view.backgroundColor = .white
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    view.addSubviews(
      navigationBarView,
      headerView,
      addButton,
      collectionView
    )
  }
  
  private func setConstraints() {
    navigationBarView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
    }
    
    headerView.snp.makeConstraints {
      $0.top.equalTo(navigationBarView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(48)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(headerView.snp.bottom).offset(19)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    addButton.snp.makeConstraints {
      $0.top.equalTo(headerView.snp.bottom).offset(30)
      $0.leading.trailing.equalToSuperview().inset(30)
      $0.height.equalTo(150)
    }
  }
  
  private func configureCollectionView() {
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Address>>(
      configureCell: { dataSource, collectionView, indexPath, item in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddressCollectionViewCell.className, for: indexPath) as! AddressCollectionViewCell
        let address = item as Address
        cell.configureView(name: address.name, address: address.address, phone: address.phone, isEditable: true)
        
        // 주소 삭제
        cell.deleteButtonTap
          .subscribe(onNext: { [weak self] in
            self?.deleteAddress(at: indexPath)
          })
          .disposed(by: cell.disposeBag)
        
        // 주소 변경
        cell.editButtonTap
          .subscribe(onNext: { [weak self] in
            self?.editAddress(at: indexPath)
          })
          .disposed(by: cell.disposeBag)
        
        return cell
      }
    )
    
    headerView.setTitleLabel(title: "배송지 관리")
    
    addressListSubject
      .map { [SectionModel(model: "배송지 관리", items: $0)] }
      .bind(to: collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
  }
  
  private func bind() {
    navigationBarView.backButtonTap
      .subscribe(with: self) { owner, _ in
        if let newAddress = self.newAddress {
          owner.onAddressChanged?(newAddress)
        }// 변경된 주소를 클로저로 전달
        owner.navigationController?.popViewController(animated: true)
      }
      .disposed(by: disposeBag)
    
    addButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.navigationController?.pushViewController(AddressFormViewController(), animated: true)
      })
      .disposed(by: disposeBag)
    
    addressListSubject
      .subscribe(onNext: { [weak self] addressList in
        guard let self = self else { return }
        let isEmpty = addressList.isEmpty
        self.collectionView.isHidden = isEmpty
        self.addButton.isHidden = !isEmpty
      })
      .disposed(by: disposeBag)
  }
  
  private func fetchAddress() {
    Providers.MypageProvider.request(target: .fetchUserAddress,
                                     instance: BaseResponse<UserAddressResponseDTO>.self) { result in
      guard let data = result.data else { return }
      
      if let addressId = data.addressID,
         let name = data.recipient,
         let zipcode = data.zipCode,
         let address = data.address,
         let detailAddress = data.detailAddress,
         let phone = data.recipientPhone {
        self.newAddress = Address(addressId: addressId, name: name,address: "(\(zipcode) \(address), \(detailAddress))",phone: phone)
        self.addressId = data.addressID ?? 0
        if let newAddress = self.newAddress {
          self.addressListSubject.onNext([newAddress])
        }
        self.collectionView.reloadData()
        self.collectionView.isHidden = false
        self.addButton.isHidden = true
      } else {
        self.collectionView.isHidden = true
        self.addButton.isHidden = false
      }
    }
  }
  
  private func deleteAddress(at indexPath: IndexPath) {
    Providers.MypageProvider.request(target: .deleteUserAddress(addressId),
                                     instance: BaseResponse<Bool>.self) { result in
      if result.data ?? false {
        // addressListSubject에서 해당 주소 삭제 로직
        var currentList = (try? self.addressListSubject.value()) ?? []
        currentList.remove(at: indexPath.item)
        self.addressListSubject.onNext(currentList)
      }
    }
  }
  
  private func editAddress(at indexPath: IndexPath) {
    let currentList = (try? self.addressListSubject.value()) ?? []
    if indexPath.row < currentList.count {  // indexPath가 유효한지 확인
      let selectedAddress = currentList[indexPath.row]
      self.navigationController?.pushViewController(AddressFormViewController(addressInfo: selectedAddress), animated: true)
    }
  }
  
}
