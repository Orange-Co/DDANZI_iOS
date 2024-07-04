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
    let viewModel = MyPageViewModel()
    
    private let navigationBar = CustomNavigationBarView(navigationBarType: .setting)
    private lazy var headerView = viewModel.isLogin ? MyPageHeaderView() : LoginHeaderView()
    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
        $0.rowHeight = 52
        $0.register(MyPageTableViewCell.self,
                    forCellReuseIdentifier: MyPageTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
        configureTableView()
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
            $0.top.equalTo(view.safeAreaInsets.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(148)
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
    }
}

extension MyPageViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let header = MyPageSectionHeaderView()
            header.setTitleLabel(title: "히스토리")
            return header
        case 1:
            let header = MyPageSectionHeaderView()
            header.setTitleLabel(title: "고객 센터")
            return header
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        switch section {
        case 0:
            switch indexPath.item {
            case 0:
                navigationController?.pushViewController(BuyListViewController(), animated: true)
            case 1:
                navigationController?.pushViewController(SellListViewController(), animated: true)
            case 2:
                navigationController?.pushViewController(FavoriteViewController(), animated: true)
            default:
                break
            }
        case 1:
            switch indexPath.item {
            case 0:
                navigationController?.pushViewController(QuestionViewController(), animated: true)
            case 1:
                navigationController?.pushViewController(CsCenterViewController(), animated: true)
            default:
                break
            }
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.identifier, for: indexPath) as? MyPageTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        switch indexPath.section {
        case 0:
            let historyTitles = ["구매 내역", "판매 내역", "내 관심"]
            cell.setTitleLabel(title: historyTitles[indexPath.item])
        case 1:
            let customerTitles = ["자주 묻는 질문", "1:1 상담 센터 "]
            cell.setTitleLabel(title: customerTitles[indexPath.item])
        default:
            return UITableViewCell()
        }
        return cell
    }
}

extension MyPageViewController: UITableViewDelegate { }
