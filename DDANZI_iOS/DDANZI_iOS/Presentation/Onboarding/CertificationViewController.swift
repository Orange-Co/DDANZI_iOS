//
//  CertificationViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/23/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import iamport_ios

final class CertificationViewController: UIViewController {
  private let disposeBag = DisposeBag()
  var iamportResponse: IamportResponse?
  private var portoneToken: String = ""
  
  private let titleLabel = UILabel().then {
    $0.text = "본인 인증을 진행해주세요"
    $0.font = .title3Sb28
    $0.textColor = .black
  }
  private let guideLabel = UILabel().then {
    $0.text = "안전한 거래를 위해\n본인 인증이 필요해요"
    $0.textColor = .black
    $0.font = .body1B20
    $0.numberOfLines = 2
  }
  private let certificationButton = DdanziButton(title: "본인인증하러 가기")
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.isNavigationBarHidden = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
    bind()
  }
  
  private func setUI() {
    view.backgroundColor = .white
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    view.addSubviews(titleLabel,
                     guideLabel,
                     certificationButton)
    
  }
  
  private func setConstraints() {
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.top.equalToSuperview().offset(120)
    }
    
    guideLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(12)
      $0.leading.equalToSuperview().offset(20)
    }
    
    certificationButton.snp.makeConstraints {
      $0.height.equalTo(50)
      $0.bottom.equalToSuperview().inset(80)
      $0.leading.trailing.equalToSuperview().inset(20)
    }
  }
  
  private func bind() {
    certificationButton.rx.tap
      .bind { [weak self] in
        guard let self else { return }
        self.fetchToken()
        self.requestCertification()
      }
      .disposed(by: disposeBag)
  }
  
  private func requestCertification() {
    // WebViewContorller 용 닫기버튼 생성
    Iamport.shared.useNavigationButton(enable: true)
    let certification = IamportCertification(merchant_uid: UUID().uuidString).then {
      $0.min_age = 20
      $0.name = ""
      $0.phone = ""
      $0.carrier = ""
    }
    
    // use for UIViewController
    Iamport.shared.certification(
      viewController: self,
      userCode: Config.impCode,
      certification: certification
    ) { [weak self] iamportResponse in
      self?.iamportCallback(iamportResponse)
    }
  }
  
  func iamportCallback(_ response: IamportResponse?) {
    if let res = response {
      print("Iamport response: \(res)")
      fetchCertiInfo(code: res.imp_uid ?? "")
    }
    iamportResponse = response
  }
  
  private func fetchToken() {
    Providers.PortOneProvider.request(target: .getAccessToken(body: .init(impKey: Config.impKey, impSecret: Config.impSecret)),
                                      instance: PortOneBaseResponse<PortOneTokenResponseDTO>.self) { result in
      guard let data = result.data else { return }
      self.portoneToken = data.accessToken
    }
  }
  
  private func fetchCertiInfo(code: String) {
    Providers.PortOneProvider.request(target: .getCertificationInfo(id: code, token: portoneToken),
                                      instance: PortOneBaseResponse<PortOneCertiResponseDTO>.self) { [self] result in
      guard let data = result.data else { return }
      if let name = data.name,
         let phone = data.phone,
         let birth = data.birthday,
         let sex = data.gender {
        self.postVerification(user: .init(name: name, phone: phone, birth: birth, sex: sex.uppercased()))
      }
    }
  }
  
  private func postVerification(user: VerificationRequestDTO) {
    Providers.AuthProvider.request(target: .certification(user),
                                   instance: BaseResponse<VerificationResponseDTO>.self) { result in
      UserDefaults.standard.set(true, forKey: .isLogin)
      self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }
  }
}
