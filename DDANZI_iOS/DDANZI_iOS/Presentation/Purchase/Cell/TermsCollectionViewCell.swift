//
//  TermsCollectionViewCell.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/16/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class TermsCollectionViewCell: UICollectionViewCell {
  
  private let terms: [String] = ["서비스 이용 약관", "딴지 구매 가이드"]
  var selectedTerms = BehaviorRelay<[Bool]>(value: [false, false])
  let disposeBag = DisposeBag()
  
  //MARK: - UI
  
  private let fullAgreementButton = UIButton().then {
    $0.setImage(.icBlackCheck.withTintColor(.gray2), for: .normal)
    $0.setImage(.icBlackCheck, for: .selected)
    
    $0.setTitle("아래 약관에 전체동의해요", for: .normal)
    $0.setTitleColor(.gray2, for: .normal)
    $0.setTitleColor(.black, for: .selected)
    
    $0.titleLabel?.font = .body1B20
  }
  
  private let termsTableView = UITableView(frame: .zero, style: .plain).then {
    $0.separatorStyle = .none
    $0.register(TermsTableViewCell.self, forCellReuseIdentifier: TermsTableViewCell.className)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
    configureTableView()
    bindTableView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUI() {
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    self.addSubviews(fullAgreementButton,
                     termsTableView)
  }
  
  private func setConstraints() {
    fullAgreementButton.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview()
    }
    
    termsTableView.snp.makeConstraints {
      $0.top.equalTo(fullAgreementButton.snp.bottom).offset(14)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func configureTableView() {
    termsTableView.dataSource = self
    termsTableView.delegate = self
  }
  
  private func bindTableView() {
    fullAgreementButton.rx.tap
      .withLatestFrom(selectedTerms)
      .subscribe(onNext: { [weak self] termsSelected in
        let allSelected = termsSelected.allSatisfy { $0 }
        self?.toggleSelectAllTerms(!allSelected)
      })
      .disposed(by: disposeBag)
    
    selectedTerms
      .subscribe(onNext: { [weak self] _ in
        self?.termsTableView.reloadData()
      })
      .disposed(by: disposeBag)
  }
  
  private func toggleSelectAllTerms(_ select: Bool) {
    let newSelections = Array(repeating: select, count: terms.count)
    fullAgreementButton.isSelected.toggle()
    selectedTerms.accept(newSelections)
  }
}

extension TermsCollectionViewCell: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return terms.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TermsTableViewCell.className,
                                                   for: indexPath) as? TermsTableViewCell else {
      return UITableViewCell()
    }
    cell.selectionStyle = .none
    cell.bindTitle(
      title: terms[indexPath.row],
      isSelected: selectedTerms.value[indexPath.row]
    )
    return cell
  }
}

extension TermsCollectionViewCell: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    var updatedSelections = selectedTerms.value
    print("여기 눌렀어 \(updatedSelections)")
    updatedSelections[indexPath.row].toggle()
    selectedTerms.accept(updatedSelections)
  }
}
