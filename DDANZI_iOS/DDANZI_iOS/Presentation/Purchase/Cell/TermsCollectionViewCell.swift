//
//  TermsCollectionViewCell.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/16/24.
//

import UIKit

import SnapKit
import Then

final class TermsCollectionViewCell: UICollectionViewCell {
  private let imageView = UIImageView().then {
    $0.image = .icBlackCheck
  }
  private let titleLabel = UILabel().then {
    $0.text = "아래 약관에 전체동의해요"
    $0.font = .body1B20
    $0.textColor = .black
  }
  private let termsTableView = UITableView(frame: .zero, style: .plain).then {
    $0.separatorStyle = .none
    $0.register(TermsTableViewCell.self, forCellReuseIdentifier: TermsTableViewCell.className)
  }
    
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
    configureTableView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUI() {
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    self.addSubviews(imageView,
                     titleLabel,
                     termsTableView)
  }
  
  private func setConstraints() {
    imageView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints {
      $0.centerY.equalTo(imageView.snp.centerY)
      $0.leading.equalTo(imageView.snp.trailing).offset(5)
    }
    
    termsTableView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(14)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func configureTableView() {
    termsTableView.dataSource = self
  }
}

extension TermsCollectionViewCell: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TermsTableViewCell.className,
                                                   for: indexPath) as? TermsTableViewCell else {
      return UITableViewCell()
    }
    cell.selectionStyle = .none
    cell.bindTitle(title: "동의한 약관")
    return cell
  }
}
