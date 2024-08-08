//
//  DdanziTextFieldView.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/9/24.
//

import UIKit

import Then
import SnapKit

final class AddressFormTableViewCell: UITableViewCell {
  // MARK: Properties
  
  var textChanged: ((String?) -> Void)?
  
  // MARK: Compenets
  private let titleLabel = UILabel().then {
    $0.font = .body2Sb18
    $0.textColor = .black
  }
  private let textField = UITextField().then {
    $0.font = .body4R16
    $0.textColor = .gray4
    $0.placeholder = .none
  }
  private let button = DdanziChipButton(title: "우편번호 찾기")
  private let lineView = UIView().then {
    $0.backgroundColor = .black
    $0.isUserInteractionEnabled = false
  }
  
  // MARK: LifeCycles
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setUI()
    configureTextfield()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: LayoutHelper
  
  private func setUI() {
    self.backgroundColor = .white
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    self.selectionStyle = .none
    contentView.addSubviews(
      titleLabel,
      textField,
      button,
      lineView
    )
  }
  
  private func setConstraints() {
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview().inset(20)
    }
    
    textField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(8)
      $0.leading.trailing.equalToSuperview().inset(20)
    }
    
    button.snp.makeConstraints {
      $0.centerY.equalTo(textField)
      $0.trailing.equalToSuperview().inset(20)
    }
    
    lineView.snp.makeConstraints {
      $0.height.equalTo(1)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(15)
    }
  }
  
  private func configureTextfield() {
    textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd)
  }
  
  @objc private func textFieldDidChange() {
    textChanged?(textField.text)
  }
  
  func configureCell(
    title: String,
    placeholder: String,
    initalText: String,
    isButtonCell: Bool,
    isEnableInput: Bool = false
  ) {
    titleLabel.text = title
    textField.setPlaceholder(
      text: placeholder,
      color: .gray2,
      font: .body4R16
    )
    textField.text = initalText
    textField.isUserInteractionEnabled = isEnableInput
    button.isHidden = !isButtonCell
  }
}
