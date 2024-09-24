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
import Amplitude

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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    Amplitude.instance().logEvent("view_sell", withEventProperties: ["product_id": info.productID])
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
        Amplitude.instance().logEvent("click_sell_next", withEventProperties: ["product_id": owner.info.productID])
        if !owner.info.isAccountExist {
          let alertVC = CustomAlertViewController(title: "잠시만요!", content: "상품 판매금액 정산을 위해 입금 받으실 대표계좌 등록이 필요합니다.", buttonText: "계좌 등록 하러 가기", subButton: nil)
          
          alertVC.primaryButtonTap
            .subscribe(onNext: { _ in
              owner.navigateToAccountAdd(dueDate: dueDate)
            })
            .disposed(by: owner.disposeBag)
          alertVC.modalPresentationStyle = .overFullScreen
          owner.present(alertVC, animated: false, completion: nil)
        } else {
          owner.registeItem(due: dueDate)
        }
      }
      .disposed(by: disposeBag)
    
    navigationBar.cancelButtonTap
      .subscribe(with: self) { owner, _ in
        Amplitude.instance().logEvent("click_sell_quit")
        owner.navigationController?.popViewController(animated: true)
      }
      .disposed(by: disposeBag)
  }
  
  private func configureCollectionView() {
    collectionView.dataSource = self
    collectionView.delegate = self
  }
  
  private func navigateToAccountAdd(dueDate: String) {
    let accountAddVC = AccountAddViewController(bankAccountId: nil)
    
    // AccountAddViewController의 accountRegisteredRelay를 구독
    accountAddVC.accountRegisteredRelay
      .subscribe(onNext: { [weak self] isRegistered in
        guard let self = self else { return }
        if isRegistered {
          self.info.isAccountExist = true
          self.registeItem(due: dueDate) // 계좌 등록이 완료되면 나머지 플로우 진행
        }
      })
      .disposed(by: disposeBag)
    self.navigationController?.pushViewController(accountAddVC, animated: true)
  }
  
  private func registeItem(due: String) {
    let body = RegisteItemBody(productId: info.productID, productName: info.productName, receivedDate: due, registeredImage: info.imgURL)
    Providers.ItemProvider.request(target: .registeItem(body: body), instance: BaseResponse<RegisteItemDTO>.self) { response in
      guard let data = response.data else { return }
      let registeCompleteVC = RegisteCompleteViewController(response: data)
      let pushVC = PushSettingViewController(isSelling: true, orderId: "", response: data)
      
      PermissionManager.shared.checkPermission(for: .notification)
        .observe(on: MainScheduler.instance)
        .bind(with: self, onNext: { owner, isAllow in
          Amplitude.instance().logEvent("complete_sell_adjustment", withEventProperties: ["item_id": data.itemId])
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
    cell.isReadyToRegister
      .subscribe(onNext: { [weak self] isReady in
        guard let self = self else { return }
        self.registeButton.setEnable(isEnable: isReady)
      })
      .disposed(by: disposeBag)
    return cell
    
  }
}

extension RegisteItemViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: 830.adjusted)
  }
}
