//
//  OptionHeaderView.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/14/24.
//

import UIKit

import SnapKit
import Then

final class OptionSectionHeaderView: UICollectionReusableView {
  static let identifier = "OptionSectionHeaderView"
  
  private let titleLabel = UILabel().then {
    $0.font = .body3Sb16
    $0.textColor = .black
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(titleLabel)
    
    titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with title: String) {
    titleLabel.text = title
  }
}
