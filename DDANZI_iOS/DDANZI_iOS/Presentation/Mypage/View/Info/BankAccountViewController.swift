//
//  InfoDetailViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/30/24.
//

import UIKit

import SnapKit
import Then
import RxSwift

class BankAccountViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  
  private let navigationBarView = CustomNavigationBarView(navigationBarType: .normal)
  private let headerView = MyPageSectionHeaderView()
  private let accountButton = UIButton().then {
    $0.backgroundColor = .white
    $0.makeCornerRound(radius: 10)
    $0.makeBorder(width: 1, color: .gray2)
  }
  
  private let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 16
  }
  
  private let innerStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.alignment = .center
    $0.spacing = 19
  }
  
  private let bankNameLabel = UILabel().then {
    $0.font = .body2Sb18
    $0.textColor = .black
  }
  
  private let accountNumberLabel = UILabel().then {
    $0.font = .body4R16
    $0.textColor = .black
  }
  
  private let nameLabel = UILabel().then {
    $0.font = .body5R14
    $0.textColor = .black
  }
  
  private let detailButton = UIButton().then {
    $0.setImage(.blueArrow, for: .normal)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setUI()
    configureButton()
    bind()
  }
  
  private func setUI() {
    headerView.setTitleLabel(title: "계좌 관리")
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    view.addSubviews(navigationBarView,
                     headerView,
                     accountButton)
    
    accountButton.addSubviews(stackView,
                             detailButton)
    
    stackView.addArrangedSubviews(bankNameLabel,
                                  innerStackView)
    
    innerStackView.addArrangedSubviews(accountNumberLabel,
                                       nameLabel)
  }
  
  private func setConstraints() {
    navigationBarView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
    }
    
    headerView.snp.makeConstraints {
      $0.top.equalTo(navigationBarView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(48)
    }
    
    accountButton.snp.makeConstraints {
      $0.top.equalTo(headerView.snp.bottom).offset(19)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(100)
    }
    
    stackView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(18)
    }
    
    detailButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().inset(18)
    }
  }
  
  func configureButton() {
    bankNameLabel.text = "국민 은행"
    accountNumberLabel.text = "82-123123-123123"
    nameLabel.text = "이승준"
  }
  
  private func bind() {
    navigationBarView.backButtonTap
      .subscribe(onNext: { [weak self] in
        self?.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
  }
}
