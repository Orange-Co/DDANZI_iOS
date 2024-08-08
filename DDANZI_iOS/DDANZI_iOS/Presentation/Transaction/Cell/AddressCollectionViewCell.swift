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
  
  private let editButton = DdanziMiniButton(title: "수정")
  private let deleteButton = DdanziMiniButton(title: "삭제")
  
  private let stackView = UIStackView().then {
    $0.spacing = 8
    $0.axis = .vertical
    $0.alignment = .leading
  }
  private let buttonStackView = UIStackView().then {
    $0.alignment = .center
    $0.spacing = 12
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
    buttonStackView.addArrangedSubviews(editButton, deleteButton)
    stackView.addArrangedSubviews(
      nameLabel,
      detailAddressLabel,
      phoneLabel,
      buttonStackView
    )
    self.addSubviews(stackView)
  }
  
  private func setConstraints() {
    stackView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
  }
  
  func configureView(name: String, address: String, phone: String, isEditable: Bool = false){
    nameLabel.text = name
    detailAddressLabel.text = address
    phoneLabel.text = phone
    buttonStackView.isHidden = !isEditable
    stackView.setCustomSpacing(15, after: phoneLabel)
    self.makeCornerRound(radius: 10)
    self.makeBorder(width: 1, color: .gray1)
  }
}
