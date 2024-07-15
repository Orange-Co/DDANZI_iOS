//
//  SectionHeaderCollectionReusableView.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/10/24.
//

import UIKit

import Then
import SnapKit

final class DetailSectionHeaderView: UICollectionReusableView {
  private let titleLabel = UILabel().then {
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
      addSubview(titleLabel)
      titleLabel.snp.makeConstraints {
          $0.edges.equalToSuperview()
      }
  }
  
  func bindTitle(title: String) {
    titleLabel.text = title
  }
}
