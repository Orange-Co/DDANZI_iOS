//
//  OptionSelectViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/19/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources

typealias StrOption = StringLiterals.ProductDetail.Option

final class OptionSelectViewController: UIViewController {
    // MARK: Properties
    private let disposeBag = DisposeBag()
    private let optionViewModel = OptionSelectViewModel()
    
    // MARK: Compenets
    private let titleLabel = UILabel().then {
        $0.text = StrOption.optionTitle
        $0.textColor = .black
        $0.font = .title4Sb24
    }
    
    private let moreButton = UIButton().then {
        $0.setTitle(StrOption.moreButtonText, for: .normal)
        $0.titleLabel?.font = .buttonText
        $0.setTitleColor(.gray3, for: .normal)
    }
    
    private let optionCaptionLabel = UILabel().then {
        $0.text = StrOption.optionCaptionText
        $0.font = .body6M12
        $0.textColor = .gray2
    }
    
    private let tableView = UITableView()
    
    
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        configureTableView()
    }
    
    // MARK: LayoutHelper
    private func setUI() {
        self.view.backgroundColor = .white
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        view.addSubviews(titleLabel,
                         moreButton,
                         optionCaptionLabel,
                         tableView)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
        }
        
        moreButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(moreButton.snp.bottom).offset(15)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
               tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Header")
               
        // RxDataSources 설정
        let dataSource = RxTableViewSectionedReloadDataSource<OptionSectionModel>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                cell.textLabel?.text = item
                return cell
            },
            titleForHeaderInSection: { dataSource, index in
                return "Section \(index)"
            }
        )
        
        optionViewModel.sections
            .map { sections in
                sections.map { section in
                    OptionSectionModel(isExpanded: section.isExpanded, items: section.items)
                }
            }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
}

extension OptionSelectViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header")
        header?.textLabel?.text = "Section \(section)"
        let button = UIButton(type: .system)
        button.setTitle("Toggle", for: .normal)
        button.frame = CGRect(x: tableView.frame.width - 100, y: 0, width: 100, height: 44)
        button.tag = section
        button.addTarget(self, action: #selector(toggleSection(sender:)), for: .touchUpInside)
        header?.contentView.addSubview(button)
        return header
    }
    
    @objc func toggleSection(sender: UIButton) {
        optionViewModel.toggleSection(at: sender.tag)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isExpanded = optionViewModel.sections.value[section].isExpanded
        return isExpanded ? optionViewModel.sections.value[section].items.count : 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return optionViewModel.sections.value.count
    }
    
    private func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = optionViewModel.sections.value[indexPath.section].items[indexPath.row]
        return cell
    }
}
