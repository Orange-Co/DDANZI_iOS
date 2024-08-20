//
//  OnboardingTermButton.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/20/24.
//

import UIKit

import Then
import SnapKit

final class OnboardingTermButton: UIButton {
  
  let checkButton = UIButton().then {
    $0.setImage(.checkButton, for: .normal)
    $0.setImage(.checkButton.withTintColor(.black), for: .selected)
  }
  
  private let termTitleLabel = UILabel().then {
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
      termTitleLabel,
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
    
    termTitleLabel.snp.makeConstraints {
      $0.leading.equalTo(checkButton.snp.trailing).offset(12)
      $0.centerY.equalToSuperview()
    }
    
    moreButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview()
    }
  }
  
  func configureButton(terms: TermModel) {
    termTitleLabel.text = terms.title
    moreButton.isHidden = !terms.isRequired
  }
  
  func selectedButton(isSelect: Bool) {
    termTitleLabel.textColor = isSelect ? .black : .gray2
    checkButton.isSelected = isSelect
  }
}
