//
//  TermsTableViewCell.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/16/24.
//

import UIKit

import Then
import SnapKit

final class TermsTableViewCell: UITableViewCell {
  private let checkImageView = UIImageView().then {
    $0.image = .icCheck
  }
  private let titleLabel = UILabel().then {
    $0.font = .body4R16
    $0.textColor = .gray4
  }
  

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUI() {
    self.backgroundColor = .white
    self.makeCornerRound(radius: 5)
    self.makeBorder(width: 1, color: .gray3)
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    self.addSubviews(checkImageView, titleLabel)
  }
  
  private func setConstraints() {
    checkImageView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(10)
    }
    
    titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(checkImageView.snp.trailing).offset(10)
    }
  }
  
  func bindTitle(title: String) {
    titleLabel.text = title
  }
}
