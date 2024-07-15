//
//  SellerCollectionViewCell.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/10/24.
//

import UIKit

import SnapKit
import Then

final class SellerCollectionViewCell: UICollectionViewCell {
  private let titleLabel = UILabel().then {
    $0.font = .body4R16
    $0.textColor = .black
    $0.text = "닉네임"
  }
  
  private let nickNameLabel = UILabel().then {
    $0.font = .body3Sb16
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
                     nickNameLabel)
  }
  
  private func setConstraints() {
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
    
    nickNameLabel.snp.makeConstraints {
      $0.leading.equalTo(titleLabel.snp.trailing).offset(20)
      $0.centerY.equalToSuperview()
    }
  }
  
  func bindData(nickName: String) {
    nickNameLabel.text = nickName
  }
}
