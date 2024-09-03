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
  var selectedPayment = BehaviorRelay<String?>(value: nil)
  var isPaymentSelected = BehaviorRelay<Bool>(value: false)
  
  let disposeBag = DisposeBag()
  
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
    bindSelection()
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
      .bind(to: collectionView.rx.items(cellIdentifier: PaymentCardCell.className, cellType: PaymentCardCell.self)) { [weak self] index, title, cell in
        guard let self = self else { return }
        let isSelected = title == self.selectedPayment.value
        cell.configure(title: title, isSelected: isSelected)
      }
      .disposed(by: disposeBag)
    
    collectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
  
  private func bindSelection() {
    collectionView.rx.itemSelected
      .map { [weak self] indexPath -> String in
        self?.payment[indexPath.row] ?? ""
      }
      .bind(to: selectedPayment)
      .disposed(by: disposeBag)
    
    selectedPayment
      .subscribe(onNext: { [weak self] _ in
        self?.isPaymentSelected.accept(self?.selectedPayment.value != nil)
        self?.collectionView.reloadData()
      })
      .disposed(by: disposeBag)
  }
}

extension PayCollectionViewCell: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let selectedPayment = payment[indexPath.row]
    print("Selected payment method: \(selectedPayment)")
  }
}
