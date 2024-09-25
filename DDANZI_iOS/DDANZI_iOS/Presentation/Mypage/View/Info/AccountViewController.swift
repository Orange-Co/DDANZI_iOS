//
//  AccountViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/15/24.
//

import UIKit

import SnapKit
import Then
import KakaoSDKUser
import RxSwift
import RxCocoa
import RxDataSources

class AccountViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private let accountSetTitle = ["로그아웃", "회원 탈퇴"]
  
  private let navigationBarView = CustomNavigationBarView(navigationBarType: .normal)
  private let tableView = UITableView().then {
    $0.backgroundColor = .white
    $0.rowHeight = 49
    $0.isScrollEnabled = false
    $0.separatorStyle = .none
    $0.register(MyPageTableViewCell.self, forCellReuseIdentifier: MyPageTableViewCell.identifier)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
    configureTableView()
    bind()
  }
  
  private func setUI() {
    view.backgroundColor = .white
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    view.addSubviews(navigationBarView,
                     tableView)
  }
  
  private func setConstraints() {
    navigationBarView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
    }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(navigationBarView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func configureTableView() {
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  private func bind() {
    navigationBarView.backButtonTap
      .subscribe(onNext: { [weak self] in
        self?.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
  }
}

extension AccountViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.identifier) as? MyPageTableViewCell
    guard let cell else { return UITableViewCell() }
    cell.setTitleLabel(title: accountSetTitle[indexPath.item])
    cell.selectionStyle = .none
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = MyPageSectionHeaderView()
    header.setTitleLabel(title: "계정 관리")
    return header
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 0 {
      let alertVC = CustomAlertViewController(title: "로그아웃", content: "정말 로그아웃 하시나요?", buttonText: "계속 이용하기", subButton: "로그아웃")
      alertVC.subButtonTap
        .subscribe(onNext: { _ in
          Providers.AuthProvider.request(target: .logout, instance: BaseResponse<Bool>.self) { response in
            UserApi.shared.logout {(error) in
              if let error = error {
                print(error)
                KeychainWrapper.shared.deleteAccessToken()
                UserDefaults.standard.set(false, forKey: .isLogin)
                self.navigationController?.popToRootViewController(animated: true)
              }
              else {
                UserDefaults.standard.clearAll()
                KeychainWrapper.shared.deleteAccessToken()
                UserDefaults.standard.set(false, forKey: .isLogin)
                self.navigationController?.popToRootViewController(animated: true)
                print("logout() success.")
              }
            }
          }
        })
        .disposed(by: disposeBag)
      alertVC.modalPresentationStyle = .overFullScreen
      self.present(alertVC, animated: false, completion: nil)
    } else if indexPath.row == 1 {
      let alertVC = CustomAlertViewController(title: "회원 탈퇴", content: "회원 탈퇴 시,\n계정은 삭제되며 복구되지 않습니다.", buttonText: "계속 이용하기", subButton: "탈퇴하기")
      alertVC.subButtonTap
        .subscribe(onNext: { _ in
          Providers.AuthProvider.request(target: .revoke, instance: BaseResponse<WithDrawDTO>.self) { response in
            UserApi.shared.unlink {(error) in
              if let error = error {
                print(error)
                UserDefaults.standard.set(false, forKey: .isLogin)
                self.navigationController?.popToRootViewController(animated: true)
              }
              else {
                UserDefaults.standard.clearAll()
                KeychainWrapper.shared.deleteAccessToken()
                UserDefaults.standard.set(false, forKey: .isLogin)
                self.navigationController?.popToRootViewController(animated: true)
              }
            }
          }
        })
        .disposed(by: disposeBag)
      
      alertVC.modalPresentationStyle = .overFullScreen
      self.present(alertVC, animated: false, completion: nil)
      // 탈퇴 로직 처리
    }
  }
}


extension AccountViewController: UITableViewDelegate {
  
}

