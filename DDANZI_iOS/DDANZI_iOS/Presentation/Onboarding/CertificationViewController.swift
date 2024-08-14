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
  
  private let titleLabel = UILabel().then {
    $0.text = "잠깐!"
    $0.font = .title3Sb28
    $0.textColor = .black
  }
  private let guideLabel = UILabel().then {
    $0.text = "안전한 딴지 사용을 위해\n본인 인증을 완료해주세요"
    $0.textColor = .black
    $0.font = .body5R14
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
      self?.navigationController?.pushViewController(LoginCompletedViewController(), animated: true)
    }
  }
  
  func iamportCallback(_ response: IamportResponse?) {
      print("------------------------------------------")
      print("결과 왔습니다~~")
      if let res = response {
          print("Iamport response: \(res)")
      }
      print("------------------------------------------")

      iamportResponse = response
  }
}
