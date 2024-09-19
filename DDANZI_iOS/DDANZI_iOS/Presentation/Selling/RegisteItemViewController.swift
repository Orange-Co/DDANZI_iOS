//
//  RegisteItemViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/9/24.
//

import UIKit

import Then
import SnapKit
import RxSwift
import RxCocoa

final class RegisteItemViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  let itemInfo = PublishRelay<itemConformedDTO>()
  var info: itemConformedDTO = .init(productID: "", productName: "", imgURL: "", originPrice: 0, salePrice: 0, isAccountExist: false)
  
  // MARK: - UI
  private let navigationBar = CustomNavigationBarView(navigationBarType: .cancel, title: "판매하기")
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
    $0.backgroundColor = .white
    $0.register(RegisteItemCell.self, forCellWithReuseIdentifier: RegisteItemCell.className)
  }
  private let buttonView = UIView().then {
    $0.backgroundColor = .white
  }
  private let registeButton = DdanziButton(title: "판매하기", enable: false)
  
  init(info: itemConformedDTO) {
    self.info = info
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
    configureCollectionView()
    
    setUI()
  }
  
  private func setUI() {
    view.backgroundColor = .white
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    view.addSubviews(navigationBar, collectionView, buttonView)
    buttonView.addSubview(registeButton)
  }
  
  private func setConstraints() {
    navigationBar.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(navigationBar.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    buttonView.snp.makeConstraints {
      $0.bottom.leading.trailing.equalToSuperview()
      $0.height.equalTo(92)
    }
    
    registeButton.snp.makeConstraints {
      $0.top.equalToSuperview().inset(20)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(50)
    }
  }
  
  private func bind() {
    itemInfo
      .subscribe(with: self) { owner, dto in
        owner.info = dto
        owner.collectionView.reloadData()
      }
      .disposed(by: disposeBag)
    
    registeButton.rx.tap
      .subscribe(with: self) { owner, _ in
        guard let cell = owner.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? RegisteItemCell else {
          print("셀 또는 dataButton Label을 찾을 수 없음")
          return
        }
        let dueDate = cell.dateString.value
        owner.registeItem(due: dueDate)
      }
      .disposed(by: disposeBag)
    
    navigationBar.cancelButtonTap
      .subscribe(with: self) { owner, _ in
        owner.navigationController?.popViewController(animated: true)
      }
      .disposed(by: disposeBag)
  }
  
  private func configureCollectionView() {
    collectionView.dataSource = self
    collectionView.delegate = self
  }
  
  private func registeItem(due: String) {
    let body = RegisteItemBody(productId: info.productID, productName: info.productName, receivedDate: due, registeredImage: info.imgURL)
    Providers.ItemProvider.request(target: .registeItem(body: body), instance: BaseResponse<RegisteItemDTO>.self) { response in
      guard let data = response.data else { return }
      let registeCompleteVC = RegisteCompleteViewController(response: data)
      let pushVC = PushSettingViewController(isSelling: true, orderId: "", response: data)
      PermissionManager.shared.checkPermission(for: .notification)
        .bind(with: self, onNext: { owner, isAllow in
          if isAllow {
            self.navigationController?.pushViewController(registeCompleteVC, animated: true)
          } else  {
            self.navigationController?.pushViewController(pushVC, animated: true)
          }
        })
        .disposed(by: self.disposeBag)
    }
  }
}

extension RegisteItemViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RegisteItemCell.className, for: indexPath) as? RegisteItemCell else { return UICollectionViewCell() }
    cell.configure(info: self.info)
    
    // 날짜와 전체 동의 여부 확인
    Observable.combineLatest(cell.selectedTerms, cell.dateString)
      .map { termsSelected, date in
        // 모든 약관이 동의됐고, 날짜가 선택됐는지 확인
        let allSelected = termsSelected.allSatisfy { $0 }
        return allSelected && !date.isEmpty
      }
      .bind(onNext: { isAllow in
        self.registeButton.setEnable()
      })
      .disposed(by: disposeBag)
    
    
    return cell
    
  }
}

extension RegisteItemViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: 850.adjusted) // 원하는 크기 설정
  }
}
