//
//  BuyListViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/28/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources

final class PurchaseListViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private let listTypeRelay = BehaviorRelay<ListType>(value: .sales)
  private let purchaseProductRelay = BehaviorRelay<[PurchaseProductModel]>(value: [])
  private let viewModel: PurchaseListViewModel
  
  
  private let navigationBar = CustomNavigationBarView(navigationBarType: .normal,
                                                      title: "구매 목록")
  private let headerView = ProductListHeaderView(isEditable: false)
  private let collectionView = UICollectionView(frame: .zero,
                                                collectionViewLayout: .init()).then {
    $0.backgroundColor = .white
    $0.register(MyProductCollectionViewCell.self,
                forCellWithReuseIdentifier: MyProductCollectionViewCell.identifier)
  }
  
  init() {
    self.viewModel = PurchaseListViewModel(products: purchaseProductRelay.value)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = true
    fetchPurchaseProduct()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    fetchPurchaseProduct()
    setUI()
    bind()
    configureCollectionView()
  }
  
  private func setUI() {
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    view.addSubviews(navigationBar,
                     headerView,
                     collectionView)
  }
  
  private func setConstraints() {
    navigationBar.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
    }
    
    headerView.snp.makeConstraints {
      $0.top.equalTo(navigationBar.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(35)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(headerView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func bind() {
    headerView.bind(to: viewModel)
    
    navigationBar.backButtonTap
      .subscribe(onNext: { [weak self] in
        self?.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
  }
  
  
  private func configureCollectionView() {
    collectionView.delegate = nil
    collectionView.dataSource = nil
    
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: (view.frame.width-50)/2, height: 260)
    layout.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
    collectionView.collectionViewLayout = layout
    
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, PurchaseProductModel>>(
      configureCell: { [weak self] dataSource, collectionView, indexPath, item in
        guard let self = self else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyProductCollectionViewCell.identifier, for: indexPath) as! MyProductCollectionViewCell
        cell.bindData(
          image: item.imgURL,
          title: item.name,
          beforePrice: item.beforePrice,
          price: item.price,
          heartCount: 0,
          completedAt: item.completedAt.toKoreanDateTimeFormat() ?? "", itemId: item.productID
        )
        cell.listType = self.listTypeRelay.value
        return cell
      }
    )
    
    purchaseProductRelay
      .map { [SectionModel(model: "Section 1", items: $0)] }
      .bind(to: collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    
    collectionView.rx.modelSelected(ProductInfoModel.self)
      .subscribe(onNext: { [weak self] product in
        guard let self = self else { return }
        let detailVC = ProductDetailViewController(productId: "\(product.id)")
        self.navigationController?.pushViewController(detailVC, animated: true)
      })
      .disposed(by: disposeBag)
    
    listTypeRelay.accept(.purchase)
    collectionView.reloadData()
    
    
    collectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    
    collectionView.rx.itemSelected
      .subscribe(onNext: { [weak self] indexPath in
        guard let self = self else { return }
        if indexPath.section == 0 {
          let orderId = purchaseProductRelay.value[indexPath.row].orderId
          let detailVC = PurchaseDetailViewController(orderId: orderId)
          self.navigationController?.pushViewController(detailVC, animated: true)
        }
      })
      .disposed(by: disposeBag)
  }
  
  private func fetchPurchaseProduct() {
    Providers.MypageProvider.request(target: .fetchUserPurchase, instance: BaseResponse<UserPurchaseResponesDTO>.self) { [weak self] result in
      guard let self = self else { return }
      guard let data = result.data else { return }
      
      let products: [PurchaseProductModel] = data.orderProductList.map { product in
          .init(productID: product.productID,
                name: product.productName,
                imgURL: product.imgURL,
                beforePrice: product.originPrice.toKoreanWon(),
                price: product.salePrice.toKoreanWon(),
                completedAt: product.paidAt ?? "",
                orderId: product.orderID)
      }
      
      headerView.setCount(count: data.totalCount)
      self.purchaseProductRelay.accept(products)
    }
  }
  
}

extension PurchaseListViewController: UICollectionViewDelegate {
  
}
