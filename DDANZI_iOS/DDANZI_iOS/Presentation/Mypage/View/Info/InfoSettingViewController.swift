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
            $0.top.leading.trailing.equalToSuperview()
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
            cell.bindData(title: "이름", info: "이지희")
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.identifier) as? MyPageTableViewCell
            guard let cell else { return UITableViewCell() }
            cell.setTitleLabel(title: "배송지 관리")
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


extension InfoSettingViewController: UITableViewDelegate { }

