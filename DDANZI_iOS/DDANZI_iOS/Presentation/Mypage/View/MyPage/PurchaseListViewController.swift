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
  
  private let dummy = [
    ProductModel(image: UIImage(resource: .image2), title: "상품명", beforePrice: "54,000원", price: "48,000원", heartCount: 78),
    ProductModel(image: UIImage(resource: .image2), title: "상품명", beforePrice: "54,000원", price: "48,000원", heartCount: 78),
    ProductModel(image: UIImage(resource: .image2), title: "상품명", beforePrice: "54,000원", price: "48,000원", heartCount: 78),
    ProductModel(image: UIImage(resource: .image2), title: "상품명", beforePrice: "54,000원", price: "48,000원", heartCount: 78),
    ProductModel(image: UIImage(resource: .image2), title: "상품명", beforePrice: "54,000원", price: "48,000원", heartCount: 78)]
  
  
  private let navigationBar = CustomNavigationBarView(navigationBarType: .normal,
                                                      title: "구매 목록")
  private let headerView = ProductListHeaderView(isEditable: false)
  private let collectionView = UICollectionView(frame: .zero,
                                                collectionViewLayout: .init()).then {
    $0.backgroundColor = .white
    $0.register(MyProductCollectionViewCell.self,
                forCellWithReuseIdentifier: MyProductCollectionViewCell.identifier)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.tabBarController?.tabBar.isHidden = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setUI()
    bind()
    configureCollectionView()
  }
  
  private func setUI() {
    headerView.setCount(count: dummy.count)
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
      $0.top.leading.trailing.equalToSuperview()
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
  }
  
  private func configureCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: (view.frame.width-50)/2, height: 260)
    layout.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
    collectionView.collectionViewLayout = layout
    
    
    let sections: [SectionModel<String, Any>] = [
      SectionModel(model: "Section 1", items: dummy)
    ]
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Any>>(
      configureCell: { dataSource, collectionView, indexPath, item in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyProductCollectionViewCell.identifier, for: indexPath) as! MyProductCollectionViewCell
        if let product = item as? ProductModel {
          cell.bindData(image: product.image,
                        title: product.title,
                        beforePrice: product.beforePrice,
                        price: product.price,
                        heartCount: product.heartCount)
          
            cell.listType = self.listTypeRelay.value
        }
        return cell
      }
    )
    
    let items = Observable.just(sections)
    
    items.bind(to: collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    listTypeRelay.accept(.purchase)
    collectionView.reloadData()
    
    collectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    
    collectionView.rx.itemSelected
      .subscribe(onNext: { [weak self] indexPath in
        guard let self = self else { return }
        if indexPath.section == 0 {
          let detailVC = ProductDetailViewController()
          self.navigationController?.pushViewController(detailVC, animated: true)
        }
      })
      .disposed(by: disposeBag)
  }
}

extension PurchaseListViewController: UICollectionViewDelegate {
  
}
