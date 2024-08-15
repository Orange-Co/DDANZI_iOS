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
import RxKakaoSDKUser
import KakaoSDKUser

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
      .bind(with: self) { owner, void in
        owner.kakaoLogin()
      }
      .disposed(by: disposeBag)
    
    appleLoginButton.rx.tap
      .bind { [weak self] in
        guard let self else { return }
        self.navigationController?.pushViewController(CertificationViewController(), animated: true)
      }
      .disposed(by: disposeBag)
  }
  
  private func kakaoLogin() {
    if (UserApi.isKakaoTalkLoginAvailable()) {
      UserApi.shared.rx.loginWithKakaoTalk()
        .subscribe(with: self, onNext: { owner, oauthToken in
          print("카카오계정으로 로그인 성공👏")
          self.postSocialLogin(token: oauthToken.accessToken)
          self.navigationController?.pushViewController(CertificationViewController(), animated: true)
        }, onError: { owner, error in
          print(error)
        })
        .disposed(by: disposeBag)
    } else {
      UserApi.shared.rx.loginWithKakaoAccount()
        .subscribe(with: self, onNext: { owner, oauthToken in
          print("카카오계정으로 로그인 성공👏")
          self.postSocialLogin(token: oauthToken.accessToken)
          self.navigationController?.pushViewController(CertificationViewController(), animated: true)
        }, onError: { owner, error in
          print(error)
        })
        .disposed(by: disposeBag)
    }
  }
  
  private func postSocialLogin(token: String) {
    let authDTO = SocialLoginRequestDTO(token: token, type: .kakao)
    Providers.AuthProvider.request(target: .socialLogin(authDTO), instance: BaseResponse<SocialLoginResponseDTO>.self) { result in
      guard let data = result.data else { return }
      UserDefaults.standard.set(data.nickname, forKey: .nickName)
      UserDefaults.standard.set(data.accesstoken, forKey: .accesstoken)
      UserDefaults.standard.set(data.refreshtoken, forKey: .refreshToken)
    }
  }
  
}
