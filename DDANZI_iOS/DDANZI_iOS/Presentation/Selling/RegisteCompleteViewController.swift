//
//  RegisteCompleteViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/9/24.
//

import UIKit

import Then
import SnapKit
import RxSwift
import Amplitude

final class RegisteCompleteViewController: UIViewController {
  
  private var response = RegisteItemDTO(itemId: "", productName: "", imgUrl: "", salePrice: 0)
  private let disposeBag = DisposeBag()
  
  
  private let navigationBar = CustomNavigationBarView(navigationBarType: .cancel, title: "상품 등록 완료")
  
  private let containerView = UIView().then {
    $0.layer.cornerRadius = 20
    $0.layer.borderColor = UIColor.black.cgColor
    $0.layer.borderWidth = 1
    $0.clipsToBounds = true
  }
  
  private let titleLabel = UILabel().then {
    $0.text = "상품 등록이 완료되었습니다."
    $0.textColor = .black
    $0.font = .title4Sb24
    $0.textColor = .black
    $0.textAlignment = .center
  }
  
  private let checkIconImageView = UIImageView().then {
    $0.image = .icBlackCheck
  }
  
  private let guideLabel = UILabel().then {
    $0.text = "주문 확인 후 거래가 진행됩니다.\n거래가 성사되면 판매를 확정해주세요."
    $0.textAlignment = .center
    $0.textColor = .gray3
    $0.font = .body5R14
    $0.numberOfLines = 2
    $0.textAlignment = .center
  }
  
  private let productImageView = UIImageView()
  
  private let productTitleLabel = UILabel().then {
    $0.font = .body4R16
    $0.textColor = .black
    $0.textAlignment = .center
  }
  
  private let priceLabel = UILabel().then {
    $0.font = .body1B20
    $0.textColor = .black
    $0.textAlignment = .center
  }
  
  private let moreButton = UIButton().then {
    $0.setTitle("상품 추가 등록하기", for: .normal)
    $0.titleLabel?.font = .body3Sb16
    $0.setTitleColor(.black, for: .normal)
    $0.layer.cornerRadius = 10
    $0.layer.borderColor = UIColor.black.cgColor
    $0.layer.borderWidth = 1
  }
  private let conformedButton = DdanziButton(title: "상품 등록 확인")
  
  init(response: RegisteItemDTO) {
    self.response = response
    self.productImageView.setImage(with: response.imgUrl)
    self.productTitleLabel.text = response.productName
    self.priceLabel.text = response.salePrice.toKoreanWon()
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
    bind()
  }
  
  private func setUI() {
    self.view.backgroundColor = .white
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    view.addSubviews(navigationBar, containerView, moreButton, conformedButton)
    containerView.addSubviews(checkIconImageView, titleLabel, guideLabel, productImageView, productTitleLabel, priceLabel)
  }
  
  private func setConstraints() {
    navigationBar.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
        $0.leading.trailing.equalToSuperview()
    }
    
    containerView.snp.makeConstraints {
      $0.top.equalTo(navigationBar.snp.bottom).offset(30)
      $0.leading.trailing.equalToSuperview().inset(40.adjusted)
      $0.height.equalTo(426.adjusted)
    }
    
    checkIconImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(27)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(checkIconImageView.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview()
    }
    
    guideLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview().inset(20)
    }
    
    productImageView.snp.makeConstraints {
      $0.top.equalTo(guideLabel.snp.bottom).offset(28.adjusted)
      $0.size.equalTo(118.adjusted)
      $0.centerX.equalToSuperview()
    }
    
    productTitleLabel.snp.makeConstraints {
      $0.top.equalTo(productImageView.snp.bottom).offset(23.adjusted)
      $0.leading.trailing.equalToSuperview().inset(20)
    }
    
    priceLabel.snp.makeConstraints {
      $0.top.equalTo(productTitleLabel.snp.bottom).offset(8)
      $0.centerX.equalToSuperview()
    }
    
    conformedButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(52)
      $0.height.equalTo(50)
    }
    
    moreButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalTo(conformedButton.snp.top).offset(-10)
      $0.height.equalTo(50)
    }
  }
  
  private func bind() {
    conformedButton.rx.tap
      .subscribe(with: self) { owner, _ in
        Amplitude.instance().logEvent("click_sell_adjustment_check")
        owner.navigationController?.popToViewController(LandingViewController(), animated: true)
      }
      .disposed(by: disposeBag)
    
    moreButton.rx.tap
      .subscribe(with: self) { owner, _ in
        Amplitude.instance().logEvent("click_sell_adjustment_add")
        owner.navigationController?.popToRootViewController(animated: true)
      }
      .disposed(by: disposeBag)
  }
}
