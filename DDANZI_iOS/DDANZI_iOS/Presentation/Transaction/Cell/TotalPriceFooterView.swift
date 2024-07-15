//
//  TotalPriceFooterView.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/10/24.
//

import UIKit

import SnapKit
import Then

final class TotalPriceFooterView: UICollectionReusableView {
  private let titleLabel = UILabel().then {
    $0.text = "최종 결제 금액"
    $0.font = .body2Sb20
    $0.textColor = .black
  }
  private let priceLabel = UILabel().then {
    $0.font = .title3Sb28
    $0.textColor = .black
  }
  
  override init(frame: CGRect) {
      super.init(frame: frame)
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
                     priceLabel)
  }
  
  private func setConstraints() {
    titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview()
    }
    
    priceLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview()
    }
  }
  
  func configureFooter(totalPrice: String) {
    priceLabel.text = totalPrice
  }
}
