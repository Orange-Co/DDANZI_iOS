//
//  StatusView.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/10/24.
//

import UIKit

import SnapKit
import Then

final class StatusView: UIView {
  private let titleLabel = UILabel().then {
    $0.textColor = .black
    $0.font = .title4Sb24
  }
  
  private let purchaseCodeLabel = UILabel().then {
    $0.font = .body4R16
    $0.textColor = .gray4
  }
  
  private lazy var stackView = UIStackView().then {
    $0.addArrangedSubviews(titleLabel,
                           purchaseCodeLabel)
    $0.axis = .vertical
    $0.spacing = 12
    $0.alignment = .center
  }
  
  init(title: String, code: String) {
    super.init(frame: .zero)
    configureView(title: title, code: code)
    setUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureView(title: String, code: String) {
    self.backgroundColor = .white
    self.makeBorder(width: 1, color: .gray2)
    self.makeCornerRound(radius: 10)
    purchaseCodeLabel.text = "거래 번호 \(code)"
    titleLabel.text = title
  }
  
  private func setUI() {
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    self.addSubviews(stackView)
  }
  
  private func setConstraints() {
    stackView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
}

