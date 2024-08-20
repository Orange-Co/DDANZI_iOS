//
//  OnboardingTermButton.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/20/24.
//

import UIKit

import Then
import SnapKit

final class OnboardingTermButton: UIView {
  
  private let checkButton = UIButton().then {
    $0.setImage(.checkButton, for: .normal)
    $0.setImage(.checkButton.withTintColor(.black), for: .selected)
  }
  
  private let titleLabel = UILabel().then {
    $0.textColor = .gray2
    $0.font = .body4R16
  }
  
  private let moreButton = UIButton().then {
    $0.setTitle("자세히", for: .normal)
    $0.titleLabel?.font = .buttonText
    $0.setTitleColor(.gray2, for: .normal)
  }
  
  init() {
    super.init(frame: .zero)
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
    addSubviews(
      checkButton,
      titleLabel,
      moreButton
    )
  }
  
  private func setConstraints() {
    self.snp.makeConstraints {
      $0.height.equalTo(30)
    }
    
    checkButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints {
      $0.leading.equalTo(checkButton.snp.trailing).offset(12)
      $0.centerY.equalToSuperview()
    }
    
    moreButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview()
    }
  }
  
  func configureButton(title: String, moreLink: String) {
    titleLabel.text = title
  }
}
