//
//  PushSettingViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/16/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class PushSettingViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private let cancelButton = UIButton().then {
    $0.setImage(.icCancel, for: .normal)
  }
  private let iconImageView = UIImageView().then {
    $0.image = .pushSetting
  }
  private let innerStackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .center
    $0.spacing = 12
  }
  private let titleLabel = UILabel().then {
    $0.font = .title3Sb28
    $0.textColor = .black
    $0.numberOfLines = 2
    $0.textAlignment = .center
    $0.text = "푸시 알림이\n설정되어 있지 않아요!"
  }
  private let subTitleLabel = UILabel().then {
    $0.font = .body4R16
    $0.textColor = .black
    $0.numberOfLines = 2
    $0.textAlignment = .center
    $0.text = "원만한 거래를 위해서는\n푸시알림 설정이 필요해요"
  }
  private let conformButton = DdanziButton(title: "알림 받기")
  private let laterButton = UIButton().then {
    $0.setTitle("나중에 받을게요", for: .normal)
    $0.titleLabel?.font = .buttonText
    $0.setTitleColor(.gray2, for: .normal)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
    setUI()
  }
  
  private func setUI() {
    view.backgroundColor = .white
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    view.addSubviews(cancelButton,
                     innerStackView,
                     conformButton,
                     laterButton)
    innerStackView.addArrangedSubviews(iconImageView,
                                       titleLabel,
                                       subTitleLabel)
  }
  
  private func setConstraints() {
    cancelButton.snp.makeConstraints {
      $0.top.trailing.equalToSuperview().inset(20)
    }
    
    innerStackView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(113)
      $0.centerX.equalToSuperview()
    }
    
    laterButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(28)
    }
    
    conformButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(50)
      $0.bottom.equalTo(laterButton.snp.top).offset(-12)
    }
    
  }
  
  private func bind() {
    conformButton.rx.tap.bind {
      self.navigationController?.pushViewController(PurchaseCompleteViewController(), animated: true)
    }
    .disposed(by: disposeBag)
  }
  
}
