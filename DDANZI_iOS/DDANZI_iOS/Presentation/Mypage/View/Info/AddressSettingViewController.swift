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
  private let addButton = UIButton().then {
    $0.setTitle("+ 배송지 등록", for: .normal)
    $0.titleLabel?.font = .body2Sb18
    $0.backgroundColor = .white
    $0.makeCornerRound(radius: 10)
    $0.makeBorder(width: 1, color: .gray3)
    $0.setTitleColor(.gray4, for: .normal)
    $0.isHidden = true // 초기에는 숨겨둡니다.
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
                     addButton,
                     collectionView)
  }
  
  private func setConstraints() {
    navigationBarView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
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
    
    addButton.snp.makeConstraints {
      $0.top.equalTo(headerView.snp.bottom).offset(30)
      $0.leading.trailing.equalToSuperview().inset(30)
      $0.height.equalTo(150)
    }
  }
  private func configureCollectionView() {
    collectionView.delegate = nil
    
    let dummy: [Address] = [] // 데이터가 없는 상태를 가정
    
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
              cell.configureView(name: address.name, address: address.address, phone: address.phone, isEditable: true)
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
    
    items.subscribe(onNext: { [weak self] sections in
      guard let self = self else { return }
      let isEmpty = sections.first?.items.isEmpty ?? true
      self.collectionView.isHidden = isEmpty
      self.addButton.isHidden = !isEmpty
    })
    .disposed(by: disposeBag)
  }
  
  
  private func bind() {
    navigationBarView.backButtonTap
      .subscribe(onNext: { [weak self] in
        self?.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
    
    addButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.navigationController?.pushViewController(AddressFormViewController(), animated: true)
      })
      .disposed(by: disposeBag)
  }
}

extension AddressSettingViewController: UICollectionViewDelegate { }
