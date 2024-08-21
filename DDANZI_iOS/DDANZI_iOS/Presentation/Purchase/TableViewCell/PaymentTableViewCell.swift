//
//  PaymentTableViewCell.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/16/24.
//

import UIKit

enum PriceType {
  case normal
  case discount
  case charge
}

final class PaymentTableViewCell: UITableViewCell {
  
  private let titleLabel = UILabel().then {
    $0.font = .body4R16
    $0.textColor = .black
  }
  private let priceLabel = UILabel().then {
    $0.font = .body1B20
    $0.textColor = .black
  }
  private let lineView = UIView().then {
    $0.backgroundColor = .black
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUI() {
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    self.addSubviews(titleLabel,
                     priceLabel,
                     lineView)
  }
  
  private func setConstraints() {
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
    
    priceLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
    
    lineView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(1)
    }
  }
  
  func bindTitle(title: String, price: String, type: PriceType) {
    titleLabel.text = title
    switch type {
    case .normal:
      priceLabel.text = price
      titleLabel.text = title
      priceLabel.font = .body1B20
      priceLabel.textColor = .black
      lineView.isHidden = true
    case .discount:
      priceLabel.text = "-" + price
      priceLabel.font = .body1B20
      priceLabel.textColor = .dRed
      lineView.isHidden = true
    case .charge:
      priceLabel.text = "+" + price
      priceLabel.font = .body4R16
      priceLabel.textColor = .black
      lineView.isHidden = false
    }
  }
  
}
