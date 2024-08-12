//
//  HomeCollectionViewCell.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/16/24.
//

import UIKit

import RxSwift
import Kingfisher

class HomeCollectionViewCell: UICollectionViewCell {
  // MARK: Properties
  let disposeBag = DisposeBag()
  
  // MARK: Compenets
  private let productImageView = UIImageView().then {
    $0.backgroundColor = .gray
    $0.makeCornerRound(radius: 5)
  }
  
  let heartButton = UIButton().then {
    $0.setImage(.icEmptyHeart, for: .normal)
  }
  
  private let titleLabel = UILabel().then {
    $0.font = .body3Sb16
    $0.textColor = .black
    $0.numberOfLines = 2
  }
  
  let beforePriceLabel = UILabel().then {
    $0.font = .body6M12
    $0.textColor = .gray2
  }
  
  private let priceLabel = UILabel().then {
    $0.font = .body2Sb18
    $0.textColor = .black
  }
  
  private let heartImageView = UIImageView().then {
    $0.image = .icBlackHeart
  }
  
  private let heartCountLabel = UILabel().then {
    $0.font = .body7M10
    $0.textColor = .black
  }
  
  var heartButtonTap: Observable<Void> {
    return heartButton.rx.tap.asObservable()
  }
  
  // MARK: LifeCycles
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: LayoutHelper
  private func setUI() {
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    productImageView.addSubview(heartButton)
    
    self.addSubviews(productImageView,
                     titleLabel,
                     beforePriceLabel,
                     priceLabel,
                     heartImageView,
                     heartCountLabel)
  }
  
  private func setConstraints() {
    heartButton.snp.makeConstraints {
      $0.top.trailing.equalToSuperview().inset(7)
    }
    
    productImageView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(170)
    }
    
    titleLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(12)
      $0.top.equalTo(productImageView.snp.bottom).offset(8)
    }
    
    beforePriceLabel.snp.makeConstraints {
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.top.equalTo(titleLabel.snp.bottom).offset(7)
    }
    
    priceLabel.snp.makeConstraints {
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.top.equalTo(beforePriceLabel.snp.bottom).offset(7)
    }
    
    heartImageView.snp.makeConstraints {
      $0.size.equalTo(8)
      $0.centerY.equalTo(heartCountLabel)
      $0.trailing.equalTo(heartCountLabel.snp.leading).offset(-2)
    }
    
    heartCountLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(6)
      $0.bottom.equalTo(priceLabel.snp.bottom)
    }
  }
  
  func bindData(
    productImageURL: String,
    productTitle: String,
    beforePrice: String,
    price: String,
    heartCount: Int
  ) {
    productImageView.setImage(with: productImageURL)
    titleLabel.text = productTitle
    beforePriceLabel.text = beforePrice
    priceLabel.text = price
    heartCountLabel.text = "\(heartCount)"
    
    beforePriceLabel.attributedText = beforePriceLabel.text?.strikeThrough()
  }
}
