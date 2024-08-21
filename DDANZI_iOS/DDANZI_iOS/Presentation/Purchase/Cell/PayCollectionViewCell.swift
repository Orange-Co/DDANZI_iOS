//
//  PayCollectionViewCell.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/16/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class PayCollectionViewCell: UICollectionViewCell {
  private let payment = ["신용/체크카드", "네이버페이", "카카오페이"]
  private var selectedPayment = ""
  
  private let disposeBag = DisposeBag()
  
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.itemSize = .init(width: 103, height: 45)
    flowLayout.minimumInteritemSpacing = 10
    flowLayout.minimumLineSpacing = 10
    $0.collectionViewLayout = flowLayout
    $0.register(PaymentCardCell.self, forCellWithReuseIdentifier: PaymentCardCell.className)
    $0.backgroundColor = .white
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
    setCollectionView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUI() {
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    self.addSubviews(collectionView)
  }
  
  private func setConstraints() {
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  private func setCollectionView() {
    let paymentObservable = Observable.just(payment)
    
    paymentObservable
      .bind(to: collectionView.rx.items(cellIdentifier: PaymentCardCell.className, cellType: PaymentCardCell.self)) { index, title, cell in
        cell.configure(title: title)
      }
      .disposed(by: disposeBag)
    
    collectionView.delegate = self
  }
}

extension PayCollectionViewCell: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.selectedPayment = self.payment[indexPath.row]
  }
}
