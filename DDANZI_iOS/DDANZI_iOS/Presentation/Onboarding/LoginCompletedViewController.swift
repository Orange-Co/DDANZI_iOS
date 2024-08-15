//
//  LoginCompletedViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/23/24.
//

import UIKit

import SnapKit
import Then

final class LoginCompletedViewController: UIViewController {

  private let checkImageView = UIImageView().then {
    $0.image = .icBlackCheck
  }
  private let welcomeLabel = UILabel().then {
    $0.font = .title4Sb24
    $0.textColor = .black
    $0.text = "환영해요!"
  }
  private let nickNameLabel = UILabel().then {
    $0.font = .title2R32
    $0.textColor = .black
    $0.text = "\(UserDefaults.standard.string(forKey: .nickName) ?? "")님"
  }
  private let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 30
    $0.alignment = .center
  }
  private let completeButton = DdanziButton(title: "완료", enable: true)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
  }
  
  private func setUI() {
    self.view.backgroundColor = .white
    setHierarchy()
    setConstraints()
    bind()
  }
  
  private func setHierarchy() {
    view.addSubviews(stackView, completeButton)
    stackView.addArrangedSubviews(
      checkImageView,
      welcomeLabel,
      nickNameLabel
    )
  }
  
  private func setConstraints() {
    checkImageView.snp.makeConstraints {
      $0.size.equalTo(69)
    }
    
    stackView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().inset(120)
    }
    
    completeButton.snp.makeConstraints {
      $0.height.equalTo(50)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(80)
    }
  }
  
  private func bind() {
    
  }
}
