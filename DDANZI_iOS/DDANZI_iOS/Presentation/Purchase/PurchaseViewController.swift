//
//  PurchaseViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/15/24.
//

import UIKit

import Then
import SnapKit
import Lottie
import RxSwift
import RxCocoa
import RxDataSources

import iamport_ios
import Amplitude

final class PurchaseViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  
  var orderModel: OrderModel = .init(productId: "", optionList: [])
  var selectedTerms = BehaviorRelay<[Bool]>(value: [false, false])
  
  // PublishSubject
  private let productSubject = PublishSubject<[Product]>()
  private let addressSubject = PublishSubject<[Address]>()
  private let transactionInfoSubject = PublishSubject<[Info]>()
  private let purchaseInfoSubject = PublishSubject<[PurchaseModel]>()
  private let termsSubject = PublishSubject<[String]>()
  
  private let addressSelectedSubject = BehaviorRelay<Bool>(value: false)
  private let paymentMethodSelectedSubject = BehaviorRelay<Bool>(value: false)
  private let selectedPaymentMethod = BehaviorRelay<Payment?>(value: nil)
  private let termsAgreeSubject = BehaviorRelay<[Bool]>(value: [false, false])
  
  private var merchanUID: String = ""
  
  var isEmptyAddress: Bool = false
  
  var payment: PaymentModel = .init(productId: "", totalPrice: 0, charge: 0)
  var paymentMethod: Payment = .card
  var productName: String = ""
  
  let navigationBar = CustomNavigationBarView(navigationBarType: .cancel, title: "구매하기")
  let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.register(PurchaseHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: PurchaseHeaderView.className)
    $0.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.className)
    $0.register(PayCollectionViewCell.self, forCellWithReuseIdentifier: PayCollectionViewCell.className)
    $0.register(AddressCollectionViewCell.self, forCellWithReuseIdentifier: AddressCollectionViewCell.className)
    $0.register(PayAmountCollectionViewCell.self, forCellWithReuseIdentifier: PayAmountCollectionViewCell.className)
    $0.register(TermsCollectionViewCell.self, forCellWithReuseIdentifier: TermsCollectionViewCell.className)
  }
  
  private let bottomButtonView = UIView().then {
    $0.backgroundColor = .white
    $0.addShadow(offset: .init(width: 0, height: 2), opacity: 0.4)
  }
  private let button = DdanziButton(title: "구매하기", enable: false)
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = true
    Amplitude.instance().logEvent("view_purchase", withEventProperties: ["product_id": payment.productId])
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchOrderInfo()
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
    view.addSubviews(navigationBar,
                     collectionView,
                     bottomButtonView)
    bottomButtonView.addSubview(button)
  }
  
  private func setConstraints() {
    navigationBar.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(navigationBar.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().inset(100)
    }
    
    bottomButtonView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(92)
    }
    
    button.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(12)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(50)
    }
  }
  
  private func bind() {
    navigationBar.cancelButtonTap
      .subscribe(onNext: { [weak self] in
        self?.navigationController?.popViewController(animated: true)
        Amplitude.instance().logEvent("click_purchase_quit")
      })
      .disposed(by: disposeBag)
    
    button.rx.tap
      .withUnretained(self)
      .bind { owner,_ in
        Amplitude.instance().logEvent("click_purchase_purchase")
        self.requestPayment(payment: self.payment)
      }
      .disposed(by: disposeBag)
    
    
    Observable.combineLatest(termsAgreeSubject, paymentMethodSelectedSubject, addressSelectedSubject)
      .map { termsAgreed, paymentSelected, addressSelected in
        termsAgreed.allSatisfy { $0 } && paymentSelected && addressSelected
      }
      .bind(with: self, onNext: { owner, isSelected in
        if isSelected {
          owner.button.setEnable()
        }
      })
      .disposed(by: disposeBag)
    
    selectedPaymentMethod
      .withUnretained(self)
      .subscribe(onNext: { owner, payment in
        if let payment = payment {
          owner.paymentMethod = payment
        }
      })
      .disposed(by: disposeBag)
    
  }
  
  private func requestPayment(payment: PaymentModel){
    paymentStart(productID: payment.productId, charge: payment.charge, totalPrice: payment.totalPrice, method: paymentMethod)
      .observe(on: MainScheduler.instance)  // 메인 스레드에서 후속 작업을 수행
      .flatMap { [weak self] merchantUID -> Single<IamportResponse?> in
        guard let self = self else { return Single.just(nil) }
        self.merchanUID = merchantUID
        
        let paymentData = self.createPaymentData(merchantUID: merchantUID)
        
        return Single<IamportResponse?>.create { single in
          Iamport.shared.payment(navController: self.navigationController ?? UINavigationController(),
                                 userCode: Config.impCode,
                                 payment: paymentData) { response in
            single(.success(response))
          }
          
          return Disposables.create()
        }
      }
      .subscribe(onSuccess: { [weak self] response in
        self?.paymentCallback(response)
      }, onFailure: { [weak self] error in
        self?.showAlert(title: "결제 오류 발생", message: "알 수 없는 원인으로 결제에 실패했습니다.")
      })
      .disposed(by: disposeBag)
  }
  
  
  private func createPaymentData(merchantUID: String) -> IamportPayment {
    return  IamportPayment(
      pg: Config.pgPayment,
      merchant_uid: merchantUID,
      amount: "\(payment.totalPrice)").then {
        $0.pay_method = paymentMethod.rawValue
        $0.name = productName
        $0.buyer_name = UserDefaults.standard.string(forKey: .name)
        $0.app_scheme = "ddanzi" // 앱복귀를 위한 앱스킴
      }
  }
  
  private func paymentCallback(_ response: IamportResponse?) {
    DdanziLoadingView.shared.startAnimating()
    
    // Response가 없거나 실패한 경우 에러 처리
    guard let response = response else {
      DdanziLoadingView.shared.stopAnimating()
      showAlert(title: "결제 오류 발생", message: "알 수 없는 원인으로 결제에 실패했습니다.")
      return
    }
    
    // 결제 성공 여부와 상태 결정
    let paymentSuccess = response.success ?? false
    
    // 결제 실패 시 로딩 종료 및 에러 처리
    guard paymentSuccess else {
      DdanziLoadingView.shared.stopAnimating()
      showAlert(title: "결제 실패", message: "결제가 실패했습니다. 다시 시도해주세요.")
      return
    }
    
    let payStatus = "PAID"
    
    // `paymentCompleted`와 `executePayment`를 순차적으로 호출
    paymentCompleted(orderId: merchanUID, payStatus: payStatus)
      .flatMap { [weak self] _ -> Single<(Bool, String?)> in
        guard let self = self else { return Single.just((false, nil)) }
        
        // `executePayment` 호출
        return self.executePayment(orderId: self.merchanUID, selecteOption: [])
      }
      .observe(on: MainScheduler.instance) // 메인 스레드에서 UI 업데이트
      .subscribe(onSuccess: { [weak self] isSuccess, orderId in
        guard let self = self else { return }
        DdanziLoadingView.shared.stopAnimating()
        if isSuccess, let orderId = orderId {
          PermissionManager.shared.checkPermission(for: .notification)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] isAllow in
              Amplitude.instance().logEvent("complete_purchase_adjustment", withEventProperties: ["item_id" : self?.payment.productId])
              let nextVC = isAllow ? PurchaseCompleteViewController(orderId: orderId) : PushSettingViewController(orderId: orderId, response: .init(itemId: "", productName: "", imgUrl: "", salePrice: 0))
              self?.navigationController?.pushViewController(nextVC, animated: true)
            }
            .disposed(by: self.disposeBag)
        } else {
          self.showAlert(title: "결제 실패", message: "알 수 없는 원인으로 결제 실패입니다.")
        }
      }, onFailure: { [weak self] error in
        DdanziLoadingView.shared.stopAnimating()
        self?.showAlert(title: "결제 오류 발생", message: "알 수 없는 원인으로 결제에 실패했습니다.")
      })
      .disposed(by: disposeBag)
  }
  
  
  private func fetchOrderInfo() {
    Providers.OrderProvider.request(target: .fetchOrderInfo(orderModel.productId),
                                    instance: BaseResponse<FetchOrderResponseDTO>.self) { result in
      guard let data = result.data else { return }
      
      let products = [Product(imageURL: data.imgURL, productName: data.productName, price: data.totalPrice.toKoreanWon())]
      var addresses: [Address] = []
      if let recipient = data.addressInfo.recipient,
         let address = data.addressInfo.address,
         let zipCode = data.addressInfo.zipCode,
         let recipientPhone = data.addressInfo.recipientPhone {
        addresses = [Address(addressId: nil, name: recipient, address: "\(address) (\(zipCode))", phone: recipientPhone)]
        self.addressSelectedSubject.accept(true)
      } else {
        self.addressSelectedSubject.accept(false)
        self.isEmptyAddress = true
      }
      let transactionInfos = [Info(title: "결제 수단", info: "")]
      let purchaseInfos = [
        PurchaseModel(originPrice: data.originPrice, discountPrice: data.discountPrice, chargePrice: data.charge, totalPrice: data.totalPrice)
      ]
      let terms = ["동의 약관"]
      
      // 결제 정보 생성
      self.productName = data.productName
      self.payment = .init(
        productId: data.productId,
        totalPrice: data.totalPrice,
        charge: data.charge
      )
      
      // Subject에 이벤트 방출
      self.productSubject.onNext(products)
      self.addressSubject.onNext(addresses)
      self.transactionInfoSubject.onNext(transactionInfos)
      self.purchaseInfoSubject.onNext(purchaseInfos)
      self.termsSubject.onNext(terms)
    }
  }
  
  /// 결제 시작 API 통신
  private func paymentStart(productID: String, charge: Int, totalPrice: Int, method: Payment) -> Single<String> {
    return Single<String>.create { single in
      let body = PaymentRequestBody(productId: productID, charge: charge, totalPrice: totalPrice, method: method)
      
      Providers.PaymentProvider.request(target: .startPayment(body: body), instance: BaseResponse<PaymentStartResponseDTO>.self) { response in
        guard let data = response.data else {
          single(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Payment Start Failed"])))
          self.showAlert(title: "결제 요청 실패", message: "결제 정보를 찾을 수 없습니다. (\(response.status): \(response.message))")
          return
        }
        single(.success(data.orderID))
      }
      
      return Disposables.create()
    }
  }
  
  /// 결제 완료 API 통신
  private func paymentCompleted(orderId: String, payStatus: String) -> Single<Void> {
    return Single<Void>.create { single in
      let body = PaymentCompletedBody(orderId: orderId, payStatus: payStatus)
      
      Providers.PaymentProvider.request(target: .completedPayment(body: body), instance: BaseResponse<PaymentCompletedDTO>.self) { response in
        guard response.data != nil else {
          single(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Payment Completed Failed"])))
          return
        }
        single(.success(()))
      }
      
      return Disposables.create()
    }
  }
  
  private func executePayment(orderId: String, selecteOption: [Int]) -> Single<(Bool, String?)> {
    return Single.create { single in
      let body = ExecuteRequestBody(orderId: orderId, selectedOptionDetailIdList: selecteOption)
      Providers.OrderProvider.request(target: .executeOrder(body: body), instance: BaseResponse<ExecuteOrderResponseDTO>.self) { response in
        guard let data = response.data else {
          single(.success((false, nil)))
          return
        }
        single(.success((true, data.orderId)))
      }
      
      return Disposables.create()
    }
  }
  
  private func showAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  
}

// MARK: CollectionView

extension PurchaseViewController {
  private func configureCollectionView() {
    collectionView.collectionViewLayout = createLayout()
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Any>>(
      configureCell: { dataSource, collectionView, indexPath, item in
        switch indexPath.section {
        case 0:
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.className, for: indexPath) as! ProductCollectionViewCell
          if let product = item as? Product {
            cell.bindData(title: product.productName,
                          price: product.price,
                          imageURL: product.imageURL)
          }
          return cell
        case 1:
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddressCollectionViewCell.className, for: indexPath) as! AddressCollectionViewCell
          if let address = item as? Address {
            cell.configureView(name: address.name, address: address.address, phone: address.phone)
          }
          return cell
        case 2:
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PayCollectionViewCell.className, for: indexPath) as! PayCollectionViewCell
          cell.isPaymentSelected
            .bind(to: self.paymentMethodSelectedSubject)
            .disposed(by: cell.disposeBag)
          cell.selectedPayment
            .bind(to: self.selectedPaymentMethod)
            .disposed(by: cell.disposeBag)
          return cell
        case 3:
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PayAmountCollectionViewCell.className, for: indexPath) as! PayAmountCollectionViewCell
          if let payAmount = item as? PurchaseModel {
            cell.configurePayAmount(payAmount)
          }
          return cell
        case 4:
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TermsCollectionViewCell.className, for: indexPath) as! TermsCollectionViewCell
          cell.selectedTerms
            .bind(to: self.termsAgreeSubject)
            .disposed(by: self.disposeBag)
          return cell
        default:
          return UICollectionViewCell()
        }
      },
      configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        if kind == UICollectionView.elementKindSectionHeader {
          guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PurchaseHeaderView.className, for: indexPath) as? PurchaseHeaderView else {
            return UICollectionReusableView()
          }
          header.configureHeader(title: dataSource.sectionModels[indexPath.section].model,
                                 isEditable: indexPath.section == 1,
                                 isEmptyAddress: self.isEmptyAddress)
          // 주소 유무를 반영
          if self.isEmptyAddress {
            header.buttonTapRelay
              .subscribe(onNext: { [weak self] in
                Amplitude.instance().logEvent("click_purchase_address")
                guard let self = self else { return }
                let addressListVC = AddressSettingViewController()
                self.navigationController?.pushViewController(addressListVC, animated: true)
              })
              .disposed(by: header.disposeBag)
          }
          
          return header
        }
        return UICollectionReusableView()
      }
    )
    
    Observable.combineLatest(
      productSubject.map { SectionModel(model: "상품 정보", items: $0 as [Any]) },
      addressSubject.map { SectionModel(model: "배송지 정보", items: $0 as [Any]) },
      transactionInfoSubject.map { SectionModel(model: "결제 수단", items: $0 as [Any]) },
      purchaseInfoSubject.map { SectionModel(model: "결제 금액", items: $0 as [Any]) },
      termsSubject.map { SectionModel(model: "약관", items: $0 as [Any]) }
    )
    .map { [$0, $1, $2, $3, $4] }
    .bind(to: collectionView.rx.items(dataSource: dataSource))
    .disposed(by: disposeBag)
    
    collectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
  }
  
  func createLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
      switch sectionNumber {
      case 0:
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                         heightDimension: .estimated(125)),
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [
          NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                        heightDimension: .absolute(30)),
                                                      elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        return section
      case 1:
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                       heightDimension: .estimated(146)),
                                                     subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 5, leading: 20, bottom: 10, trailing: 20)
        
        section.boundarySupplementaryItems = [
          NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                        heightDimension: .absolute(40)),
                                                      elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        return section
      case 2:
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                       heightDimension: .estimated(60)),
                                                     subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 5, leading: 20, bottom: 10, trailing: 20)
        
        section.boundarySupplementaryItems = [
          NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                        heightDimension: .absolute(40)),
                                                      elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        return section
      case 3:
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                       heightDimension: .estimated(190)),
                                                     subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 5, leading: 20, bottom: 0, trailing: 20)
        
        section.boundarySupplementaryItems = [
          NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                        heightDimension: .absolute(40)),
                                                      elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        return section
      case 4:
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        item.contentInsets = .init(top: 7, leading: 0, bottom: 7, trailing: 0)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                       heightDimension: .estimated(150)),
                                                     subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        return section
      default:
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5),
                                                            heightDimension: .estimated(260)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                         heightDimension: .estimated(260)),
                                                       subitems: [item, item])
        group.interItemSpacing = .fixed(10)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 14, leading: 10, bottom: 20, trailing: 10)
        
        return section
      }
    }
  }
}

extension PurchaseViewController: UICollectionViewDelegate { }
