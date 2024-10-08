//
//  KakaoCopyTableViewCell.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/13/24.
//

import UIKit

import SnapKit
import Then
import RxSwift

final class KakaoCopyTableViewCell: UITableViewCell {
  var disposeBag = DisposeBag()
  var copybuttonTap: Observable<Void> {
    return copyChipButton.rx.tap.asObservable()
  }
  var copycontent = ""
  
  private let titleLabel = UILabel().then {
    $0.font = .body2Sb18
  }
  private let contentLabel = UILabel().then {
    $0.font = .body5R14
  }
  private let copyChipButton = DdanziChipButton(title: "복사").then {
    $0.isEnabled = true  // 버튼이 활성화 상태인지 확인
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
    disposeBag = DisposeBag()
    copyChipButton.isHidden = false
    copycontent = ""
  }
  
  private func setUI() {
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    self.addSubviews(titleLabel, contentLabel, copyChipButton)
  }
  
  private func setConstraints() {
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.leading.equalToSuperview().offset(20)
    }
    
    contentLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(5)
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.width.equalTo(260)
    }
    
    copyChipButton.snp.makeConstraints {
      $0.centerY.equalTo(contentLabel.snp.centerY)
      $0.trailing.equalToSuperview().inset(20)
    }
  }
  
  func configure(title: String, content: String, isCopy: Bool) {
    self.titleLabel.text = title
    self.contentLabel.text = content
    self.copycontent = content
    self.copyChipButton.isHidden = !isCopy
  }
}
