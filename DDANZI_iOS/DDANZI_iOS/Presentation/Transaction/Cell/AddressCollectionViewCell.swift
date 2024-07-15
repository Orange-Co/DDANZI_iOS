//
//  AddressCollectionViewCell.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/10/24.
//

import UIKit

import SnapKit
import Then

final class AddressCollectionViewCell: UICollectionViewCell {
  private let nameLabel = UILabel().then {
    $0.font = .body2Sb18
    $0.textColor = .black
  }
  private let detailAddressLabel = UILabel().then {
    $0.font = .body5R14
    $0.numberOfLines = 3
    $0.lineBreakMode = .byClipping
    $0.textColor = .black
  }
  private let phoneLabel = UILabel().then {
    $0.font = .body5R14
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
    self.addSubviews(nameLabel,
                     detailAddressLabel,
                     phoneLabel)
  }
  
  private func setConstraints() {
    nameLabel.snp.makeConstraints {
      $0.bottom.equalTo(detailAddressLabel.snp.top).offset(-8)
      $0.leading.equalToSuperview().offset(20)
    }
    
    detailAddressLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(20)
    }
    
    phoneLabel.snp.makeConstraints {
      $0.top.equalTo(detailAddressLabel.snp.bottom).offset(8)
      $0.leading.equalTo(detailAddressLabel.snp.leading)
    }
  }
  
  func configureView(name: String, address: String, phone: String){
    nameLabel.text = name
    detailAddressLabel.text = address
    phoneLabel.text = phone
    
    self.makeCornerRound(radius: 10)
    self.makeBorder(width: 1, color: .gray1)
  }
}
