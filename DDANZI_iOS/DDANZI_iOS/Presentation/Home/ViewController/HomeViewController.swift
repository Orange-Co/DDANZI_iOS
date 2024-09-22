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
import Amplitude

final class HomeViewController: UIViewController, UIScrollViewDelegate {
  // MARK: Properties
  private var disposeBag = DisposeBag()
  private var isFetchingData = false
  
  private var homeProductItems = BehaviorRelay<[ProductList]>(value: [])
  private var bannerImageURLs = BehaviorRelay<[String]>(value: [])
  private var totalpage = BehaviorRelay<Int>(value: 0)
  private var currentPage = BehaviorRelay<Int>(value: 0)
  
  
  // MARK: Components
  let navigationBarView = CustomNavigationBarView(navigationBarType: .search)
  private let refreshControl = UIRefreshControl()
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
    reloadData()
    
    // Amplitude 설정
    Amplitude.instance().logEvent("view_home")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
    bindCollectionView()
    bindNavigationBar()
  }
  
  // MARK: LayoutHelper
  private func setUI() {
    self.view.backgroundColor = .white
    self.homeViewCollectionView.refreshControl = refreshControl
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
    guard !isFetchingData else { return } // 로딩 중이면 함수 종료
    isFetchingData = true // 로딩 시작
    
    Providers.HomeProvider.request(target: .loadHomeItems(currentPage.value), instance: BaseResponse<HomeItemsResponseDTO>.self) { [weak self] result in
      guard let self = self else { return }
      self.isFetchingData = false // 로딩 완료 후 플래그 해제
      
      guard let data = result.data else { return }
      
      let totalElements = data.pageInfo.totalElements
      let numberOfElements = data.pageInfo.numberOfElements
      
      self.totalpage.accept(totalElements % numberOfElements > 0 ? (totalElements / numberOfElements) + 1 : totalElements / numberOfElements)
      self.bannerImageURLs.accept([data.homeImgURL])
      
      let items = data.productList.map { productDTO in
        return ProductList(
          productID: productDTO.productID,
          kakaoProductID: productDTO.kakaoProductID,
          name: productDTO.name,
          imgURL: productDTO.imgURL,
          originPrice: productDTO.originPrice,
          salePrice: productDTO.salePrice,
          interestCount: productDTO.interestCount,
          isInterested: productDTO.isInterested
        )
      }
      
      var currentItems = self.homeProductItems.value
      currentItems.append(contentsOf: items)
      self.homeProductItems.accept(currentItems)
      
      self.currentPage.accept(self.currentPage.value + 1)
    }
  }
  
  
  private func bindNavigationBar() {
    navigationBarView.searchButtonTap
      .subscribe(onNext: { [weak self] in
        Amplitude.instance().logEvent("click_home_search")
        self?.navigationController?.pushViewController(SearchViewController(), animated: true)
      })
      .disposed(by: disposeBag)
  }
  
  private func bindCollectionView() {
    refreshControl.rx.controlEvent(.valueChanged)
      .subscribe(with: self) { owner, _ in
        owner.reloadData()
      }
      .disposed(by: disposeBag)
    
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
            cell.bindData(
              productImageURL: product.imgURL,
              productTitle: product.name,
              beforePrice: product.originPrice.toKoreanWon(),
              price: product.salePrice.toKoreanWon(),
              heartCount: product.interestCount,
              isInterest: product.isInterested,
              itemID: product.productID
            )
            cell.isLogoutInterest
              .subscribe(with: self) { owner, isLogout in
                if isLogout {
                  owner.view.showToast(message: "로그인 이후 이용 가능합니다.", at: 130.adjusted)
                }
              }
              .disposed(by: cell.disposeBag)
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
        if indexPath.section == 0 {
          Amplitude.instance().logEvent("click_home_banner")
          if let url = URL(string: "https://brawny-guan-098.notion.site/d1259ed5fdfd489eb6cc23a4312c13a0?pvs=4") {
            if UIApplication.shared.canOpenURL(url) {
              UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
          }
        } else if indexPath.section == 1 {
          let detailVC = ProductDetailViewController(productId: homeProductItems.value[indexPath.row].productID)
          self.navigationController?.pushViewController(detailVC, animated: true)
        }
      })
      .disposed(by: disposeBag)
    
    // 스크롤이 끝에 도달했을 때 다음 페이지 로드
    homeViewCollectionView.rx.contentOffset
      .subscribe(onNext: { [weak self] contentOffset in
        guard let self = self else { return }
        let contentHeight = self.homeViewCollectionView.contentSize.height
        let scrollViewHeight = self.homeViewCollectionView.frame.size.height
        let scrollOffsetThreshold = contentHeight - scrollViewHeight
        
        // 스크롤이 끝에 도달했을 때 (다음 페이지 존재 시)
        if contentOffset.y > scrollOffsetThreshold && self.currentPage.value <= self.totalpage.value {
          self.fetchHomeData()
        }
      })
      .disposed(by: disposeBag)
    
    sellButton.rx.tap
      .bind(with: self) { owner, _ in
        Amplitude.instance().logEvent("click_home_sell")
        let sellingVC = LandingViewController()
        self.navigationController?.pushViewController(sellingVC, animated: true)
      }
      .disposed(by: disposeBag)
    
    navigationBarView.alarmButtonTap
      .bind(with: self) { owner, _ in
        if UserDefaults.standard.bool(forKey: .isLogin) {
          self.navigationController?.pushViewController(PushViewController(), animated: true)
        } else {
          owner.navigationController?.pushViewController(LoginViewController(signUpFrom: "sell"), animated: true)
          owner.view.showToast(message: "로그인이 필요한 서비스 입니다.", at: 50)
        }
      }
      .disposed(by: disposeBag)
  }
  
  private func reloadData() {
    currentPage.accept(0)
    homeProductItems.accept([])
    
    fetchHomeData()
    
    refreshControl.endRefreshing()
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
