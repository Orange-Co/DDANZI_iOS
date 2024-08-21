//
//  CompleteCollectionViewCell.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/16/24.
//

import UIKit

import SnapKit
import Then

final class CompleteCollectionViewCell: UICollectionViewCell {
  private let iconImageView = UIImageView().then {
    $0.image = .icBlackCheck
  }
  private let titleLabel = UILabel().then {
    $0.font = .title4Sb24
    $0.text = "주문 완료되었습니다"
    $0.textColor = .black
  }
  private let codeLabel = UILabel().then {
    $0.font = .body4R16
    $0.textColor = .black
  }
  private let guideLabel = UILabel().then {
    $0.font = .body5R14
    $0.textColor = .gray3
    $0.text = "주문 확인 후 거래가 진행됩니다."
  }
  private let productImageview = UIImageView().then {
    $0.makeCornerRound(radius: 10)
  }
  private let productTitleLabel = UILabel().then {
    $0.font = .body4R16
    $0.textColor = .black
    $0.textAlignment = .center
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
    self.backgroundColor = .white
    self.makeCornerRound(radius: 10)
    self.makeBorder(width: 1, color: .gray2)
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    self.addSubviews(iconImageView,
                      titleLabel,
                      codeLabel,
                      guideLabel,
                      productImageview,
                      productTitleLabel,
                      priceLabel)
  }
  
  private func setConstraints() {
    iconImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(27)
      $0.centerX.equalToSuperview()
      $0.size.equalTo(30)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(iconImageView.snp.bottom).offset(12)
      $0.centerX.equalToSuperview()
    }
    
    codeLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(12)
      $0.centerX.equalToSuperview()
    }
    
    guideLabel.snp.makeConstraints {
      $0.top.equalTo(codeLabel.snp.bottom).offset(28)
      $0.centerX.equalToSuperview()
    }
    
    productImageview.snp.makeConstraints {
      $0.size.equalTo(120)
      $0.top.equalTo(guideLabel.snp.bottom).offset(15)
      $0.centerX.equalToSuperview()
    }
    
    productTitleLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(38)
      $0.top.equalTo(productImageview.snp.bottom).offset(15)
    }
    
    priceLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(productTitleLabel.snp.bottom).offset(10)
      $0.bottom.equalToSuperview().inset(27)
    }
  }
  
  func bindData(title: String, price: String, imageURL: String) {
    productTitleLabel.text = title
    priceLabel.text = price
    productImageview.setImage(with: imageURL)
  }
}
