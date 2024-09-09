//
//  ViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/13/24.
//
import UIKit

import ReactorKit
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import Then

final class HomeViewController: UIViewController, UIScrollViewDelegate {
  // MARK: Properties
  var disposeBag = DisposeBag()
  
  var homeProductItems = BehaviorRelay<[ProductList]>(value: [])
  var bannerImageURLs = BehaviorRelay<[String]>(value: [])
  
  
  // MARK: Components
  let navigationBarView = CustomNavigationBarView(navigationBarType: .search)
  private lazy var homeViewCollectionView = UICollectionView(frame: .zero, collectionViewLayout: HomeViewController.createLayout()).then {
    $0.backgroundColor = .white
    $0.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "HomeCollectionViewCell")
    $0.register(HeaderCollectionViewCell.self, forCellWithReuseIdentifier: "HeaderCollectionViewCell")
  }
  private let sellButton = UIButton().then {
    $0.setTitle("+ 판매하기", for: .normal)
    $0.titleLabel?.font = .body3Sb16
    $0.setTitleColor(.black, for: .normal)
    $0.backgroundColor = .dYellow
    $0.makeCornerRound(radius: 24)
  }
  
  // MARK: LifeCycles
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = false
    self.navigationController?.navigationBar.isHidden = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchHomeData()
    setUI()
    bindCollectionView()
    bindNavigationBar()
  }
  
  // MARK: LayoutHelper
  private func setUI() {
    self.view.backgroundColor = .white
    view.addSubviews(navigationBarView,
                     homeViewCollectionView,
                     sellButton)
    
    navigationBarView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
    }
    
    homeViewCollectionView.snp.makeConstraints {
      $0.top.equalTo(navigationBarView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    sellButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(127)
      $0.trailing.equalToSuperview().inset(20)
      $0.width.equalTo(108)
      $0.height.equalTo(48)
    }
  }
  
  private func fetchHomeData() {
    Providers.HomeProvider.request(target: .loadHomeItems, instance: BaseResponse<HomeItemsResponseDTO>.self) { [weak self] result in
      guard let self = self else { return }
      guard let data = result.data else { return }
      
      self.bannerImageURLs.accept([data.homeImgURL])
      
      let items = data.productList.map { productDTO in
        return ProductList(
          productID: productDTO.productID,
          kakaoProductID: productDTO.kakaoProductID,
          name: productDTO.name,
          imgURL: productDTO.imgURL,
          originPrice: productDTO.originPrice,
          salePrice: productDTO.salePrice,
          interestCount: productDTO.interestCount
        )
      }
      
      // BehaviorRelay의 값을 업데이트하여 UI 업데이트를 트리거합니다.
      self.homeProductItems.accept(items)
    }
  }
  
  
  private func bindNavigationBar() {
    navigationBarView.searchButtonTap
      .subscribe(onNext: { [weak self] in
        self?.navigationController?.pushViewController(SearchViewController(), animated: true)
      })
      .disposed(by: disposeBag)
  }
  
  private func bindCollectionView() {
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Any>>(
      configureCell: { dataSource, collectionView, indexPath, item in
        if indexPath.section == 0 {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCollectionViewCell", for: indexPath) as! HeaderCollectionViewCell
          if let banner = item as? String {
            cell.bindData(bannerImagaURL: banner)
          }
          return cell
        } else {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
          if let product = item as? ProductList {
            cell.bindData(productImageURL: product.imgURL,
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
    )
    
    Observable.combineLatest(bannerImageURLs, homeProductItems)
      .map { banners, items -> [SectionModel<String, Any>] in
        return [
          SectionModel(model: "Section 0", items: banners),
          SectionModel(model: "Section 1", items: items)
        ]
      }
      .bind(to: homeViewCollectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    homeViewCollectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    homeViewCollectionView.rx.itemSelected
      .subscribe(onNext: { [weak self] indexPath in
        guard let self = self else { return }
        if indexPath.section == 1 {
          let detailVC = ProductDetailViewController(productId: homeProductItems.value[indexPath.row].productID)
          self.navigationController?.pushViewController(detailVC, animated: true)
        }
      })
      .disposed(by: disposeBag)

    // 판매하기 버튼 이벤트
    sellButton.rx.tap
      .bind(with: self) { owner, _ in
        let sellingVC = LandingViewController()
        self.navigationController?.pushViewController(sellingVC, animated: true)
      }
      .disposed(by: disposeBag)
  }
  
}

extension HomeViewController {
  static func createLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
      if sectionNumber == 0 {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                       heightDimension: .estimated(200)),
                                                     subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
      } else if sectionNumber == 1 {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5),
                                                            heightDimension: .estimated(300)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                         heightDimension: .estimated(300)),
                                                       subitems: [item, item])
        group.interItemSpacing = .fixed(10)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 14, leading: 10, bottom: 20, trailing: 10)
        
        return section
      } else {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(100),
                                                            heightDimension: .absolute(100)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .absolute(100),
                                                                       heightDimension: .absolute(100)),
                                                     subitems: [item])
        return NSCollectionLayoutSection(group: group)
      }
    }
  }
}
