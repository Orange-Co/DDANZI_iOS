//
//  AddressSettingViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/15/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources

class AddressSettingViewController: UIViewController {
  private let disposeBag = DisposeBag()
  
  private let navigationBarView = CustomNavigationBarView(navigationBarType: .normal)
  private let headerView = MyPageSectionHeaderView()
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.itemSize = .init(width: UIScreen.main.bounds.width - 40, height: 164)
    $0.collectionViewLayout = flowLayout
    
    $0.register(AddressCollectionViewCell.self,
                forCellWithReuseIdentifier: AddressCollectionViewCell.className)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
    view.addSubviews(navigationBarView,
                     headerView,
                     collectionView)
  }
  
  private func setConstraints() {
    navigationBarView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
    }
    
    headerView.snp.makeConstraints {
      $0.top.equalTo(navigationBarView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(48)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(headerView.snp.bottom).offset(19)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func configureCollectionView() {
    collectionView.delegate = nil
    let dummy: [Address] = [.init(name: "이등둔", address: "(02578) 서울특별시 동대문구 무학로45길 34 (용두동), 204호", phone: "010-5213-2334")]
    
    let sections: [SectionModel<String, Any>] = [
      SectionModel(model: "배송지 관리", items: dummy)
    ]
    
    headerView.setTitleLabel(title: sections[0].model)
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Any>>(
      configureCell: { dataSource, collectionView, indexPath, item in
        if indexPath.section == 0 {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddressCollectionViewCell.className, for: indexPath) as? AddressCollectionViewCell
          if let cell {
            if let address = item as? Address {
              cell.configureView(name: address.name, address: address.address, phone: address.phone)
            }
            return cell
          }
        }
        return UICollectionViewCell()
      }
    )
    
    let items = Observable.just(sections)
    
    items.bind(to: collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    collectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
//    collectionView.rx.itemSelected
//      .subscribe(onNext: { [weak self] indexPath in
//        guard let self = self else { return }
//        if indexPath.section == 0 {
//          let detailVC = ProductDetailViewController()
//          self.navigationController?.pushViewController(detailVC, animated: true)
//        }
//      })
//      .disposed(by: disposeBag)
  }
  
  private func bind() {
    navigationBarView.backButtonTap
      .subscribe(onNext: { [weak self] in
        self?.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
  }
}

extension AddressSettingViewController: UICollectionViewDelegate { }
