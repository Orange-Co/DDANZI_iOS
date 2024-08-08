//
//  LoginViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/23/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
  private let disposeBag = DisposeBag()
  
  private let guideLabel = UILabel()
  private let kakaoLoginButton = UIButton().then {
    $0.setImage(.kakaoLoginLargeWide1, for: .normal)
  }
  private let appleLoginButton = UIButton().then {
    $0.setImage(.appleLogin, for: .normal)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
    bind()
  }
  
  private func setUI() {
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    view.backgroundColor = .white
    view.addSubviews(guideLabel,
                     kakaoLoginButton,
                     appleLoginButton)
  }
  
  private func setConstraints() {
    guideLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(80)
      $0.leading.equalToSuperview().offset(20)
    }
    
    kakaoLoginButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(80)
      $0.centerX.equalToSuperview()
    }
    
    appleLoginButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(kakaoLoginButton.snp.top).offset(-15)
    }
  }
  
  private func bind() {
    kakaoLoginButton.rx.tap
      .bind { [weak self] in
        guard let self else { return }
        self.navigationController?.pushViewController(CertificationViewController(), animated: true)
      }
      .disposed(by: disposeBag)
    
    appleLoginButton.rx.tap
      .bind { [weak self] in
        guard let self else { return }
        self.navigationController?.pushViewController(CertificationViewController(), animated: true)
      }
      .disposed(by: disposeBag)
  }
  
}
