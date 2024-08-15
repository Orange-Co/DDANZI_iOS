//
//  LoginHeader.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/27/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class LoginHeaderView: UIView {
  
  private let loginButton = UIButton().then {
    $0.setImage(.blueArrow, for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.semanticContentAttribute = .forceRightToLeft
    var config = UIButton.Configuration.plain()
    config.imagePadding = 10
    config.contentInsets = .zero
    
    let titleAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.title2R32,
      .foregroundColor: UIColor.black
    ]
    let attributedTitle = NSAttributedString(string: "로그인/회원가입", attributes: titleAttributes)
    
    // Set the attributed title for the normal state
    config.attributedTitle = AttributedString(attributedTitle)
    
    $0.configuration = config
  }
  
  private let disposeBag = DisposeBag()
  
  private let loginButtonSubject = PublishSubject<Void>()
  var loginButtonTapped: Observable<Void> { loginButtonSubject.asObservable() }
  
  init() {
    super.init(frame: .zero)
    setUI()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUI() {
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    self.addSubviews(loginButton)
  }
  
  private func setConstraints() {
    loginButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.centerY.equalToSuperview()
    }
  }
  
  private func bind() {
    loginButton.rx.tap
      .bind(to: loginButtonSubject)
      .disposed(by: disposeBag)
  }
}

