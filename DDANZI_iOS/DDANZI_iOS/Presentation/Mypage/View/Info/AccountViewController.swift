//
//  AccountViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/15/24.
//

import UIKit

import SnapKit
import Then
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
}


extension AccountViewController: UITableViewDelegate {

}

