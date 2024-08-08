//
//  AddAddressViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/9/24.
//

import UIKit
import WebKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class AddressFormViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  private let titles: [String] = ["우편번호", "주소지", "상세주소", "아룸", "휴대폰 번호"]
  private let userInfo = UserInfoModel(name: "이단지", phone: "010-1234-8314", nickName: "")
  private var zoneCode: String?
  private var roadAddress: String?
  private lazy var addressDetails: [String?] = [zoneCode, roadAddress, nil, userInfo.name, userInfo.phone]
  
  
  private let navigationBar = CustomNavigationBarView(navigationBarType: .normal)
  private let addressFormTableView = UITableView(frame: .zero, style: .plain).then {
    $0.backgroundColor = .white
    $0.register(AddressFormTableViewCell.self, forCellReuseIdentifier: AddressFormTableViewCell.className)
    $0.rowHeight = 75
    $0.separatorStyle = .none
    $0.scrollsToTop = false
    $0.contentInset = .init(top: 30, left: 0, bottom: 0, right: 0)
  }
  private let headerView = MyPageSectionHeaderView().then {
    $0.setTitleLabel(title: "배송지 등록")
  }
  private let nexButton = DdanziButton(title: "입력 완료", enable: false)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
    setDelegate()
    bind()
    setupDismissKeyboardGesture()
  }
  
  private func setUI() {
    self.view.backgroundColor = .white
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    view.addSubviews(
      navigationBar,
      headerView,
      addressFormTableView,
      nexButton
    )
  }
  
  private func setConstraints() {
    navigationBar.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
    }
    
    headerView.snp.makeConstraints {
      $0.top.equalTo(navigationBar.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(48)
    }
    
    addressFormTableView.snp.makeConstraints {
      $0.top.equalTo(headerView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    nexButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(10)
      $0.bottom.equalToSuperview().inset(38)
      $0.height.equalTo(50)
    }
  }
  
  private func bind() {
    navigationBar.backButtonTap
      .subscribe(onNext: { [weak self] in
        self?.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
    
    nexButton.rx.tap
      .subscribe(with: self, onNext: { owner, event  in
        print("다음 버튼 눌림")
        print(owner.addressDetails)
        self.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
  }
  
  private func setDelegate() {
    addressFormTableView.dataSource = self
    addressFormTableView.delegate = self
  }
}

extension AddressFormViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: AddressFormTableViewCell.className, for: indexPath) as? AddressFormTableViewCell else {
      return UITableViewCell()
    }
    switch indexPath.row {
    case 0:
      cell.configureCell(
        title: titles[indexPath.row],
        placeholder: "",
        initalText: zoneCode ?? "",
        isButtonCell: true)
    case 1:
      cell.configureCell(
        title: titles[indexPath.row],
        placeholder: "주소지를 입력해주세요",
        initalText: roadAddress ?? "",
        isButtonCell: false)
    case 2:
      cell.configureCell(
        title: titles[indexPath.row],
        placeholder: "상세주소를 입력해주세요",
        initalText: addressDetails[2] ?? "",
        isButtonCell: false,
        isEnableInput: true)
    case 3:
      cell.configureCell(
        title: titles[indexPath.row],
        placeholder: "",
        initalText: userInfo.name,
        isButtonCell: false)
    case 4:
      cell.configureCell(
        title: titles[indexPath.row],
        placeholder: "",
        initalText: userInfo.phone,
        isButtonCell: false)
    default:
      break
    }
    
    cell.textChanged = { [weak self] text in
      self?.addressDetails[indexPath.row] = text
      self?.checkIsVaild()
    }
      
    
    return cell
  }
  
  private func checkIsVaild() {
    let allFieldsFilled = addressDetails.allSatisfy {
      guard let info = $0 else { return false }
      return !info.isEmpty
    }
    if allFieldsFilled {
      nexButton.backgroundColor = .black
      nexButton.isEnabled = true
    }
  }
}

extension AddressFormViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    switch indexPath.row {
    case 0, 1:
      let postCodeVC = KakaoPostCodeViewController()
      postCodeVC.dataSubject
        .subscribe(with: self,onNext: { owner, data in
          if let zonecode = data["zonecode"] as? String, let roadAddress = data["roadAddress"] as? String {
            owner.zoneCode = zonecode
            owner.roadAddress = roadAddress
            owner.addressDetails[0] = zonecode
            owner.addressDetails[1] = roadAddress
            
            // 테이블 뷰 업데이트
            owner.addressFormTableView.reloadData()
          }
        })
        .disposed(by: disposeBag)
      self.present(postCodeVC, animated: true)
    default:
      break
    }
  }
}
