//
//  PurchaseCollectionViewCell.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/16/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class PayAmountCollectionViewCell: UICollectionViewCell {
  private let prices = BehaviorRelay<[PriceModel]>(value: [])
  private let disposeBag = DisposeBag()
  
  private let tableView = UITableView(frame: .zero, style: .plain).then {
    $0.backgroundColor = .white
    $0.separatorStyle = .none
    $0.register(PaymentTableViewCell.self, forCellReuseIdentifier: PaymentTableViewCell.className)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
    configureTableView()
    bindTableView() // 테이블 뷰와 데이터 바인딩
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUI() {
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    self.addSubview(tableView)
  }
  
  private func setConstraints() {
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview() // 상하좌우 모든 엣지를 슈퍼뷰에 맞춤
    }
  }
  
  private func configureTableView() {
    tableView.dataSource = self
  }
  
  // PriceModel 배열을 전달받아 prices에 설정합니다.
  func configurePayAmount(_ priceModels: PurchaseModel) {
    let price = [
      PriceModel(title: "상품 금액", price: priceModels.originPrice.toKoreanWon(), type: .normal),
      PriceModel(title: "할인가", price: priceModels.discountPrice.toKoreanWon(), type: .discount),
      PriceModel(title: "수수료", price: priceModels.chargePrice.toKoreanWon(), type: .charge),
      PriceModel(title: "결제 금액", price: priceModels.totalPrice.toKoreanWon(), type: .normal)
    ]
    self.prices.accept(price)
  }
  
  // 테이블 뷰를 데이터와 바인딩하는 메소드
  private func bindTableView() {
    prices.asDriver(onErrorJustReturn: [])
      .drive(onNext: { [weak self] _ in
        self?.tableView.reloadData()
      })
      .disposed(by: disposeBag)
  }
}

extension PayAmountCollectionViewCell: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return prices.value.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: PaymentTableViewCell.className, for: indexPath) as? PaymentTableViewCell else {
      return UITableViewCell()
    }
    let priceModel = prices.value[indexPath.row]
    cell.bindTitle(title: priceModel.title,
                   price: priceModel.price,
                   type: priceModel.type)
    cell.selectionStyle = .none
    return cell
  }
}
