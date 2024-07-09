//
//  SearchViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/23/24.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay
import RxDataSources

enum CollectionViewState {
  case normal
  case searchResults([ProductModel])
}

class SearchViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private var currentState: CollectionViewState = .normal {
    didSet {
      switch currentState {
      case .normal:
        collectionView.isHidden = false
        searchResultsCollectionView.isHidden = true
      case .searchResults(let results):
        collectionView.isHidden = true
        searchResultsCollectionView.isHidden = false
        updateSearchResults(results)
      }
    }
  }
  var searchKeyword:String = ""
  
  private let searchResults = BehaviorRelay<[ProductModel]>(value: [])
  let rankSearchData: [String] = ["향수", "성년의 날 선물", "여자 향수"]
  let dummyData = [
    ProductModel(image: UIImage(resource: .image2),title: "Product 1", beforePrice: "34,000", price: "28,000", heartCount: 10),
    ProductModel(image: UIImage(resource: .image2), title: "Product 2", beforePrice: "34,000", price: "28,000", heartCount: 20),
    ProductModel(image: UIImage(resource: .image2), title: "Product 3", beforePrice: "34,000", price: "28,000", heartCount: 30),
    ProductModel(image: UIImage(resource: .image2), title: "Product 4", beforePrice: "34,000", price: "28,000", heartCount: 40),
    ProductModel(image: UIImage(resource: .image2), title: "Product 5", beforePrice: "34,000", price: "28,000", heartCount: 50),
    ProductModel(image: UIImage(resource: .image2), title: "Product 6", beforePrice: "34,000", price: "28,000", heartCount: 60)
  ]
  
  
  private let navigationBar = CustomNavigationBarView(navigationBarType: .searching)
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
    $0.register(RankCollectionViewCell.self,
                forCellWithReuseIdentifier: RankCollectionViewCell.identifier)
    $0.register(SearchCollectionViewCell.self,
                forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
    $0.register(SectionHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: SectionHeaderView.identifier)
  }
  
  private lazy var searchResultsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createResultLayout()).then{
    $0.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
    $0.register(SectionHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: SectionHeaderView.identifier)
    $0.backgroundColor = .white
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.isNavigationBarHidden = true
    self.tabBarController?.tabBar.isHidden = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bindNavigation()
    bindCollectionView()
    currentState = .normal
    setUI()
  }
  
  private func setUI() {
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    view.addSubviews(navigationBar, collectionView, searchResultsCollectionView)
  }
  
  private func setConstraints() {
    navigationBar.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(navigationBar.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    searchResultsCollectionView.snp.makeConstraints {
      $0.top.equalTo(navigationBar.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func bindNavigation() {
    navigationBar.backButtonTap
      .subscribe(onNext: { [weak self] in
        self?.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
    
    navigationBar.searchTextField.delegate = self
  }
  
  private func bindCollectionView() {
    collectionView.delegate = nil
    
    let sections: [SectionModel<String, Any>] = [
      SectionModel(model: "인기 검색어", items: rankSearchData),
      SectionModel(model: "최근 본 상품", items: dummyData)
    ]
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Any>>(
      configureCell: { dataSource, collectionView, indexPath, item in
        if indexPath.section == 0 {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RankCollectionViewCell.identifier, for: indexPath) as? RankCollectionViewCell
          if let cell {
            if let rankText = item as? String {
              cell.bindData(labelText: rankText)
            }
            return cell
          }
        } else {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as? SearchCollectionViewCell
          if let cell {
            if let product = item as? ProductModel {
              cell.bindData(productTitle: product.title,
                            beforePrice: product.beforePrice,
                            price: product.price,
                            heartCount: product.heartCount)
              cell.heartButtonTap
                .subscribe(onNext: {
                  print("Heart button tapped on row \(indexPath.row)")
                  // Handle heart button tap
                })
                .disposed(by: cell.disposeBag)
            }
            return cell
          }
        }
        return UICollectionViewCell()
      },
      configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        if kind == UICollectionView.elementKindSectionHeader {
          let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as! SectionHeaderView
          header.bind(title: dataSource.sectionModels[indexPath.section].model)
          return header
        }
        return UICollectionReusableView()
      }
    )
    
    let items = Observable.just(sections)
    
    items.bind(to: collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    collectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    collectionView.rx.itemSelected
      .subscribe(onNext: { [weak self] indexPath in
        guard let self = self else { return }
        if indexPath.section == 1 {
          let detailVC = ProductDetailViewController()
          self.navigationController?.pushViewController(detailVC, animated: true)
        }
      })
      .disposed(by: disposeBag)
  }
  
  private func updateSearchResults(_ results: [ProductModel]) {
    let sections: [SectionModel<String, Any>] = [
      SectionModel(model: "\"\(searchKeyword)\" 검색 결과", items: results)
    ]
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Any>>(
      configureCell: { dataSource, collectionView, indexPath, item in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
        if let product = item as? ProductModel {
          cell.bindData(productTitle: product.title,
                        beforePrice: product.beforePrice,
                        price: product.price,
                        heartCount: product.heartCount)
          cell.heartButtonTap
            .subscribe(onNext: { })
            .disposed(by: cell.disposeBag)
        }
        return cell
      },
      configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as? SectionHeaderView else {
          return UICollectionReusableView()
        }
        
        headerView.bind(title: dataSource.sectionModels[indexPath.section].model, searchKeyword: self.searchKeyword)
        return headerView
      }
    )
    
    let items = Observable.just(sections)
    
    items.bind(to: searchResultsCollectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
  
}

extension SearchViewController {
  private func createLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
      if sectionNumber == 0 {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(1),
                                              heightDimension: .absolute(28))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(1),
                                               heightDimension: .absolute(28))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 20, bottom: 20, trailing: 20)
        
        section.interGroupSpacing = 8
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
      } else if sectionNumber == 1 {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .estimated(260))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(260))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item, item])
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 20, bottom: 20, trailing: 20)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
      }
      return nil
    }
  }
  private func createResultLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
      
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                            heightDimension: .estimated(260))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .estimated(260))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                     subitems: [item, item])
      group.interItemSpacing = .fixed(10)
      
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 20, bottom: 20, trailing: 20)
      
      let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(44))
      let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                               elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
      section.boundarySupplementaryItems = [header]
      
      return section
    }
  }
  
}


extension SearchViewController: UICollectionViewDelegate { }

extension SearchViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    
    if let searchText = textField.text, !searchText.isEmpty {
      searchKeyword = searchText
      let searchResults = [
        ProductModel(image: UIImage(resource: .image2), title: "Product 1", beforePrice: "34,000", price: "28,000", heartCount: 10),
        ProductModel(image: UIImage(resource: .image2),title: "Product 2", beforePrice: "34,000", price: "28,000", heartCount: 20)]
      currentState = .searchResults(searchResults)
    } else {
      currentState = .normal
    }
    
    return true
  }
}
