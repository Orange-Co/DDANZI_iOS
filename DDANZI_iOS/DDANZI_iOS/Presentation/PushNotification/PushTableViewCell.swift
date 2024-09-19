//
//  PushTableViewCell.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/13/24.
//

import UIKit

import SnapKit
import Then

final class PushTableViewCell: UITableViewCell {
  private let titleLabel = UILabel().then {
    $0.font = UIFont(name: "Pretendard-Bold", size: 14)
    $0.textColor = .black
  }
  
  private let contentsLabel = UILabel().then {
    $0.font = .body6M12
    $0.textColor = .black
  }
  
  private let timeLabel = UILabel().then {
    $0.font = .body7M10
    $0.textAlignment = .right
    $0.textColor = .gray2
  }
  
  private let seperatorView = UIView().then {
    $0.backgroundColor = .gray2
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
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
    self.addSubviews(titleLabel, contentsLabel, timeLabel, seperatorView)
  }
  
  private func setConstraints() {
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.leading.trailing.equalToSuperview().inset(20)
    }
    
    contentsLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview().inset(20)
    }
    
    timeLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.trailing.equalToSuperview().inset(20)
    }
    
    seperatorView.snp.makeConstraints {
      $0.height.equalTo(1)
      $0.bottom.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(20)
    }
  }
  
  override func prepareForReuse() {
    self.backgroundColor = .clear
  }
  
  func configure(title: String, contents: String, time: String, isRead: Bool) {
    self.titleLabel.text = title
    self.contentsLabel.text = contents
    self.timeLabel.text = time
    
    self.backgroundColor = isRead ? UIColor(hex: "FFF9DB") : .clear
  }
}
