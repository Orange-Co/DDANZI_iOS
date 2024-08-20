//
//  AgreeTermsViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/20/24.
//

import UIKit

import Then
import SnapKit
import RxSwift

protocol AgreeTermsViewControllerDelegate: AnyObject {
  func termsViewControllerDidFinish(_ viewController: AgreeTermsViewController)
}

final class AgreeTermsViewController: UIViewController {
  
  weak var delegate: AgreeTermsViewControllerDelegate?
  private var disposeBag = DisposeBag()
  
  // MARK: Properties
  
  private let termList: [TermModel] = [
    .init(title: "개인정보 처라방침 (필수)", isRequired: true, moreLink: ""),
    .init(title: "서비스 이용 약관 (필수)", isRequired: true, moreLink: ""),
    .init(title: "마케팅 수신 동의 (선택)", isRequired: false)
  ]
  
  // MARK: Compenets
  
  private let titleLabel = UILabel().then {
    $0.text = "아래 약관에 전체 동의해요"
    $0.font = .body2Sb20
    $0.textColor = .black
  }
  
  private let checkButton = UIButton().then {
    $0.setImage(.circleCheckButton, for: .normal)
  }
  
  private let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 10
    $0.alignment = .fill
    $0.distribution = .equalSpacing
  }
  
  private let nextButton = DdanziButton(title: "동의하고 본인인증하러 가기", enable: false)
  
  // MARK: LifeCycles
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupButtons()
    setUI()
  }
  
  
  // MARK: LayoutHelper
  
  private func setupButtons() {
    termList.forEach { term in
      let termButton = OnboardingTermButton()
      termButton.configureButton(title: term.title, moreLink: term.moreLink ?? "")
      stackView.addArrangedSubview(termButton)
    }
  }
  
  private func setUI() {
    self.view.backgroundColor = .white
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    view.addSubviews(
      checkButton,
      titleLabel,
      stackView,
      nextButton
    )
  }
  
  private func setConstraints() {
    checkButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.top.equalToSuperview().offset(40)
    }
    
    titleLabel.snp.makeConstraints {
      $0.leading.equalTo(checkButton.snp.trailing).offset(12)
      $0.centerY.equalTo(checkButton)
    }
    
    stackView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview().inset(20)
    }
    
    nextButton.snp.makeConstraints {
      $0.height.equalTo(50)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(70)
    }
  }
  
  private func bind() {
    nextButton.rx.tap
      .bind {
        self.dismiss(animated: true) {
          self.delegate?.termsViewControllerDidFinish(self)
        }
      }
      .disposed(by: disposeBag)
  }
}
