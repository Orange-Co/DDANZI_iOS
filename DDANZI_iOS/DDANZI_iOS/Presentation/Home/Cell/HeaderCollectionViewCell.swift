//
//  HeaderCollectionViewCell.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/16/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

class HeaderCollectionViewCell: UICollectionViewCell {
  // MARK: Properties
  let disposeBag = DisposeBag()
  
  // MARK: Compenets
  private let bannerImageView = UIImageView().then {
    $0.backgroundColor = .gray1
  }
  
  // MARK: LifeCycles
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: LayoutHelper
  private func setUI() {
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    self.addSubviews(bannerImageView)
  }
  
  private func setConstraints() {
    bannerImageView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(200)
    }
  }
  
  func bindData(bannerImagaURL: String) {
    bannerImageView.setImage(with: bannerImagaURL)
  }
}
