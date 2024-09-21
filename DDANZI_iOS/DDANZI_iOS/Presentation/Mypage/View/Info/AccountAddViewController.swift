//
//  AccountAddViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/21/24.
//

import UIKit

import Then
import SnapKit

import RxSwift
import RxCocoa
import RxDataSources
import RxGesture

final class AccountAddViewController: UIViewController {
  
  // MARK: Property
  private let titles = ["이름", "은행", "계좌번호"]
  private var userName = UserDefaults.standard.string(forKey: "name") ?? "사용자"
  
  private let disposeBag = DisposeBag()
  
  private var selectedBankCode: String?
  private lazy var nameSubject = BehaviorSubject<String>(value: userName)
  private let bankSubject = BehaviorSubject<String>(value: "")
  private let accountNumberSubject = BehaviorSubject<String>(value: "")
  
  // MARK: UI
  private let navigationView = CustomNavigationBarView(navigationBarType: .normal)
  private let headerView = MyPageSectionHeaderView().then {
    $0.setTitleLabel(title: "계좌 등록")
  }
  private let tableView = UITableView(frame: .zero, style: .plain).then {
    $0.rowHeight = 75
    $0.register(AccountAddCell.self, forCellReuseIdentifier: AccountAddCell.className)
    $0.separatorStyle = .none
    $0.isScrollEnabled = false
  }
  private let conformButton = DdanziButton(title: "입력 완료", enable: false)
  
  // MARK: LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    userName = maskMiddleCharacters(of: userName) // 이름 중간 글자 마스킹 처리
    setUI()
    bind()
    setupDismissKeyboardGesture()
  }
  
  private func setUI() {
    self.view.backgroundColor = .white
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    view.addSubviews(navigationView, headerView, tableView, conformButton)
  }
  
  private func setConstraints() {
    navigationView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }
    
    headerView.snp.makeConstraints {
      $0.top.equalTo(navigationView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(48)
    }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(headerView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    conformButton.snp.makeConstraints {
      $0.height.equalTo(52.adjusted)
      $0.leading.trailing.equalToSuperview().inset(20.adjusted)
      $0.bottom.equalToSuperview().inset(58.adjusted)
    }
  }
  
  private func bind() {
    tableView.delegate = self
    tableView.dataSource = self
    // 모든 필드가 채워졌을 때 버튼 활성화
    Observable.combineLatest(nameSubject, bankSubject, accountNumberSubject)
      .map { !$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty }
      .bind(with: self, onNext: { owner, isEnable in
        if isEnable { owner.conformButton.setEnable() }
      })
      .disposed(by: disposeBag)
    
    conformButton.rx.tap
      .subscribe(with: self) { owner, _ in
        // 등록 버튼 눌렀을 때의 처리
        let accountName = try? owner.nameSubject.value()
        let bank = try? owner.bankSubject.value()
        let accountNumber = try? owner.accountNumberSubject.value()
        
        owner.conformAccount(accountName: accountName ?? "", bank: bank ?? "", accountNumber: accountNumber ?? "")
      }
      .disposed(by: disposeBag)
  }
  
  
  func showBankSelection() {
    let alert = UIAlertController(title: "은행 선택", message: nil, preferredStyle: .actionSheet)
    
    for bank in BankList.banks {
      let action = UIAlertAction(title: bank.name, style: .default) { _ in
        // 은행 선택 시 코드 저장
        self.selectedBankCode = bank.code
        self.bankSubject.onNext(bank.name)
      }
      alert.addAction(action)
    }
    
    let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    alert.addAction(cancel)
    
    present(alert, animated: true, completion: nil)
  }
  
  private func maskMiddleCharacters(of name: String) -> String {
    guard name.count >= 2 else { return name }
    let middleIndex = name.index(name.startIndex, offsetBy: name.count / 2)
    return name.replacingCharacters(in: middleIndex...middleIndex, with: "*")
  }
  
  private func conformAccount(accountName: String, bank: String, accountNumber: String) {
    let body = UserAccountRequestDTO(acountName: accountName, bank: bank, accountNumber: accountNumber)
    Providers.MypageProvider.request(target: .addUserAccount(body), instance: BaseResponse<UserAccountDTO>.self) { response in
      guard let data = response.data else { return }
      if response.status != 200 || response.status != 201 {
        self.view.showToast(message: "계좌 등록 오류 입니다. 잠시 후 다시 시도해주세요", at: 100)
      } else {
        self.navigationController?.popViewController(animated: true)
      }
    }
  }
  
  private func setupDismissKeyboardGesture() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    tapGesture.cancelsTouchesInView = false // 터치 이벤트가 다른 뷰로 전파되도록 설정
    view.addGestureRecognizer(tapGesture)
  }
  
  @objc private func dismissKeyboard() {
    view.endEditing(true)
  }
}

extension AccountAddViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: AccountAddCell.className, for: indexPath) as! AccountAddCell
    switch indexPath.row {
    case 0:
      cell.configureCell(title: self.titles[0], placeHolder: self.userName, isEditable: false)
      cell.textField.text = self.userName
    case 1:
      cell.configureCell(title: self.titles[1], placeHolder: "은행을 선택해주세요", isEditable: false)
      self.bankSubject
        .bind(to: cell.textField.rx.text)
        .disposed(by: cell.disposeBag)
    case 2:
      cell.configureCell(title: self.titles[2], placeHolder: "-를 제외한 계좌번호를 작성해주세요", isEditable: true)
      // 계좌번호 입력 값을 accountNumberSubject에 바인딩
      cell.textField.rx.text.orEmpty
        .bind(to: self.accountNumberSubject)
        .disposed(by: cell.disposeBag)
      
      cell.textField.delegate = self
    default:
      break
    }
    return cell
  }
}

extension AccountAddViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 1 {
      self.showBankSelection()
    } else if indexPath.row == 2 {
        let cell = tableView.cellForRow(at: indexPath) as? AccountAddCell
        cell?.textField.becomeFirstResponder() // 포커스 설정
    }
  }
}

extension AccountAddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
