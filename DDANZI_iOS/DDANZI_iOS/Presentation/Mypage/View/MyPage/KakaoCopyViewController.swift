//
//  KakaoCopyViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/13/24.
//

import UIKit

import Then
import SnapKit
import RxSwift
import RxCocoa

struct deliveryModel {
  let address: String
  let detailAddress : String
  let name : String
  let phone: String
  let option: String?
}

final class KakaoCopyViewController: UIViewController {
  private let disposeBag = DisposeBag()
  
  private var orderId: String = ""
  private let titles: [String] = ["주소", "상세 주소", "이름", "휴대폰 번호", "선택 옵션"]
  private let delivery = BehaviorRelay<deliveryModel >(value: .init(address: "", detailAddress: "", name: "", phone: "", option: ""))
  private var statusType: StatusType = .inProgress
  
  private let tableView = UITableView(frame: .zero, style: .plain).then {
    $0.backgroundColor = .white
    $0.rowHeight = 68
    $0.register(KakaoCopyTableViewCell.self, forCellReuseIdentifier: KakaoCopyTableViewCell.className)
  }
  private let navigationBar = CustomNavigationBarView(navigationBarType: .normal, title: "판매 확정")
  private let titleLabel = UILabel().then {
    $0.text = "카카오톡으로 이동해서\n배송지를 입력해주세요!"
    $0.font = .title4Sb24
    $0.textColor = .black
    $0.numberOfLines = 2
  }
  private let guideButton = UIButton().then {
    $0.setTitle("가이드 보러가기", for: .normal)
    $0.setTitleColor(.gray2, for: .normal)
    $0.titleLabel?.font = .buttonText
    $0.setUnderline()
  }
  private let infoTitleLabel = UILabel().then {
    $0.text = "구매자 정보"
    $0.textColor = .black
    $0.font = .body1B20
  }
  private let completeButton = DdanziButton(title: "입력 완료")
  private let buttonView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
  }
  
  init(orderId: String) {
    self.orderId = orderId
    super.init(nibName: nil, bundle: nil)
    fetchDelivery(id: orderId)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidDisappear(_ animated: Bool) {
      super.viewDidDisappear(animated)
      NotificationCenter.default.post(name: .didCompleteCopyAction, object: nil)
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
    view.addSubviews(navigationBar, titleLabel, guideButton, infoTitleLabel, tableView, buttonView)
    buttonView.addSubview(completeButton)
  }
  
  private func setConstraints() {
    navigationBar.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(navigationBar.snp.bottom).offset(10)
      $0.leading.equalToSuperview().offset(20)
    }
    
    guideButton.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(20)
      $0.leading.equalToSuperview().offset(20)
    }
    
    infoTitleLabel.snp.makeConstraints {
      $0.top.equalTo(guideButton.snp.bottom).offset(20)
      $0.leading.equalToSuperview().offset(20)
    }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(infoTitleLabel.snp.bottom).offset(10)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    buttonView.snp.makeConstraints {
      $0.bottom.leading.trailing.equalToSuperview()
      $0.height.equalTo(92)
    }
    
    completeButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(15)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(50)
    }
  }
  
  private func configureTableView() {
    tableView.dataSource = self
  }
  
  private func bind() {
    navigationBar.backButtonTap
      .subscribe(with: self) { owner, _ in
        owner.navigationController?.popViewController(animated: true)
      }
      .disposed(by: disposeBag)
    
    delivery.bind(with: self) { owner, delivery in
      owner.tableView.reloadData()
    }
    .disposed(by: disposeBag)
    
    completeButton.rx.tap
      .subscribe(with: self) { owner, _ in
        owner.conformedSale(id: self.orderId)
      }
      .disposed(by: disposeBag)
  }
  
  private func fetchDelivery(id: String) {
    Providers.ItemProvider.request(target: .optionItem(id: id), instance: BaseResponse<OptionCheckDTO>.self) { response in
      guard let data = response.data else { return }
      let optionsString = data.selectedOptionList.map { "\($0.option): \($0.selectedOption)" }.joined(separator: ", ")
      self.delivery.accept(.init(address: data.address, detailAddress: data.detailAddress, name: data.recipient, phone: data.recipientPhone, option: optionsString))
    }
  }
  
  private func conformedSale(id: String) {
    Providers.OrderProvider.request(target: .conformedOrderSale(id), instance: BaseResponse<ConformedDTO>.self) { response in
      guard let data = response.data else { return }
      self.statusType = .init(rawValue: data.orderStatus) ?? .inProgress
      self.navigationController?.popViewController(animated: true)
    }
  }
}

extension KakaoCopyViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return titles.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: KakaoCopyTableViewCell.className, for: indexPath) as? KakaoCopyTableViewCell else { return UITableViewCell(style: .subtitle, reuseIdentifier: "") }
    switch indexPath.row {
    case 0:
      cell.configure(title: titles[indexPath.row], content: self.delivery.value.address, isCopy: true)
    case 1:
      cell.configure(title: titles[indexPath.row], content: self.delivery.value.detailAddress, isCopy: true)
    case 2:
      cell.configure(title: titles[indexPath.row], content: self.delivery.value.name, isCopy: true)
    case 3:
      cell.configure(title: titles[indexPath.row], content: self.delivery.value.phone, isCopy: true)
    case 4:
      cell.configure(title: titles[indexPath.row], content: self.delivery.value.option ?? "-", isCopy: false)
    default:
      break
    }
    return cell
  }
  
  
}
