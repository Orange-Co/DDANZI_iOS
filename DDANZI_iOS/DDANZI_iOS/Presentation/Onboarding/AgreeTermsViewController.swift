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
  
  private typealias Link = StringLiterals.Link.Terms
  
  weak var delegate: AgreeTermsViewControllerDelegate?
  
  private var disposeBag = DisposeBag()
  private var isAllSelected = false
  private var termButtons: [OnboardingTermButton] = []
  
  // MARK: Properties
  
  private let termList: [TermModel] = [
    .init(title: "개인정보 처라방침 (필수)", isRequired: true, moreLink: Link.privacy),
    .init(title: "서비스 이용 약관 (필수)", isRequired: true, moreLink: Link.serviceTerm),
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
    $0.setImage(.circleCheckButton.withTintColor(.black), for: .selected)
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
    bind()
  }
  
  
  // MARK: LayoutHelper
  
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
  
  
  private func setupButtons() {
    termList.forEach { term in
      let termButton = OnboardingTermButton()
      termButton.configureButton(terms: term)
      termButton.rx.tap
        .bind { [weak self] in
          guard let self = self else { return }
          termButton.selectedButton(isSelect: !termButton.checkButton.isSelected)
          self.updateAllSelectState()
        }
        .disposed(by: disposeBag)
      stackView.addArrangedSubview(termButton)
      termButtons.append(termButton)
    }
  }
  
  private func updateAllSelectState() {
    let allSelected = termButtons.allSatisfy { $0.checkButton.isSelected }
    isAllSelected = allSelected
    checkButton.isSelected = allSelected
    updateNextButtonState()
  }
  
  private func updateNextButtonState() {
    let requiredTermsSelected = termButtons.enumerated().allSatisfy { index, button in
      let term = termList[index]
      return !term.isRequired || button.checkButton.isSelected
    }
    if requiredTermsSelected { nextButton.setEnable() }
  }
  
  private func bind() {
    checkButton.rx.tap
      .bind { [weak self] in
        guard let self = self else { return }
        self.isAllSelected.toggle()
        self.checkButton.isSelected = self.isAllSelected
        self.termButtons.forEach {
          $0.selectedButton(isSelect: self.isAllSelected)
        }
        self.updateAllSelectState()
      }
      .disposed(by: disposeBag)
    
    nextButton.rx.tap
      .bind { [weak self] in
        guard let self = self else { return }
        self.dismiss(animated: true) {
          self.delegate?.termsViewControllerDidFinish(self)
        }
      }
      .disposed(by: disposeBag)
  }
}
