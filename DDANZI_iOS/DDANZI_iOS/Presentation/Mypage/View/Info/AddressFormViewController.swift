//
//  AddAddressViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/9/24.
//

import UIKit
import WebKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class AddressFormViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  
  private var currentAddressInfo: Address?
  private let titles: [String] = ["우편번호", "주소지", "상세주소", "이름", "휴대폰 번호"]
  private let userInfo = UserInfoModel(name: UserDefaults.standard.string(forKey: .name) ?? "",
                                       phone: UserDefaults.standard.string(forKey: .phone) ?? "",
                                       nickName: UserDefaults.standard.string(forKey: .nickName) ?? "")
  private var zoneCode: String?
  private var roadAddress: String?
  private lazy var addressDetails: [String?] = [zoneCode, roadAddress, nil, userInfo.name, userInfo.phone]
  
  // MARK: UI
  private let navigationBar = CustomNavigationBarView(navigationBarType: .normal)
  private let addressFormTableView = UITableView(frame: .zero, style: .plain).then {
    $0.backgroundColor = .white
    $0.register(AddressFormTableViewCell.self, forCellReuseIdentifier: AddressFormTableViewCell.className)
    $0.rowHeight = 75
    $0.separatorStyle = .none
    $0.scrollsToTop = false
    $0.contentInset = .init(top: 10, left: 0, bottom: 0, right: 0)
  }
  private let headerView = MyPageSectionHeaderView().then {
    $0.setTitleLabel(title: "배송지 등록")
  }
  private let nexButton = DdanziButton(title: "입력 완료", enable: false)
  
  // MARK: Init
  init(addressInfo: Address? = nil) {
    self.currentAddressInfo = addressInfo
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
    setDelegate()
    bind()
    setupDismissKeyboardGesture()
  }
  
  private func setUI() {
    self.view.backgroundColor = .white
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    view.addSubviews(
      navigationBar,
      headerView,
      addressFormTableView,
      nexButton
    )
  }
  
  private func setConstraints() {
    navigationBar.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
    }
    
    headerView.snp.makeConstraints {
      $0.top.equalTo(navigationBar.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(48)
    }
    
    addressFormTableView.snp.makeConstraints {
      $0.top.equalTo(headerView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    nexButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(10)
      $0.bottom.equalToSuperview().inset(38)
      $0.height.equalTo(50)
    }
  }
  
  private func bind() {
    navigationBar.backButtonTap
      .subscribe(onNext: { [weak self] in
        self?.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
    
    nexButton.rx.tap
      .subscribe(with: self, onNext: { owner, event  in
        let addressInfo: [String] = owner.addressDetails.map {
          guard let addressInfo = $0 else { return "" }
          return addressInfo
        }
        let body = UserAddressRequestDTO(recipient: addressInfo[3], zipCode: addressInfo[0], type: .road, address: addressInfo[1] , detailAddress: addressInfo[2], recipientPhone: addressInfo[4])
        if let currentAddressInfo = self.currentAddressInfo,
           let addressId = currentAddressInfo.addressId {
          owner.editAddress(addressId: addressId, body: body)
        } else {
          owner.postAddress(body: body)
        }
      })
      .disposed(by: disposeBag)
  }
  
  private func postAddress(body: UserAddressRequestDTO) {
    Providers.MypageProvider.request(target: .addUserAddress(body), instance: BaseResponse<UserAddressResponseDTO>.self) { result in
      self.navigationController?.popViewController(animated: true)
    }
  }
  
  private func editAddress(addressId: Int, body: UserAddressRequestDTO) {
    Providers.MypageProvider.request(target: .editUserAddress(addressId, body), instance: BaseResponse<UserAddressResponseDTO>.self) { response in
      self.navigationController?.popViewController(animated: true)
    }
  }
  
  private func setDelegate() {
    addressFormTableView.dataSource = self
    addressFormTableView.delegate = self
  }
  
  private func setupDismissKeyboardGesture() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    tapGesture.cancelsTouchesInView = false // 터치 이벤트가 다른 뷰로 전파되도록 설정
    view.addGestureRecognizer(tapGesture)
  }
  
  @objc private func dismissKeyboard() {
    view.endEditing(true)
  }
}

extension AddressFormViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: AddressFormTableViewCell.className, for: indexPath) as? AddressFormTableViewCell else {
      return UITableViewCell()
    }
    switch indexPath.row {
    case 0:
      cell.configureCell(
        title: titles[indexPath.row],
        placeholder: "",
        initalText: zoneCode ?? "",
        isButtonCell: true)
    case 1:
      cell.configureCell(
        title: titles[indexPath.row],
        placeholder: "주소지를 입력해주세요",
        initalText: roadAddress ?? "",
        isButtonCell: false)
    case 2:
      cell.configureCell(
        title: titles[indexPath.row],
        placeholder: "상세주소를 입력해주세요",
        initalText: addressDetails[2] ?? "",
        isButtonCell: false,
        isEnableInput: true)
    case 3:
      cell.configureCell(
        title: titles[indexPath.row],
        placeholder: "",
        initalText: userInfo.name,
        isButtonCell: false)
    case 4:
      cell.configureCell(
        title: titles[indexPath.row],
        placeholder: "",
        initalText: userInfo.phone,
        isButtonCell: false)
    default:
      break
    }
    
    cell.textChanged = { [weak self] text in
      self?.addressDetails[indexPath.row] = text
      self?.checkIsVaild()
    }
    
    
    return cell
  }
  
  private func checkIsVaild() {
    let allFieldsFilled = addressDetails.allSatisfy {
      guard let info = $0 else { return false }
      return !info.isEmpty
    }
    if allFieldsFilled {
      nexButton.backgroundColor = .black
      nexButton.isEnabled = true
    }
  }
}

extension AddressFormViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    switch indexPath.row {
    case 0, 1:
      let postCodeVC = KakaoPostCodeViewController()
      postCodeVC.dataSubject
        .subscribe(with: self,onNext: { owner, data in
          if let zonecode = data["zonecode"] as? String, let roadAddress = data["roadAddress"] as? String {
            owner.zoneCode = zonecode
            owner.roadAddress = roadAddress
            owner.addressDetails[0] = zonecode
            owner.addressDetails[1] = roadAddress
            
            // 테이블 뷰 업데이트
            owner.addressFormTableView.reloadData()
          }
        })
        .disposed(by: disposeBag)
      self.present(postCodeVC, animated: true)
    default:
      break
    }
  }
}
