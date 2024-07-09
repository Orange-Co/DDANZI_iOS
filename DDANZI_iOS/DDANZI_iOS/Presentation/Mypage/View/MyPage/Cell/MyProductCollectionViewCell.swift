//
//  MyProductCollectionViewCell.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/4/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

enum ListType {
  case sales
  case purchase
  case interest
}

final class MyProductCollectionViewCell: UICollectionViewCell {
  static let identifier = "MyProductCollectionViewCell"
  
  private let disposeBag = DisposeBag()
  private let listTypeRelay = BehaviorRelay<ListType>(value: .sales)
  
  var listType: ListType {
    get {
      return listTypeRelay.value
    }
    set {
      listTypeRelay.accept(newValue)
    }
  }
  
  private let imageView = UIImageView().then {
    $0.backgroundColor = .gray2
  }
  private let cancelButton = UIButton().then {
    $0.setImage(.btnXCircle, for: .normal)
  }
  private let titleLabel = UILabel().then {
    $0.font = .body3Sb16
    $0.numberOfLines = 2
    $0.textColor = .blackground
  }
  private let purchaseDateLabel = UILabel().then {
    $0.font = .body6M12
    $0.textColor = .black
  }
  private let beforeLabel = UILabel().then {
    $0.font = .body6M12
    $0.textColor = .gray2
  }
  private let priceLabel = UILabel().then {
    $0.font = .body3Sb16
    $0.textColor = .black
  }
  private let heartView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 3
    $0.alignment = .center
  }
  private let heartIconImageView = UIImageView().then {
    $0.image = .icSmallHeart
  }
  private let heartLabel = UILabel().then {
    $0.font = .body8M8
    $0.textColor = .black
  }
  private let heartButton = UIButton().then {
    $0.setImage(.icHeart, for: .normal)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
    bindUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    imageView.subviews.forEach { $0.removeFromSuperview() }
    purchaseDateLabel.removeFromSuperview()
    setUI()
  }
  
  private func bindUI() {
    listTypeRelay
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] listType in
        guard let self = self else { return }
        self.updateUI(for: listType)
      })
      .disposed(by: disposeBag)
  }
  
  private func updateUI(for listType: ListType) {
    imageView.subviews.forEach { $0.removeFromSuperview() }
    purchaseDateLabel.removeFromSuperview()
    heartView.removeFromSuperview()
    
    switch listType {
    case .sales:
      setSalesConstraints()
    case .purchase:
      setPurchaseConstraints()
    case .interest:
      setInterestConstraints()
    }
  }
  
  private func setUI() {
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    heartView.addArrangedSubview(heartIconImageView)
    heartView.addArrangedSubview(heartLabel)
    self.addSubviews(imageView,
                     titleLabel,
                     beforeLabel,
                     priceLabel,
                     heartView)
  }
  
  private func setConstraints() {
    imageView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(164)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.bottom).offset(9)
      $0.leading.trailing.equalToSuperview()
    }
    
  }
  
  private func setPurchaseConstraints() {
    self.addSubviews(purchaseDateLabel)
    purchaseDateLabel.text = "2024년 05월 12일 구매"
    
    purchaseDateLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(5)
      $0.leading.equalToSuperview()
    }
    
    priceLabel.snp.remakeConstraints {
      $0.top.equalTo(purchaseDateLabel.snp.bottom).offset(5)
      $0.trailing.equalToSuperview().inset(5)
    }
    
    beforeLabel.snp.remakeConstraints {
      $0.bottom.equalTo(priceLabel.snp.bottom)
      $0.leading.equalToSuperview()
    }
  }
  
  private func setSalesConstraints() {
    self.addSubviews(heartView)
    beforeLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(7)
      $0.leading.equalToSuperview()
    }
    
    priceLabel.snp.remakeConstraints {
      $0.top.equalTo(beforeLabel.snp.bottom).offset(7)
      $0.leading.equalToSuperview()
    }
    
    heartView.snp.makeConstraints {
      $0.bottom.equalTo(priceLabel.snp.bottom)
      $0.trailing.equalToSuperview().inset(5)
    }
  }
  
  private func setInterestConstraints() {
    self.addSubviews(heartView)
    imageView.addSubviews(heartButton)
    
    heartButton.snp.makeConstraints {
      $0.top.trailing.equalToSuperview().inset(7)
    }
    
    beforeLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(7)
      $0.leading.equalToSuperview()
    }
    
    priceLabel.snp.makeConstraints {
      $0.top.equalTo(beforeLabel.snp.bottom).offset(7)
      $0.leading.equalToSuperview()
    }
    
    heartView.snp.makeConstraints {
      $0.bottom.equalTo(priceLabel.snp.bottom)
      $0.trailing.equalToSuperview().inset(5)
    }
  }
  
  func bind(to viewModel: PurchaseListViewModel) {
      viewModel.isEditMode
          .bind(to: cancelButton.rx.isHidden)
          .disposed(by: disposeBag)
  }
  
  func bindData(image: UIImage?, title: String, beforePrice: String, price: String, heartCount: Int) {
    imageView.image = image
    titleLabel.text = title
    beforeLabel.text = beforePrice
    priceLabel.text = price
    heartLabel.text = "\(heartCount)"
    
    
    beforeLabel.attributedText = beforeLabel.text?.strikeThrough()
  }
}

