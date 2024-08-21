//
//  PurchaseHeaderView.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/16/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

class PurchaseHeaderView: UICollectionReusableView {
  
  var isEmptyAddress: Bool = false
  let buttonTapRelay = PublishRelay<Void>()
  
  let disposeBag = DisposeBag()
  
  
  private let titleLabel = UILabel().then {
    $0.font = .title4Sb24
    $0.textColor = .black
  }
  private let editButton = UIButton().then {
    $0.setTitle("변경", for: .normal)
    $0.setTitleColor(.gray3, for: .normal)
    $0.backgroundColor = .white
    $0.makeCornerRound(radius: 5)
    $0.makeBorder(width: 1, color: .gray3)
    $0.titleLabel?.font = .body6M12
  }
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
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
    self.addSubviews(titleLabel,
                     editButton)
  }
  
  private func setConstraints() {
    titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview()
    }
    
    editButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview()
    }
  }
  
  func configureHeader(title: String, isEditable: Bool, isEmptyAddress: Bool) {
    titleLabel.text = title
    editButton.isHidden = !isEditable
    self.isEmptyAddress = isEmptyAddress
    if isEmptyAddress && isEditable {
      // Assuming you have a button in your header
      let button = UIButton()
      button.setTitle("주소 추가하기", for: .normal)
      addSubview(button)
      
      // Layout your button within the header view
      button.snp.makeConstraints {
        // Adjust constraints as needed
        $0.edges.equalToSuperview()  // Example constraint
      }
      
      // Bind button tap to the relay
      button.rx.tap
        .bind(to: buttonTapRelay)
        .disposed(by: disposeBag)
    }
  }
}
