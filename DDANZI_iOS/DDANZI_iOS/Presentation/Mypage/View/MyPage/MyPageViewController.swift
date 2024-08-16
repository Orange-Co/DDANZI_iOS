//
//  MyPageViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/16/24.
//

import UIKit

import RxSwift
import Then
import SnapKit

final class MyPageViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private var isLogin: Bool {
    get { UserDefaults.standard.bool(forKey: .isLogin) }
    set {
      UserDefaults.standard.set(newValue, forKey: .isLogin)
      updateUI()
    }
  }
  
  private lazy var navigationBar = createNavigationBar()
  private lazy var headerView = createHeaderView()
  private let tableView = UITableView(frame: .zero, style: .grouped).then {
    $0.separatorStyle = .none
    $0.rowHeight = 52.adjusted
    $0.sectionHeaderHeight = 48
    $0.register(MyPageTableViewCell.self,
                forCellReuseIdentifier: MyPageTableViewCell.identifier)
    $0.backgroundColor = .white
    $0.isScrollEnabled = false
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = false
    self.navigationController?.navigationBar.isHidden = true
    
    fetchUser()
    isLogin = UserDefaults.standard.bool(forKey: .isLogin)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
    bind()
    configureTableView()
  }
  
  private func createNavigationBar() -> CustomNavigationBarView {
    return isLogin ? CustomNavigationBarView(navigationBarType: .setting) : CustomNavigationBarView(navigationBarType: .none)
  }
  
  private func createHeaderView() -> UIView {
    return isLogin ? MyPageHeaderView() : LoginHeaderView()
  }
  
  private func setUI() {
    view.backgroundColor = .white
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    view.addSubviews(navigationBar,
                     headerView,
                     tableView)
  }
  
  private func setConstraints() {
    navigationBar.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }
    
    headerView.snp.makeConstraints {
      $0.top.equalTo(navigationBar.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(148.adjusted)
    }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(headerView.snp.bottom).offset(15)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func configureTableView() {
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  private func bind() {
    navigationBar.settingButtonTap
      .subscribe(onNext: { [weak self] in
        self?.navigationController?.pushViewController(InfoSettingViewController(), animated: true)
      })
      .disposed(by: disposeBag)
    
    if let headerView = headerView as? LoginHeaderView {
      headerView.loginButtonTapped
        .subscribe(with: self) { owner, _ in
          owner.navigationController?.pushViewController(LoginViewController(), animated: true)
        }
        .disposed(by: disposeBag)
    }
  }
  
  private func fetchUser() {
    Providers.MypageProvider.request(target: .fetchUser, instance: BaseResponse<MypageResponseDTO>.self) { result in
      if result.status == 403 {
        self.isLogin = false
        self.tableView.reloadData()
      }
      guard let data = result.data else { return }
      if data.nickname != "" {
        self.isLogin = true
        if let headerView = self.headerView as? MyPageHeaderView {
          headerView.setNickname(nickname: data.nickname)
        }
      }
    }
  }
  
  private func updateUI() {
    // Update navigation bar and header view
    navigationBar.removeFromSuperview()
    headerView.removeFromSuperview()
    navigationBar = createNavigationBar()
    headerView = createHeaderView()
    setHierarchy()
    setConstraints()
    
    // Rebind header view actions
    bind()
    
    // Reload table view
    tableView.reloadData()
  }
}

extension MyPageViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return isLogin ? 2 : 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return isLogin ? 3 : 2
    case 1:
      return 2
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = MyPageSectionHeaderView()
    let title = (section == 0) ? (isLogin ? "히스토리" : "고객센터") : "고객 센터"
    header.setTitleLabel(title: title)
    return header
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let section = indexPath.section
    if section == 0 {
      if isLogin {
        switch indexPath.row {
        case 0: navigationController?.pushViewController(PurchaseListViewController(), animated: true)
        case 1: navigationController?.pushViewController(SellListViewController(), animated: true)
        case 2: navigationController?.pushViewController(FavoriteViewController(), animated: true)
        default: break
        }
      } else {
        switch indexPath.row {
        case 0: break // 외부 페이지 연결
        case 1: navigationController?.pushViewController(CsCenterViewController(), animated: true)
        default: break
        }
      }
    } else if section == 1 {
      switch indexPath.row {
      case 0: break // 외부 페이지 연결
      case 1: navigationController?.pushViewController(CsCenterViewController(), animated: true)
      default: break
      }
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.identifier, for: indexPath) as? MyPageTableViewCell else {
      return UITableViewCell()
    }
    cell.selectionStyle = .none
    
    let historyTitles = ["구매 내역", "판매 내역", "내 관심"]
    let customerTitles = ["자주 묻는 질문", "1:1 상담 센터"]
    let titles = (indexPath.section == 0) ? (isLogin ? historyTitles : customerTitles) : customerTitles
    cell.setTitleLabel(title: titles[indexPath.row])
    
    return cell
  }
}

extension MyPageViewController: UITableViewDelegate { }
