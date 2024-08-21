//
//  PurchaseViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/15/24.
//

import UIKit

import Then
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

struct OrderModel {
  let productId: String
  let optionList: [Int]
  
}

final class PurchaseViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  
  var orderModel: OrderModel = .init(productId: "", optionList: [])
  
  // PublishSubject 선언
  private let productSubject = PublishSubject<[Product]>()
  private let addressSubject = PublishSubject<[Address]>()
  private let transactionInfoSubject = PublishSubject<[Info]>()
  private let purchaseInfoSubject = PublishSubject<[PurchaseModel]>()
  private let termsSubject = PublishSubject<[String]>()
  
  var isEmptyAddress: Bool = false
  
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
  private let button = DdanziButton(title: "구매하기")
  
  override func viewWillAppear(_ animated: Bool) {
    self.tabBarController?.tabBar.isHidden = true
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
      })
      .disposed(by: disposeBag)
    
    button.rx.tap
      .bind {
        self.navigationController?.pushViewController(PushSettingViewController(), animated: false)
      }
      .disposed(by: disposeBag)
  }
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
          return cell
        case 3:
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PayAmountCollectionViewCell.className, for: indexPath) as! PayAmountCollectionViewCell
          if let payAmount = item as? PurchaseModel {
            cell.configurePayAmount(payAmount)
          }
          return cell
        case 4:
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TermsCollectionViewCell.className, for: indexPath) as! TermsCollectionViewCell
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
  
  private func fetchOrderInfo() {
    Providers.OrderProvider.request(target: .fetchOrderInfo(orderModel.productId),
                                    instance: BaseResponse<FetchOrderResponseDTO>.self) { result in
      guard let data = result.data else { return }
      
      let products = [Product(imageURL: data.imgURL, productName: data.productName, price: data.totalPrice.toKoreanWon())]
      // 주소 정보 중에 하나라도 null 이면 주소 등록 쪽으로 이동
      var addresses: [Address] = []
      if let recipient = data.addressInfo.recipient,
         let address = data.addressInfo.address,
         let zipCode = data.addressInfo.zipCode,
         let recipientPhone = data.addressInfo.recipientPhone {
        addresses = [Address(name: recipient, address: "\(address) (\(zipCode))", phone: recipientPhone)]
      } else {
        self.isEmptyAddress = true
      }
      let transactionInfos = [Info(title: "결제 수단", info: "")]
      let purchaseInfos = [
        PurchaseModel(originPrice: data.originPrice, discountPrice: data.discountPrice, chargePrice: data.charge, totalPrice: data.totalPrice)
      ]
      let terms = ["동의 약관"]
      
      // Subject에 이벤트 방출
      self.productSubject.onNext(products)
      self.addressSubject.onNext(addresses)
      self.transactionInfoSubject.onNext(transactionInfos)
      self.purchaseInfoSubject.onNext(purchaseInfos)
      self.termsSubject.onNext(terms)
    }
  }
  
}

extension PurchaseViewController {
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
                                                                       heightDimension: .estimated(94)),
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
                                                                       heightDimension: .estimated(233)),
                                                     subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 5, leading: 20, bottom: 10, trailing: 20)
        
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
                                                                       heightDimension: .estimated(187)),
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
