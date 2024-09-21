//
//  AccountAddCell.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/21/24.
//

import UIKit

import Then
import SnapKit
import RxSwift

final class AccountAddCell: UITableViewCell {
  
  let disposeBag = DisposeBag()
  
  private let titleLabel = UILabel().then {
    $0.font = .body2Sb18
    $0.textColor = .black
  }
  let textField = UITextField().then {
    $0.font = .body4R16
  }
  private let lineView = UIView().then {
    $0.backgroundColor = .black
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    textField.text = ""
    textField.isUserInteractionEnabled = true
  }
  
  func configureCell(title: String, placeHolder: String, isEditable: Bool) {
    titleLabel.text = title
    textField.placeholder = placeHolder
    textField.isUserInteractionEnabled = isEditable
  }
  
  private func setUI() {
    self.selectionStyle = .none
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    addSubviews(titleLabel, textField, lineView)
  }
  
  private func setConstraints() {
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.top.equalToSuperview().offset(7)
    }
    
    textField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview().inset(20)
    }
    
    lineView.snp.makeConstraints {
      $0.height.equalTo(1)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(7)
    }
  }
}
