//
//  PurchaseCollectionViewCell.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/16/24.
//

import UIKit

import SnapKit
import Then

struct PriceModel {
  var title: String
  var price: String
  var type: PriceType
}

final class PayAmountCollectionViewCell: UICollectionViewCell {
  private let prices = [
    PriceModel(title: "상품 금액", price: "24,000원", type: .normal),
    PriceModel(title: "할인가", price: "-3,000원", type: .discount),
    PriceModel(title: "수수료", price: "+350원", type: .charge),
    PriceModel(title: "결제 금액", price: "21,350원", type: .normal),
  ]
  private let tableView = UITableView(frame: .zero, style: .plain).then {
    $0.backgroundColor = .white
    $0.separatorStyle = .none
    $0.register(PaymentTableViewCell.self, forCellReuseIdentifier: PaymentTableViewCell.className)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
    configureTableView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUI() {
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    self.addSubviews(tableView)
  }
  
  private func setConstraints() {
    tableView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  func configureTableView() {
    tableView.dataSource = self
  }
}

extension PayAmountCollectionViewCell: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return prices.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: PaymentTableViewCell.className, for: indexPath) as? PaymentTableViewCell else { return UITableViewCell() }
    cell.bindTitle(title: prices[indexPath.item].title,
                   price: prices[indexPath.item].price,
                   type: prices[indexPath.item].type)
    cell.selectionStyle = .none
    return cell
  }
}
