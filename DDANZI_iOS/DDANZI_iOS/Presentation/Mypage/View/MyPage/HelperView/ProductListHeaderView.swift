//
//  ProductListHeaderView.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/5/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class ProductListHeaderView: UIView {
  /// 상품 개수를 나타냅니다.
  var count = 10
  private let disposeBag = DisposeBag()
  
  
  // MARK: - UIComponents
  private let countLabel = UILabel().then {
    $0.font = .body4R16
    $0.textColor = .gray3
  }
  
  // MARK: - Initalizer
  init(isEditable: Bool) {
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - Layout Helper
  private func setUI() {
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    self.addSubviews(countLabel)
  }
  
  private func setConstraints() {
    countLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.centerY.equalToSuperview()
    }
    
  }
  
  //  func bind(to viewModel: PurchaseListViewModel) {
  //       editButton.rx.tap
  //           .bind(to: viewModel.editModeTapped)
  //           .disposed(by: disposeBag)
  //   }
  
  
  func setCount(count: Int) {
    countLabel.text = "총 \(count)개"
  }
}

