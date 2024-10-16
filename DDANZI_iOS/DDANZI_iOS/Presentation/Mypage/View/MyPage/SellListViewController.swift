//
//  SellListViewController.swift
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

final class SellListViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private let listTypeRelay = BehaviorRelay<ListType>(value: .sales)
  private let sellProductRelay = BehaviorRelay<[ProductInfoModel]>(value: [])
  private var isEditingMode = BehaviorRelay<Bool>(value: false)
  
  private let navigationBar = CustomNavigationBarView(navigationBarType: .normal,
                                                      title: "판매 목록")
  private let headerView = ProductListHeaderView(isEditable: true)
  private let collectionView = UICollectionView(frame: .zero,
                                                collectionViewLayout: .init()).then {
    $0.backgroundColor = .white
    $0.register(MyProductCollectionViewCell.self,
                forCellWithReuseIdentifier: MyProductCollectionViewCell.identifier)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = true
    fetchSaleProduct()
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    fetchSaleProduct()
    setUI()
    configureCollectionView()
    bind()
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
    navigationBar.backButtonTap
      .subscribe(onNext: { [weak self] in
        self?.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
    
    headerView.editButton.rx.tap
      .withLatestFrom(isEditingMode)
      .map { !$0 }
      .bind(to: isEditingMode)
      .disposed(by: disposeBag)
  }
  
  private func configureCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: (view.frame.width-50)/2, height: 260)
    layout.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
    collectionView.collectionViewLayout = layout
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, ProductInfoModel>>(
      configureCell: { [weak self] dataSource, collectionView, indexPath, item in
        guard let self = self else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyProductCollectionViewCell.identifier, for: indexPath) as! MyProductCollectionViewCell
        cell.bindData(image: item.imageURL,
                      title: item.title,
                      beforePrice: item.beforePrice,
                      price: item.price,
                      heartCount: item.heartCount,
                      itemId: item.id)
        cell.listType = self.listTypeRelay.value
        
        self.isEditingMode
          .map { !$0 }
          .bind(to: cell.deleteButton.rx.isHidden)
          .disposed(by: cell.disposeBag)
        
        cell.deleteButton.rx.tap
          .subscribe(with: self) { owner, _ in
            
            var currentProducts = self.sellProductRelay.value
            currentProducts.removeAll { $0.id == item.id }
            self.sellProductRelay.accept(currentProducts)
          }
          .disposed(by: cell.disposeBag)
        
        return cell
      }
    )
    
    sellProductRelay
      .map { [SectionModel(model: "Section 1", items: $0)] }
      .bind(to: collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    
    collectionView.rx.modelSelected(ProductInfoModel.self)
      .subscribe(onNext: { [weak self] product in
        guard let self = self else { return }
        let detailVC = SalesDetailViewController(productId: "\(product.id)")
        self.navigationController?.pushViewController(detailVC, animated: true)
      })
      .disposed(by: disposeBag)
    
    listTypeRelay.accept(.sales)
    collectionView.reloadData()
  }
  
  
  private func fetchSaleProduct() {
    Providers.MypageProvider.request(target: .fetchUserSale, instance: BaseResponse<UserSaleResponseDTO>.self) { [weak self] result in
      guard let self = self else { return }
      guard let data = result.data else { return }
      
      let products: [ProductInfoModel] = data.itemProductList.map { product in
          .init(id: product.itemID, imageURL: product.imgURL, title: product.productName, beforePrice: product.originPrice.toKoreanWon(), price: product.salePrice.toKoreanWon(), heartCount: product.interestCount)
      }
      
      headerView.setCount(count: data.totalCount)
      self.sellProductRelay.accept(products)
    }
  }
  
}
