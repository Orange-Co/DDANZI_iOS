//
//  PaymentCardCell.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/20/24.
//
import UIKit

final class PaymentCardCell: UICollectionViewCell {
  private let titleLabel = UILabel().then {
    $0.textAlignment = .center
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUI() {
    contentView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    configureAppearance(isSelected: false)
  }
  
  func configure(title: String, isSelected: Bool) {
    titleLabel.text = title
    configureAppearance(isSelected: isSelected)
  }
  
  private func configureAppearance(isSelected: Bool) {
    layer.cornerRadius = 10
    if isSelected {
      layer.borderColor = UIColor.gray4.cgColor
      layer.borderWidth = 1
      titleLabel.textColor = .gray4
    } else {
      layer.borderColor = UIColor.gray2.cgColor
      layer.borderWidth = 1
      titleLabel.textColor = .gray2
    }
    clipsToBounds = true
  }
  
  // Method to explicitly configure as selected
  func configureSelect() {
    configureAppearance(isSelected: true)
  }
}
