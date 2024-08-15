//
//  InfoSettingViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/28/24.
//

import UIKit

import RxSwift
import Then
import SnapKit

final class InfoSettingViewController: UIViewController {
  private let titles = ["내 정보", "내 정보 관리"]
  private let infoTitles = ["배송지 관리", "계좌 관리", "계정 관리"]
  private let myInfoTitles = ["이름", "휴대폰 번호", "닉네임"]
  private let userInfo = UserInfoModel(name: "ㅇㅇㅇ", phone: "010-1234-2342", nickName: "Ddanzi123")
  private let disposeBag = DisposeBag()
  
  private let navigationBar = CustomNavigationBarView(navigationBarType: .normal, title: "정보 관리")
  
  private let tableView = UITableView(frame: .zero).then {
    $0.rowHeight = 49
    $0.separatorStyle = .none
    $0.register(InfoTableViewCell.self, forCellReuseIdentifier: InfoTableViewCell.identifier)
    $0.register(MyPageTableViewCell.self, forCellReuseIdentifier: MyPageTableViewCell.identifier)
    $0.backgroundColor = .white
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.isHidden = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setUI()
    configureTableView()
    bind()
  }
  
  private func setUI() {
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    view.addSubviews(navigationBar,
                     tableView)
  }
  
  private func setConstraints() {
    navigationBar.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
    }
    
    tableView.snp.makeConstraints() {
      $0.top.equalTo(navigationBar.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func configureTableView() {
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  private func bind() {
    navigationBar.backButtonTap
      .subscribe(onNext: { [weak self] in
        self?.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
  }
}

extension InfoSettingViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifier) as? InfoTableViewCell
      guard let cell else { return UITableViewCell() }
      var infoText = ""
      if indexPath.row == 0 {
        infoText = userInfo.name
      } else if indexPath.row == 1 {
        infoText = userInfo.phone
      } else if indexPath.row == 2 {
        infoText = userInfo.nickName
      }
      cell.bindData(title: myInfoTitles[indexPath.row], info: infoText)
      cell.selectionStyle = .none
      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.identifier) as? MyPageTableViewCell
      guard let cell else { return UITableViewCell() }
      cell.setTitleLabel(title: infoTitles[indexPath.item])
      cell.selectionStyle = .none
      return cell
    default:
      return UITableViewCell()
      
    }
    
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = MyPageSectionHeaderView()
    header.setTitleLabel(title: titles[section])
    return header
  }
}


extension InfoSettingViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 1 {
      switch indexPath.item {
      case 0:
        navigationController?.pushViewController(AddressSettingViewController(), animated: true)
      case 1:
        navigationController?.pushViewController(BankAccountViewController(), animated: true)
      case 2:
        navigationController?.pushViewController(AccountViewController(), animated: true)
      default:
        break
      }
    }
  }
}
