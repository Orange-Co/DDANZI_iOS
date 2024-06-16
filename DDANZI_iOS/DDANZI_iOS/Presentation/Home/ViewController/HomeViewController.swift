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
    
    // MARK: Components
    let navigationBarView = CustomNavigationBarView(navigationBarType: .search)
    private lazy var homeViewCollectionView = UICollectionView(frame: .zero, collectionViewLayout: HomeViewController.createLayout()).then {
        $0.backgroundColor = .white
        $0.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "HomeCollectionViewCell")
        $0.register(HeaderCollectionViewCell.self, forCellWithReuseIdentifier: "HeaderCollectionViewCell")
    }
    
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindCollectionView()
    }
    
    // MARK: LayoutHelper
    private func setUI() {
        view.addSubviews(navigationBarView,
                         homeViewCollectionView)
        
        navigationBarView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        homeViewCollectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            
        }
    }
    
    private func bindCollectionView() {
        let dummyData = [
            ProductModel(title: "Product 1", beforePrice: "34,000", price: "28,000", heartCount: 10),
            ProductModel(title: "Product 2", beforePrice: "34,000", price: "28,000", heartCount: 20),
            ProductModel(title: "Product 3", beforePrice: "34,000", price: "28,000", heartCount: 30),
            ProductModel(title: "Product 4", beforePrice: "34,000", price: "28,000", heartCount: 40),
            ProductModel(title: "Product 5", beforePrice: "34,000", price: "28,000", heartCount: 50),
            ProductModel(title: "Product 6", beforePrice: "34,000", price: "28,000", heartCount: 60)
        ]
        
        let colorDummy: [UIColor] = [.red, .blue, .yellow]
        
        let sections: [SectionModel<String, Any>] = [
            SectionModel(model: "Section 0", items: colorDummy),
            SectionModel(model: "Section 1", items: dummyData)
        ]
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Any>>(
            configureCell: { dataSource, collectionView, indexPath, item in
                if indexPath.section == 0 {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCollectionViewCell", for: indexPath) as! HeaderCollectionViewCell
                    if let banner = item as? UIColor {
                        cell.bindData(bannerImage: banner)
                    }
                    return cell
                } else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
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
        )
        
        let items = Observable.just(sections)
        
        items.bind(to: homeViewCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        homeViewCollectionView.rx.setDelegate(self)
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
                                                                    heightDimension: .estimated(260)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                                 heightDimension: .estimated(260)),
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
