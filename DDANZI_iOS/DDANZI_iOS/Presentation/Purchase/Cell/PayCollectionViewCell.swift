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

enum Payment: String, Codable {
  case card = "card"
  case naverpay = "naverpay_card"
  case kakaopay = "kakaopay"
}

final class PayCollectionViewCell: UICollectionViewCell {
  // 결제 수단 옵션
  private let paymentOptions: [(name: String, type: Payment)] = [
    (name: "신용/체크카드", type: .card),
    (name: "네이버페이", type: .naverpay),
    (name: "카카오페이", type: .kakaopay)
  ]
  
  var selectedPayment = BehaviorRelay<Payment?>(value: nil)
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
    let paymentObservable = Observable.just(paymentOptions)
    
    paymentObservable
      .bind(to: collectionView.rx.items(cellIdentifier: PaymentCardCell.className, cellType: PaymentCardCell.self)) { [weak self] index, paymentOption, cell in
        guard let self = self else { return }
        let isSelected = paymentOption.type == self.selectedPayment.value
        cell.configure(title: paymentOption.name, isSelected: isSelected)
      }
      .disposed(by: disposeBag)
    
    collectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
  
  private func bindSelection() {
    collectionView.rx.itemSelected
      .map { [weak self] indexPath -> Payment in
        let selectedPaymentType = self?.paymentOptions[indexPath.row].type ?? .card
        self?.isPaymentSelected.accept(true)
        return selectedPaymentType
      }
      .bind(to: selectedPayment)
      .disposed(by: disposeBag)
    
    selectedPayment
      .subscribe(onNext: { [weak self] _ in
        self?.collectionView.reloadData()
      })
      .disposed(by: disposeBag)
  }
}

extension PayCollectionViewCell: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let selectedPayment = paymentOptions[indexPath.row].type
    print("선택된 결제 수단: \(selectedPayment.rawValue)")
  }
}
