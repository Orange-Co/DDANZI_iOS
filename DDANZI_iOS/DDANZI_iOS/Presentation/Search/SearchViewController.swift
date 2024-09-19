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
import Amplitude

enum CollectionViewState {
  case normal
  case searchResults([ProductInfoModel])
}

class SearchViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private var searchData = BehaviorRelay<SearchItemsResponseDTO>(value: .init(topSearchedList: [], recentlyViewedList: []))
  private let searchResults = BehaviorRelay<[ProductInfoModel]>(value: [])
  
  private var currentState: CollectionViewState = .normal {
    didSet {
      switch currentState {
      case .normal:
        collectionView.isHidden = false
        searchResultsCollectionView.isHidden = true
      case .searchResults(_):
        collectionView.isHidden = true
        searchResultsCollectionView.isHidden = false
      }
    }
  }
  var searchKeyword: String = ""
  
  
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
    navigationBar.searchTextField.becomeFirstResponder()
    bindCollectionView()
    bindSearchResultsCollectionView()
    currentState = .normal
    fetchData()
    setUI()
  }
  
  private func setUI() {
    view.backgroundColor = .white
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    view.addSubviews(navigationBar, collectionView, searchResultsCollectionView)
  }
  
  private func setConstraints() {
    navigationBar.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
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
  
  private func fetchData() {
    Providers.SearchProvider.request(target: .loadInitalSearch, instance: BaseResponse<SearchItemsResponseDTO>.self) { [weak self] result in
      guard let self = self else { return }
      guard let data = result.data else { return }
      self.searchData.accept(data)
    }
  }
  
  private func fetchSearchData(keyword: String) {
    Amplitude.instance().logEvent("click_search_search")
    let query = SearchQueryDTO(keyword: keyword)
    Providers.SearchProvider.request(target: .loadSearchResult(query),
                                     instance: BaseResponse<SearchResultResponseDTO>.self) { [weak self] result in
      guard let self = self else { return }
      guard let data = result.data else { return }
      let items = data.searchedProductList.map { searchedProduct in
        return ProductInfoModel(id: searchedProduct.productID,
                                imageURL: searchedProduct.imgURL,
                                title: searchedProduct.name,
                                beforePrice: searchedProduct.originPrice.toKoreanWon(),
                                price: searchedProduct.salePrice.toKoreanWon(),
                                heartCount: searchedProduct.interestCount)
      }
      
      self.searchResults.accept(items)
      self.currentState = .searchResults(items)
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
        } else if indexPath.section == 1 {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as? SearchCollectionViewCell
          if let cell {
            if let product = item as? RecentlyViewedList {
              cell.bindData(
                imgURL: product.imgURL,
                productTitle: product.name,
                beforePrice: product.originPrice.toKoreanWon(),
                price: product.salePrice.toKoreanWon(),
                heartCount: product.interestCount)
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
    
    searchData.map { items -> [SectionModel<String, Any>] in
      return [
        SectionModel(model: "인기 검색어", items: items.topSearchedList),
        SectionModel(model: "최근 본 상품", items: items.recentlyViewedList)
      ]
    }
    .bind(to: collectionView.rx.items(dataSource: dataSource))
    .disposed(by: disposeBag)
    
    collectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    collectionView.rx.itemSelected
      .subscribe(with: self, onNext: { owner, indexPath in
        if indexPath.section == 0 {
          let topSearchedList = owner.searchData.value.topSearchedList
          let selectedKeyword = topSearchedList[indexPath.row]
          
          owner.searchKeyword = selectedKeyword
          
          Amplitude.instance().logEvent("click_search_popular")
          owner.fetchSearchData(keyword: selectedKeyword)
        } else if indexPath.section == 1 {
          let recentlyViewedItems = owner.searchData.value.recentlyViewedList
          
          let selectedProduct = recentlyViewedItems[indexPath.row]
          let productId = selectedProduct.productID
          
          let detailVC = ProductDetailViewController(productId: productId)
          owner.navigationController?.pushViewController(detailVC, animated: true)
        }
      })
      .disposed(by: disposeBag)
  }
  
  private func bindSearchResultsCollectionView() {
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Any>>(
      configureCell: { dataSource, collectionView, indexPath, item in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
        if let product = item as? ProductInfoModel {
          cell.bindData(imgURL: product.imageURL,
                        productTitle: product.title,
                        beforePrice: product.beforePrice,
                        price: product.price,
                        heartCount: product.heartCount)
        }
        return cell
      },
      configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as? SectionHeaderView else {
          return UICollectionReusableView()
        }
        headerView.bind(title: "\"\(self.searchKeyword)\" 검색 결과", searchKeyword: self.searchKeyword)
        return headerView
      }
    )
    
    searchResults
      .map { results in
        return [SectionModel<String, Any>(model: "\"\(self.searchKeyword)\" 검색 결과", items: results as [Any])]
      }
      .bind(to: searchResultsCollectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    searchResultsCollectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    searchResultsCollectionView.rx.itemSelected
      .subscribe(with: self, onNext: { owner, indexPath in
          let recentlyViewedItems = owner.searchResults.value
          
          let selectedProduct = recentlyViewedItems[indexPath.row]
          let productId = selectedProduct.id
          
          let detailVC = ProductDetailViewController(productId: productId)
          owner.navigationController?.pushViewController(detailVC, animated: true)
        })
      .disposed(by: disposeBag)
  }
  
  
  private func updateSearchResults(_ results: [ProductInfoModel]) {
    let sections: [SectionModel<String, Any>] = [
      SectionModel(model: "\"\(searchKeyword)\" 검색 결과", items: results)
    ]
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Any>>(
      configureCell: { dataSource, collectionView, indexPath, item in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
        if let product = item as? ProductInfoModel {
          cell.bindData(imgURL: product.imageURL,
                        productTitle: product.title,
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
      fetchSearchData(keyword: searchKeyword)
    } else {
      currentState = .normal
    }
    
    
    return true
  }
}
