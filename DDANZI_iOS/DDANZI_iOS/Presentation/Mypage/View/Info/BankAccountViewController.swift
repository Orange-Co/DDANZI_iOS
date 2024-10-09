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
  private var bankAccountId: Int?
  
  private let navigationBarView = CustomNavigationBarView(navigationBarType: .normal)
  private let headerView = MyPageSectionHeaderView()
  
  private let registerButton = UIButton().then {
    $0.backgroundColor = .white
    $0.makeBorder(width: 1, color: .gray2)
    $0.setTitleColor(.black, for: .normal)
    $0.setTitle("+ 계좌 등록", for: .normal)
    $0.titleLabel?.font = .body4R16
    $0.makeCornerRound(radius: 10)
    $0.isHidden = true // 초기 상태는 숨김
  }
  
  private let accountButton = UIButton().then {
    $0.backgroundColor = .white
    $0.makeCornerRound(radius: 10)
    $0.makeBorder(width: 1, color: .gray2)
    $0.isHidden = true // 초기 상태는 숨김
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchAccountInfo()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setUI()
    fetchAccountInfo()
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
                     accountButton,
                     registerButton)
    
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
    
    registerButton.snp.makeConstraints {
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
  
  // 계좌 추가 필요
  func fetchAccountInfo() {
    Providers.MypageProvider.request(target: .fetchUserAccount, instance: BaseResponse<UserAccountDTO>.self) { response in
      guard let data = response.data else { return }
      if let bank = data.bank,
         let accountNumber = data.accountNumber,
         let accountId = data.accountId {
        if let bank = BankList.banks.first(where: { $0.code == bank }) {
            self.bankNameLabel.text = bank.name // 은행 이름 설정
        } else {
            self.bankNameLabel.text = "알 수 없는 은행" // 매칭되지 않는 경우 처리
        }
        self.nameLabel.text = data.name
        self.accountNumberLabel.text = accountNumber
        self.accountButton.isHidden = false
        self.registerButton.isHidden = true // 계좌 정보가 있으면 등록 버튼을 숨김
        self.bankAccountId = accountId
      } else {
        // 계좌 정보가 없으면 등록 버튼을 보이고 계좌 정보 버튼을 숨김
        self.accountButton.isHidden = true
        self.registerButton.isHidden = false
      }
    }
  }
  
  private func bind() {
    navigationBarView.backButtonTap
      .subscribe(onNext: { [weak self] in
        self?.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
    
    registerButton.rx.tap
      .subscribe(with: self) { owner, _ in
        // 계좌 등록 화면으로 이동하는 로직 추가
        owner.navigateToAccountRegistration()
      }
      .disposed(by: disposeBag)
    
    accountButton.rx.tap
      .subscribe(with: self) { owner, _ in
        owner.navigateToAccountRegistration()
      }
      .disposed(by: disposeBag)
  }
  
  // 계좌 등록 화면으로 이동하는 함수
  private func navigateToAccountRegistration() {
    // 계좌 등록 화면 이동 로직을 구현
    let accountRegistrationVC = AccountAddViewController(bankAccountId: bankAccountId)
    self.navigationController?.pushViewController(accountRegistrationVC, animated: true)
  }
}
