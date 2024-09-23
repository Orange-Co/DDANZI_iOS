//
//  CustomAlertView.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/22/24.
//

import UIKit

import Then
import SnapKit
import RxSwift

final class CustomAlertViewController: UIViewController {
  
  var primaryButtonTap = PublishSubject<Void>()
  var subButtonTap = PublishSubject<Void>()
  private let disposeBag = DisposeBag()
  
  private let dimView = UIView().then {
    $0.backgroundColor = .black.withAlphaComponent(0.3)
  }
  
  private let alertView = UIView().then {
    $0.backgroundColor = .white
    $0.makeCornerRound(radius: 10)
  }
  
  private let innerStackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .center
    $0.spacing = 20.adjusted
  }
  
  private let titleLabel = UILabel().then {
    $0.font = .title4Sb24
    $0.textAlignment = .center
    $0.textColor = .black
  }
  
  private let contentLabel = UILabel().then {
    $0.font = .body4R16
    $0.textAlignment = .center
    $0.numberOfLines = 3
    $0.textColor = .black
  }
  
  private let conformButton = UIButton().then {
    $0.titleLabel?.font = .body3Sb16
    $0.backgroundColor = .black
    $0.setTitleColor(.white, for: .normal)
    $0.makeCornerRound(radius: 10)
  }
  
  private let subButton = UIButton().then {
    $0.setUnderline()
    $0.titleLabel?.font = .buttonText
    $0.setTitleColor(.gray3, for: .normal)
    $0.isHidden = true
  }
  
  init(title: String, content: String, buttonText: String, subButton: String?){
    self.titleLabel.text = title
    self.contentLabel.text = content
    self.conformButton.setTitle(buttonText, for: .normal)
    if let subButton {
      self.subButton.setTitle(subButton, for: .normal)
      self.subButton.isHidden = false
    }
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
    bindActions()
  }
  
  private func setUI() {
    self.modalPresentationStyle = .overFullScreen
    setHierarchy()
    setConstraints()
    // Add tap gesture recognizer to dimView
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissAlert))
    dimView.addGestureRecognizer(tapGesture)
  }
  
  @objc private func dismissAlert() {
    dismiss(animated: false, completion: nil)
  }
  
  private func setHierarchy() {
    view.addSubview(dimView)
    dimView.addSubview(alertView)
    alertView.addSubviews(innerStackView)
    innerStackView.addArrangedSubviews(titleLabel, contentLabel, conformButton, subButton)
  }
  
  private func setConstraints() {
    dimView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    alertView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(24)
      $0.height.equalTo(240.adjusted)
    }
    
    innerStackView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(15)
    }
    
    conformButton.snp.makeConstraints {
      $0.height.equalTo(52.adjusted)
      $0.leading.trailing.equalToSuperview().inset(10)
    }
  }
  
  private func bindActions() {
    conformButton.rx.tap
      .do(onNext: { [weak self] in
        self?.dismiss(animated: false, completion: nil)
      })
      .bind(to: primaryButtonTap)
      .disposed(by: disposeBag)    
    subButton.rx.tap
      .do(onNext: { [weak self] in
        self?.dismiss(animated: false, completion: nil)
      })
      .bind(to: subButtonTap)
      .disposed(by: disposeBag)
  }
}
