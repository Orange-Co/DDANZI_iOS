//
//  RegisteItemViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/9/24.
//

import UIKit

import Then
import SnapKit
import RxSwift
import RxCocoa

final class RegisteItemViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  let itemInfo = PublishRelay<itemConformedDTO>()
  var info: itemConformedDTO = .init(productId: "", productName: "", originPrice: 0, salePrice: 0, isAccounExist: true, imgUrl: "")
  
  // MARK: - UI
  private let navigationBar = CustomNavigationBarView(navigationBarType: .cancel, title: "판매하기")
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .white
    $0.register(RegisteItemCell.self, forCellWithReuseIdentifier: RegisteItemCell.className)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  private func setUI() {
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    view.addSubviews(navigationBar, collectionView)
  }
  
  private func setConstraints() {
    navigationBar.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(navigationBar.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func bind() {
    itemInfo
      .subscribe(with: self) { owner, dto in
        owner.info = dto
        owner.collectionView.reloadData()
      }
      .disposed(by: disposeBag)
  }
  
  private func configureCollectionView() {
    collectionView.dataSource = self
  }
}

extension RegisteItemViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RegisteItemCell.className, for: indexPath) as? RegisteItemCell else { return UICollectionViewCell() }
    cell.configure(info: self.info)
    return cell
    
  }
  
  
}
