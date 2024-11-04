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
import AuthenticationServices
import Amplitude


final class LoginViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private var signUpFrom: String
  
  private let backButton = UIButton().then {
    $0.setImage(.icCancel, for: .normal)
  }
  private let imageView = UIImageView().then {
    $0.image = .onboarding
  }
  private let kakaoLoginButton = UIButton().then {
    $0.setImage(.kakaoLoginLargeWide1, for: .normal)
  }
  private let appleLoginButton = UIButton().then {
    $0.setImage(.appleLogin, for: .normal)
  }
  
  init(signUpFrom: String) {
    self.signUpFrom = signUpFrom
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = true
    self.tabBarController?.tabBar.isHidden = true
    Amplitude.instance().logEvent("view_sign_up", withEventProperties: ["sign_up_from":signUpFrom])
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
    view.addSubviews(imageView,
                     backButton,
                     kakaoLoginButton,
                     appleLoginButton)
  }
  
  private func setConstraints() {
    backButton.snp.makeConstraints {
      $0.top.equalToSuperview().inset(70.adjusted)
      $0.trailing.equalToSuperview().inset(20.adjusted)
    }
    
    imageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(80.adjusted)
    }
    
    kakaoLoginButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(80.adjusted)
      $0.centerX.equalToSuperview()
    }
    
    appleLoginButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(kakaoLoginButton.snp.top).offset(-15.adjusted)
    }
  }
  
  private func bind() {
    backButton.rx.tap
      .bind(with: self) { owner, void in
        self.navigationController?.popViewController(animated: true)
      }
      .disposed(by: disposeBag)
    
    kakaoLoginButton.rx.tap
      .bind(with: self) { owner, void in
        Amplitude.instance().logEvent("click_sign_up_kakao")
        owner.kakaoLogin()
      }
      .disposed(by: disposeBag)
    
    appleLoginButton.rx.tap
      .bind(with: self, onNext: { owner, _ in
        Amplitude.instance().logEvent("click_sign_up_apple")
        owner.performAppleLogin()
      })
      .disposed(by: disposeBag)
  }
  
  private func kakaoLogin() {
    if (UserApi.isKakaoTalkLoginAvailable()) {
      UserApi.shared.rx.loginWithKakaoTalk()
        .subscribe(with: self, onNext: { owner, oauthToken in
          print("카카오계정으로 로그인 성공👏")
          self.postSocialLogin(token: oauthToken.accessToken, type: .kakao)
        }, onError: { owner, error in
          print(error)
        })
        .disposed(by: disposeBag)
    } else {
      UserApi.shared.rx.loginWithKakaoAccount()
        .subscribe(with: self, onNext: { owner, oauthToken in
          print("카카오계정으로 로그인 성공👏")
          self.postSocialLogin(token: oauthToken.accessToken, type: .kakao)
        }, onError: { owner, error in
          print(error)
        })
        .disposed(by: disposeBag)
    }
  }
  
  private func performAppleLogin() {
    let request = ASAuthorizationAppleIDProvider().createRequest()
    request.requestedScopes = [.fullName, .email]
    
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
  }

  
  private func postSocialLogin(token: String, type: SocialLoginType) {
    let authDTO = SocialLoginRequestDTO(token: token, type: type, devicetoken: KeychainWrapper.shared.deviceUUID, deviceType: "iOS", fcmToken: UserDefaults.standard.string(forKey: .fcmToken) ?? "")
    Providers.AuthProvider.request(target: .socialLogin(authDTO), instance: BaseResponse<SocialLoginResponseDTO>.self) { result in
      guard let data = result.data else { return }
      if !KeychainWrapper.shared.setAccessToken(data.accesstoken) {
        UserDefaults.standard.set(data.accesstoken, forKey: .accesstoken)
      }
      UserDefaults.standard.set(data.refreshtoken, forKey: .refreshToken)
      if data.status == "ACTIVATE" {
        UserDefaults.standard.set(true, forKey: .isLogin)
        self.navigationController?.popToRootViewController(animated: true)
      } else {
        UserDefaults.standard.set(false, forKey: .isLogin)
        self.navigationController?.pushViewController(CertificationViewController(), animated: true)
      }
    }
  }
  
}

extension LoginViewController: ASAuthorizationControllerDelegate {
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      let userIdentifier = appleIDCredential.user
      let fullName = appleIDCredential.fullName
      let email = appleIDCredential.email
      let identityToken = appleIDCredential.identityToken
      let authorizationCode = appleIDCredential.authorizationCode
      
      guard let code = appleIDCredential.authorizationCode else { return }
      guard let codeStr = String(data: code, encoding: .utf8) else { return }
      
      // 애플 로그인 성공 후 identityToken을 사용해 서버에 토큰 전송
      if let identityToken = identityToken, let tokenString = String(data: identityToken, encoding: .utf8) {
        self.postSocialLogin(token: codeStr, type: .apple)
        print(tokenString)
      }
    }
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // 애플 로그인 실패 시 처리
    print("Apple Login Failed: \(error.localizedDescription)")
  }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
  
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window!
  }
}
