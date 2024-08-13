//
//  OptionCollectionViewCell.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/23/24.
//

import UIKit

import Then
import SnapKit
import RxSwift
import RxCocoa

final class OptionCollectionViewCell: UICollectionViewCell {
  
  private let disposeBag = DisposeBag()
  private let titleLabel = UILabel().then {
    $0.font = .body5R14
    $0.textColor = .black
  }
  
  // Relay to handle selection state
  let isSelectedRelay = BehaviorRelay<Bool>(value: false)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(titleLabel)
    
    titleLabel.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
    
    bindUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func bindUI() {
    // Bind the selection state to UI changes
    isSelectedRelay
      .asDriver()
      .drive(onNext: { [weak self] isSelected in
        self?.titleLabel.textColor = isSelected ? .black : .gray2
      })
      .disposed(by: disposeBag)
  }
  
  func configureCell(text: String, isEnable: Bool) {
    titleLabel.text = text
    isUserInteractionEnabled = isEnable
  }
}
