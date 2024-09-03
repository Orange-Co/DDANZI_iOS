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
  private let containerView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 5
    $0.makeBorder(width: 1, color: .gray2)
  }
  private let checkImageView = UIImageView().then {
    $0.image = .icCheck.withTintColor(.gray2)
  }
  private let titleLabel = UILabel().then {
    $0.font = .body4R16
    $0.textColor = .gray2
  }
  
  // MARK: - initializer
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - Layout
  private func setUI() {
    self.backgroundColor = .white
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    contentView.addSubviews(containerView)
    containerView.addSubviews(checkImageView, titleLabel)
  }
  
  private func setConstraints() {
    containerView.snp.makeConstraints {
      $0.height.equalTo(38)
      $0.horizontalEdges.equalToSuperview()
      $0.verticalEdges.equalToSuperview().inset(5)
    }
    
    checkImageView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(10)
    }
    
    titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(checkImageView.snp.trailing).offset(10)
    }
  }
  
  // MARK: - Method
  func bindTitle(title: String, isSelected: Bool = false) {
    titleLabel.text = title
    updateCheckBox(isSelected: isSelected)
  }
  
  private func updateCheckBox(isSelected: Bool) {
    checkImageView.image = isSelected ? UIImage(resource: .icCheck) : UIImage(resource: .icCheck).withTintColor(UIColor.gray2)
    titleLabel.textColor = isSelected ? .black : .gray2
    containerView.layer.borderColor = isSelected ? UIColor.black.cgColor : UIColor.gray2.cgColor
  }
}
