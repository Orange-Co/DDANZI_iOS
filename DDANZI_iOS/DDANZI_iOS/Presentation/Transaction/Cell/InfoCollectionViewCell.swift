//
//  InfoCollectionViewCell.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/10/24.
//

import UIKit

import SnapKit
import Then

final class InfoCollectionViewCell: UICollectionViewCell {
  private let titleLabel = UILabel().then {
    $0.font = .body4R16
    $0.textColor = .black
  }
  
  private let infoLabel = UILabel().then {
    $0.font = .body4R16
    $0.textColor = .gray4
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
                     infoLabel)
  }
  
  private func setConstraints() {
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
    
    infoLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
  }
  
  func bindData(title: String, info: String, isBold: Bool = false) {
    titleLabel.text = title
    infoLabel.font = isBold ? .body3Sb16 : .body4R16
    infoLabel.text = info
  }
  
}
