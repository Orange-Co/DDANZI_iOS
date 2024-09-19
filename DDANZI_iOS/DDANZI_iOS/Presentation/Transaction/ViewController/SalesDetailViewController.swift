//
//  SalesDetailViewController.swift
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

class SalesDetailViewController: UIViewController {
  
  var status = BehaviorRelay<[Status]>(value: [])
  var product = BehaviorRelay<[Product]>(value: [])
  var nickName = BehaviorRelay<[String]>(value: [])
  var address = BehaviorRelay<[Address]>(value: [])
  var transactionInfo = BehaviorRelay<[Info]>(value: [])
  var purchaseInfo = BehaviorRelay<[Info]>(value: [])
  var totalPrice = BehaviorRelay<String>(value: "")
  var sellStatus = BehaviorRelay<StatusType>(value: .inProgress)
  
  private let disposeBag = DisposeBag()
  var orderId: String = ""
  var imageURL: String = ""
  var PurchaseState: StatusType = .orderComplete
  
  
  private let navigaitonBar = CustomNavigationBarView(navigationBarType: .cancel, title: "판매 상세")
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
    $0.backgroundColor = .white
    $0.register(DetailSectionHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: DetailSectionHeaderView.className)
    $0.register(TotalPriceFooterView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: TotalPriceFooterView.className)
    $0.register(StatusCollectionViewCell.self, forCellWithReuseIdentifier: StatusCollectionViewCell.className)
    $0.register(ProductInfoCollectionViewCell.self, forCellWithReuseIdentifier: ProductInfoCollectionViewCell.className)
    $0.register(SellerCollectionViewCell.self, forCellWithReuseIdentifier: SellerCollectionViewCell.className)
    $0.register(AddressCollectionViewCell.self, forCellWithReuseIdentifier: AddressCollectionViewCell.className)
    $0.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: InfoCollectionViewCell.className)
  }
  private let bottomButtonView = UIView().then {
    $0.backgroundColor = .white
    $0.addShadow(offset: .init(width: 0, height: 2), opacity: 0.4)
  }
  
  private let button = DdanziButton(title: "판매 확정하기")
  
  init(productId: String) {
    super.init(nibName: nil, bundle: nil)
    
    fetchSaleDeatail(orderId: productId)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.tabBarController?.tabBar.isHidden = true
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(updateStatus), name: .didCompleteCopyAction, object: nil)
    
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
    view.addSubviews(navigaitonBar,
                     collectionView,
                     bottomButtonView)
    bottomButtonView.addSubview(button)
  }
  
  private func setConstraints() {
    navigaitonBar.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(navigaitonBar.snp.bottom)
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
  
  private func fetchSaleDeatail(orderId: String) {
    Providers.ItemProvider.request(target: .detailItem(id: orderId), instance: BaseResponse<SellDetailDTO>.self) { response in
      
      guard let data = response.data else { return }
      
      self.orderId = data.orderID ?? ""
      
      self.sellStatus.accept(.init(rawValue: data.status) ?? .inProgress)
      
      self.status.accept([Status(code: data.orderID ?? "", status: .init(rawValue: data.status) ?? .inProgress)])
      self.product.accept([Product(imageURL: data.imgURL,
                                   productName: data.productName,
                                   price: data.originPrice.toKoreanWon())])
      self.nickName.accept([data.buyerNickName ?? ""])
      if let recipient = data.addressInfo.recipient,
         let zipcode = data.addressInfo.zipCode,
         let phone = data.addressInfo.recipientPhone,
         let address = data.addressInfo.address {
        self.address.accept([Address(name: recipient,
                                     address: "(\(zipcode)) \(address)",
                                     phone: phone)])
      }
      self.transactionInfo.accept([Info(title: "결제 수단", info: data.paymentMethod ?? ""),
                                   Info(title: "결제 일자", info: data.paidAt ?? "")])
      self.purchaseInfo.accept([Info(title: "카카오톡 선물하기 가격", info: data.originPrice.toKoreanWon()),
                                Info(title: "판매가", info: data.salePrice.toKoreanWon())])
      self.totalPrice.accept(data.salePrice.toKoreanWon())
    }
  }
  
  private func bind() {
    navigaitonBar.cancelButtonTap
      .subscribe(onNext: { [weak self] in
        self?.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
    
    
    sellStatus
      .withUnretained(self)
      .bind { owner, type in
        switch type {
        case .inProgress, .orderComplete, .notDeposit, .onSale:
          owner.button.titleLabel?.text = "판매 확정하기"
        case .deposit:
          owner.button.titleLabel?.text = "판매 확정하기"
          owner.button.setEnable()
        case .delivery:
          owner.button.titleLabel?.text = "배송 중인 상품입니다."
        case .complete:
          owner.button.titleLabel?.text = "거래가 완료된 상품입니다."
        case .cancel:
          owner.button.titleLabel?.text = "거래가 취소된 상품입니다."
        }
      }
      .disposed(by: disposeBag)
    
    button.rx.tap
      .subscribe(with: self) { owner, _ in
        let copyVC = KakaoCopyViewController(orderId: owner.orderId)
        owner.navigationController?.pushViewController(copyVC, animated: true)
      }
      .disposed(by: disposeBag)

  }
  
  private func configureCollectionView() {
    
    let sections = Observable.combineLatest(status, product, nickName, address, transactionInfo, purchaseInfo) { status, product, nickName, address, transactionInfo, purchaseInfo -> [SectionModel<String, Any>] in
      return [
        SectionModel(model: "거래상태", items: status),
        SectionModel(model: "상품 정보", items: product),
        SectionModel(model: "판매자 정보", items: nickName),
        SectionModel(model: "배송지 정보", items: address),
        SectionModel(model: "거래 정보", items: transactionInfo),
        SectionModel(model: "결제 정보", items: purchaseInfo),
      ]
    }
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Any>>(
      configureCell: { dataSource, collectionView, indexPath, item in
        switch indexPath.section {
        case 0:
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatusCollectionViewCell.className, for: indexPath) as! StatusCollectionViewCell
          if let status = item as? Status {
            cell.configureView(title: status.status.statusString, code: status.code)
          }
          return cell
        case 1:
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductInfoCollectionViewCell.className, for: indexPath) as! ProductInfoCollectionViewCell
          if let product = item as? Product {
            cell.bindData(product: product)
          }
          return cell
        case 2:
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SellerCollectionViewCell.className, for: indexPath) as! SellerCollectionViewCell
          if let nickName = item as? String {
            cell.bindData(nickName: nickName)
          }
          return cell
        case 3:
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddressCollectionViewCell.className, for: indexPath) as! AddressCollectionViewCell
          if let address = item as? Address {
            cell.configureView(name: address.name,
                               address: address.address,
                               phone: address.phone)
          }
          return cell
        case 4:
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCollectionViewCell.className, for: indexPath) as! InfoCollectionViewCell
          if let transaction = item as? Info {
            cell.bindData(title: transaction.title, info: transaction.info)
          }
          return cell
        case 5:
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCollectionViewCell.className, for: indexPath) as! InfoCollectionViewCell
          if let price = item as? Info {
            if indexPath.item == 0 {
              cell.bindData(title: price.title, info: price.info, isBold: true)
            } else {
              cell.bindData(title: price.title, info: price.info)
            }
          }
          return cell
        default:
          return UICollectionViewCell()
        }
      }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        if kind == UICollectionView.elementKindSectionHeader {
          guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DetailSectionHeaderView.className, for: indexPath) as? DetailSectionHeaderView else {
            return UICollectionReusableView()
          }
          header.bindTitle(title: dataSource.sectionModels[indexPath.section].model)
          return header
        }
        if kind == UICollectionView.elementKindSectionFooter {
          guard indexPath.section == 5, // 마지막 섹션만 체크
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TotalPriceFooterView.className, for: indexPath) as? TotalPriceFooterView else {
            return UICollectionReusableView()
          }
          footer.configureFooter(totalPrice: self.totalPrice.value)
          return footer
        }
        return UICollectionReusableView()
      }
    )
    
    sections
      .bind(to: collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    collectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
  }
  
  @objc private func updateStatus() {
    // 상태 업데이트 로직 (필요한 경우 API 다시 호출)
    fetchSaleDeatail(orderId: self.orderId)
    print("Notification을 수신하여 상태를 업데이트했습니다.")
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
}

extension SalesDetailViewController {
  func createLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
      switch sectionNumber {
      case 0:
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                         heightDimension: .estimated(160)),
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 20, bottom: 15, trailing: 20)
        return section
      case 1:
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                       heightDimension: .estimated(139)),
                                                     subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        section.boundarySupplementaryItems = [
          NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                        heightDimension: .absolute(30)),
                                                      elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        
        return section
      case 3:
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
      case 2, 4:
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        item.contentInsets = .init(top: 7, leading: 0, bottom: 7, trailing: 0)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                       heightDimension: .estimated(30)),
                                                     subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = .init(top: 0, leading: 20, bottom: 15, trailing: 20)
        section.boundarySupplementaryItems = [
          NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                        heightDimension: .absolute(40)),
                                                      elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        return section
      case 5:
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        item.contentInsets = .init(top: 7, leading: 0, bottom: 7, trailing: 0)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                       heightDimension: .estimated(30)),
                                                     subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        section.boundarySupplementaryItems = [
          NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                        heightDimension: .absolute(40)),
                                                      elementKind: UICollectionView.elementKindSectionHeader, alignment: .top),
          NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(81)),
                                                      elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        ]
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

extension SalesDetailViewController: UICollectionViewDelegate { }

extension Notification.Name {
  static let didCompleteCopyAction = Notification.Name("didCompleteCopyAction")
}
