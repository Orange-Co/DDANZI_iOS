//
//  PurchaseCompleteViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/16/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources
import Amplitude

final class PurchaseCompleteViewController: UIViewController {
  
  // MARK: - Property
  private let disposeBag = DisposeBag()
  private let orderId: String
  
  var product: [Product] = []
  var address: [Address] = []
  var transactionInfo: [Info] = []
  var purchaseInfo: [Info] = []
  let saleInfo: [PriceModel] = []
  var totalPrice: Int = 0
  
  // MARK: - UI
  private let navigationBarView = CustomNavigationBarView(navigationBarType: .home, title: "주문 완료").then {
    $0.backButton.isHidden = true
  }
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
    $0.isHidden = true
    $0.backgroundColor = .white
    $0.register(DetailSectionHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: DetailSectionHeaderView.className)
    $0.register(TotalPriceFooterView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: TotalPriceFooterView.className)
    $0.register(CompleteCollectionViewCell.self, forCellWithReuseIdentifier: CompleteCollectionViewCell.className)
    $0.register(ProductInfoCollectionViewCell.self, forCellWithReuseIdentifier: ProductInfoCollectionViewCell.className)
    $0.register(SellerCollectionViewCell.self, forCellWithReuseIdentifier: SellerCollectionViewCell.className)
    $0.register(AddressCollectionViewCell.self, forCellWithReuseIdentifier: AddressCollectionViewCell.className)
    $0.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: InfoCollectionViewCell.className)
  }
  private let bottomButtonView = UIView().then {
    $0.backgroundColor = .white
    $0.addShadow(offset: .init(width: 0, height: 2), opacity: 0.4)
  }
  
  private let buttonStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 10
    $0.alignment = .center
    $0.distribution = .fillEqually
  }
  private let keepButton = UIButton().then {
    $0.setTitle("계속 쇼핑하기", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.titleLabel?.font = .body3Sb16
    $0.backgroundColor = .white
    $0.makeCornerRound(radius: 10)
    $0.makeBorder(width: 1, color: .black)
  }
  private let detailButton = DdanziButton(title: "상세 내역 보러가기")
  
  // MARK: - Initializer
  init(orderId: String) {
    self.orderId = orderId
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycles
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchOrderInfo(orderId: orderId)
    setUI()
    bind()
  }
  
  // MARK: - Layout
  private func setUI() {
    view.backgroundColor = .white
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    view.addSubviews(navigationBarView,
                     collectionView,
                     bottomButtonView)
    bottomButtonView.addSubviews(buttonStackView)
    buttonStackView.addArrangedSubviews(keepButton, detailButton)
  }
  
  private func setConstraints() {
    navigationBarView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(navigationBarView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().inset(100)
    }
    
    bottomButtonView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(92)
    }
    
    buttonStackView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(12)
      $0.leading.trailing.equalToSuperview().inset(20)
    }
    
    [keepButton, detailButton].forEach {
      $0.snp.makeConstraints {
        $0.height.equalTo(50)
      }
    }
  }
  
  // MARK: - Method
  private func bind() {
    navigationBarView.cancelButtonTap
      .subscribe(onNext: { [weak self] in
        self?.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
    
    
      navigationBarView.homeButtonTap
        .subscribe(onNext: { [weak self] in
          self?.navigationController?.popToRootViewController(animated: true)
        })
        .disposed(by: disposeBag)
    
    keepButton.rx.tap
      .bind {
        // 계속 쇼핑하기
        Amplitude.instance().logEvent("click_purchase_adjustment_add")
        let homeViewController = DdanziTabBarController()
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
        sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: homeViewController)
      }
      .disposed(by: disposeBag)
    
    detailButton.rx.tap
      .withUnretained(self)
      .bind { owner, _ in
        // 구매 상세로 이동
        Amplitude.instance().logEvent("click_purchase_adjustment_check")
        
        // TabBarController의 두 번째 탭으로 이동
        if let tabBarController = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let tabController = tabBarController.window?.rootViewController as? DdanziTabBarController {
          tabController.selectedIndex = 1  // 두 번째 탭으로 이동
          
          // 두 번째 탭의 NavigationController에 새로운 뷰를 푸시
          if let navController = tabController.viewControllers?[1] as? UINavigationController {
            let newViewController = PurchaseListViewController() // 새로운 ViewController 생성
            navController.pushViewController(newViewController, animated: true)
          }
        }
      }
      .disposed(by: disposeBag)
  }
  
  // MARK: - Networking
  private func fetchOrderInfo(orderId: String) {
    DdanziLoadingView.shared.startAnimating()
    Providers.OrderProvider.request(target: .fetchOrderDetail(orderId), instance: BaseResponse<FetchOrderDetailResponseDTO>.self) { response in
      guard let data = response.data else { return }
      let paidAt = data.paidAt ?? ""
      self.product = [.init(imageURL: data.imgURL, productName: data.productName, price: data.totalPrice.toKoreanWon())]
      self.address = [.init(name: data.addressInfo.recipient ?? "", address: data.addressInfo.address ?? "", phone: data.addressInfo.recipientPhone ?? "")]
      self.transactionInfo = [Info(title: "결제 수단", info: data.paymentMethod),
                              Info(title: "결제 일자", info: paidAt.toKoreanDateTimeFormat() ?? paidAt)]
      self.purchaseInfo = [Info(title: "상품 금액", info: data.originPrice.toKoreanWon()),
                           Info(title: "할인가", info: "-\(data.discountPrice.toKoreanWon())"),
                           Info(title: "수수료", info: data.charge.toKoreanWon())]
      self.totalPrice = data.totalPrice
      
      DispatchQueue.main.async {
          self.configureCollectionView()
          self.collectionView.isHidden = false
          self.collectionView.reloadData()
      }

    }
  }
  
}

// MARK: - CollectionView Configuration
extension PurchaseCompleteViewController {
  private func configureCollectionView() {
    let sections: [SectionModel<String, Any>] = [
      SectionModel(model: "상품 정보", items: product),
      SectionModel(model: "배송지", items: address),
      SectionModel(model: "거래 정보", items: transactionInfo),
      SectionModel(model: "결제 정보", items: purchaseInfo),
    ]
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Any>>(
      configureCell: { dataSource, collectionView, indexPath, item in
        switch indexPath.section {
        case 0:
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompleteCollectionViewCell.className, for: indexPath) as! CompleteCollectionViewCell
          if let product = item as? Product {
            cell.bindData(title: product.productName,
                          price: product.price,
                          imageURL: product.imageURL)
          }
          return cell
        case 1:
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddressCollectionViewCell.className, for: indexPath) as! AddressCollectionViewCell
          if let address = item as? Address {
            cell.configureView(name: address.name,
                               address: address.address,
                               phone: address.phone)
          }
          return cell
        case 2:
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCollectionViewCell.className, for: indexPath) as! InfoCollectionViewCell
          if let transaction = item as? Info {
            cell.bindData(title: transaction.title, info: transaction.info)
          }
          return cell
        case 3:
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
          guard indexPath.section == 3, // 마지막 섹션만 체크
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TotalPriceFooterView.className, for: indexPath) as? TotalPriceFooterView else {
            return UICollectionReusableView()
          }
          footer.configureFooter(totalPrice: self.totalPrice.toKoreanWon())
          return footer
        }
        return UICollectionReusableView()
      }
    )
    
    let items = Observable.just(sections)
    
    items.bind(to: collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    collectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    
    DdanziLoadingView.shared.stopAnimating()
  }
  
  func createLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
      switch sectionNumber {
      case 0:
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .estimated(410)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                         heightDimension: .estimated(410)),
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 20, bottom: 15, trailing: 20)
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
      case 3:
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

extension PurchaseCompleteViewController: UICollectionViewDelegate { }
