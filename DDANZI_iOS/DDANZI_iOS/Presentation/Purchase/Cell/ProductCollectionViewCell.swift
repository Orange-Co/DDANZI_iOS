//
//  ProductInfoCollectionViewCell.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/16/24.
//

import UIKit

import SnapKit
import Then

final class ProductCollectionViewCell: UICollectionViewCell {
  private let imageView = UIImageView().then {
    $0.backgroundColor = .gray3
  }
  private let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 12
    $0.alignment = .leading
  }
  private let productLabel = UILabel().then {
    $0.font = .body4R16
    $0.textColor = .black
  }
  private let priceLabel = UILabel().then {
    $0.font = .body1B20
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
    self.addSubviews(imageView,
                     stackView)
    stackView.addArrangedSubviews(productLabel,
                                  priceLabel)
  }
  
  private func setConstraints() {
    imageView.snp.makeConstraints {
      $0.centerY.leading.equalToSuperview()
      $0.size.equalTo(75)
    }
    
    stackView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(imageView.snp.trailing).offset(14)
      $0.trailing.equalToSuperview().inset(14)
    }
  }
  
  func bindData(title: String, price: String, imageURL: String) {
    productLabel.text = title
    priceLabel.text = price
    imageView.setImage(with: imageURL)
  }
}

