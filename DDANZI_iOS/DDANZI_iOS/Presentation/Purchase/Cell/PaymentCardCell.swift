//
//  PaymentCardCell.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/20/24.
//

import UIKit

import Then
import SnapKit

final class PaymentCardCell: UICollectionViewCell {
  
  private let titleLabel = UILabel().then {
    $0.font = .body5R14
    $0.textColor = .gray2
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
    contentView.makeCornerRound(radius: 10)
    contentView.makeBorder(width: 1, color: .gray2)
    contentView.addSubviews(titleLabel)
  }
  
  private func setConstraints() {
    titleLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
  
  func configure(title: String){
    self.titleLabel.text = title
  }
  
  func configureSelect() {
    titleLabel.textColor = .gray4
    contentView.makeBorder(width: 1, color: .gray4)
  }
}
