//
//  ProductInfoCollectionViewCell.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/10/24.
//

import UIKit

import SnapKit
import Then

final class ProductInfoCollectionViewCell: UICollectionViewCell {
  private let productImageView = UIImageView()
  private let priceLabel = UILabel().then {
    $0.font = .body1B20
    $0.textColor = .black
  }
  private let productTitleLabel = UILabel().then {
    $0.font = .body4R16
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
    self.addSubviews(productImageView,
                     priceLabel,
                     productTitleLabel)
  }
  
  private func setConstraints() {
    productImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(18)
      $0.leading.equalToSuperview()
      $0.size.equalTo(103)
    }
    
    priceLabel.snp.makeConstraints {
      $0.top.equalTo(productImageView.snp.top).offset(7)
      $0.leading.equalTo(productImageView.snp.trailing).offset(10)
      $0.trailing.equalToSuperview().offset(20)
    }
    
    productTitleLabel.snp.makeConstraints {
      $0.top.equalTo(priceLabel.snp.bottom).offset(10)
      $0.leading.equalTo(productImageView.snp.trailing).offset(10)
      $0.trailing.equalToSuperview().offset(20)
    }
  }
  
  func bindData(product: Product) {
    productImageView.setImage(with: product.imageURL)
    priceLabel.text = product.price
    productTitleLabel.text = product.productName
  }
}
