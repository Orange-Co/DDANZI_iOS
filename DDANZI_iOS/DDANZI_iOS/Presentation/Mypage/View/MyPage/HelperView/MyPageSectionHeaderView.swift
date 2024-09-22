//
//  MyPageSectionHeaderView.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/27/24.
//

import UIKit

import SnapKit
import Then

final class MyPageSectionHeaderView: UIView {
  
  private let titleLabel = UILabel().then {
    $0.textColor = .black
    $0.font = .body2Sb20
  }
  
  private let lineView = UIView().then {
    $0.backgroundColor = .black
  }
  
  init() {
    super.init(frame: .zero)
    setUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUI() {
    self.backgroundColor = .white
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    self.addSubviews(titleLabel, lineView)
  }
  
  private func setConstraints() {
    titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(20)
    }
    
    lineView.snp.makeConstraints {
      $0.height.equalTo(1)
      $0.top.equalTo(titleLabel.snp.bottom).offset(5)
      $0.leading.trailing.equalToSuperview().inset(20)
    }
  }
  
  func setTitleLabel(title: String){
    titleLabel.text = title
  }
}

