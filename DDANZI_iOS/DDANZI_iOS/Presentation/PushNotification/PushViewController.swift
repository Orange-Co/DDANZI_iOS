//
//  PushViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/13/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class PushViewController: UIViewController {
  private let disposeBag = DisposeBag()
  
  private var pushList = BehaviorRelay<[PushNotification]>(value: [])
  
  private let navigationbar = CustomNavigationBarView(navigationBarType: .normal, title: "알림")
  private let tableView = UITableView().then {
    $0.rowHeight = 80
    $0.register(PushTableViewCell.self, forCellReuseIdentifier: PushTableViewCell.className)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = true
  }
  
  override func viewDidLoad() {
    fetchPushList()
    super.viewDidLoad()
    setUI()
    bind()
  }
  
  private func setUI() {
    view.backgroundColor = .white
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    view.addSubviews(navigationbar, tableView)
  }
  
  private func setConstraints() {
    navigationbar.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(navigationbar.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func bind() {
    tableView.dataSource = self
    tableView.delegate = self
    
    navigationbar.backButtonTap
      .subscribe(with: self) { owner, _ in
        self.navigationController?.popViewController(animated: true)
      }
      .disposed(by: disposeBag)
  }
  
  private func fetchPushList() {
    Providers.NotificationProvider.request(target: .listPushNotification, instance: BaseResponse<PushNotificationListDTO>.self) { response in
      guard let data = response.data else { return }
      self.pushList.accept(data.alarmList)
      self.tableView.reloadData()
    }
  }
}

extension PushViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    pushList.value.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: PushTableViewCell.className, for: indexPath) as? PushTableViewCell else { return UITableViewCell(style: .subtitle, reuseIdentifier: "") }
    cell.configure(
      title: pushList.value[indexPath.row].title,
      contents: pushList.value[indexPath.row].content,
      time: pushList.value[indexPath.row].time,
      isRead: pushList.value[indexPath.row].isChecked
    )
    return cell
  }
}

extension PushViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let notification = pushList.value[indexPath.row]
    
    switch notification.alarmCase {
    case "A1":
      if let itemId = notification.itemId {
        let detailVC = SalesDetailViewController(productId: itemId)
        self.navigationController?.pushViewController(detailVC, animated: true)
      }
      // 입금 시 배송지 옵션 입력으로
      break
    case "A4":
      let callVC = CsCenterViewController()
      self.navigationController?.pushViewController(callVC, animated: true)
    case "B1", "B5":
      self.navigationController?.popViewController(animated: true)
    case "B2", "B3", "B4":
      if let orderId = notification.orderId {
        let detailVC = PurchaseDetailViewController(orderId: orderId)
        self.navigationController?.pushViewController(detailVC, animated: true)
      }
    default:
      break
    }
  }
}
