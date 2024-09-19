//
//  CheckItemViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/9/24.
//

import UIKit

import Then
import SnapKit
import RxSwift
import RxCocoa

final class CheckItemViewController: UIViewController {
  let response = PublishRelay<ItemCheckDTO>()
  
  let responseData: ItemCheckDTO
  private var productId: String = ""
  private let disposeBag = DisposeBag()
  
  private let containerView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 10
  }
  
  private let xButton = UIButton().then {
    $0.setImage(.icCancel, for: .normal)
  }
  
  private let itemImageView = UIImageView()
  
  private let itemNameLabel = UILabel().then {
    $0.font = .body4R16
    $0.numberOfLines = 2
    $0.textAlignment = .center
    $0.textColor = .black
  }
  
  private let checkLabel = UILabel().then {
    $0.text = "해당 상품이 맞나요?"
    $0.textColor = .black
    $0.font = .title4Sb24
  }
  
  private let nextButton = DdanziButton(title: "네 맞아요")
  
  private let retryButton = UIButton().then {
    $0.setTitle("다시 업로드하기", for: .normal)
    $0.titleLabel?.font = .buttonText
    $0.setTitleColor(.gray3, for: .normal)
    $0.setUnderline()
  }
  
  init(responseData: ItemCheckDTO, productId: String) {
    self.responseData = responseData
    self.productId = productId
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
    self.view.backgroundColor = .white.withAlphaComponent(0.3)
    
    self.itemImageView.setImage(with: responseData.imgUrl)
    self.itemNameLabel.text = responseData.productName
    self.productId = responseData.productId
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    view.addSubview(containerView)
    containerView.addSubviews(xButton, itemImageView, itemNameLabel, checkLabel, nextButton, retryButton)
  }
  
  private func setConstraints() {
    containerView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.height.equalTo(600.adjusted)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    xButton.snp.makeConstraints {
      $0.top.trailing.equalToSuperview().inset(10)
    }
    
    itemImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(74)
      $0.centerX.equalToSuperview()
      $0.size.equalTo(243)
    }
    
    itemNameLabel.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.top.equalTo(itemImageView.snp.bottom).offset(28)
    }
    
    checkLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(itemNameLabel.snp.bottom).offset(48)
    }
    
    nextButton.snp.makeConstraints {
      $0.height.equalTo(50)
      $0.top.equalTo(checkLabel.snp.bottom).offset(32)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    retryButton.snp.makeConstraints {
      $0.top.equalTo(nextButton.snp.bottom).offset(12)
      $0.centerX.equalToSuperview()
    }
  }
  
  private func bind() {
    xButton.rx.tap
      .subscribe { _ in
        self.navigationController?.popToRootViewController(animated: true)
      }
      .disposed(by: disposeBag)
    
    response.subscribe(with: self) { owner, data in
      self.itemImageView.setImage(with: data.imgUrl)
      self.itemNameLabel.text = data.productName
      self.productId = data.productId
    }
    .disposed(by: disposeBag)
    
    nextButton.rx.tap
      .subscribe(with: self, onNext: { owner, _ in
        owner.conformedItem()
      })
      .disposed(by: disposeBag)
    
    retryButton.rx.tap
      .subscribe { _ in
        self.navigationController?.popViewController(animated: true)
      }
      .disposed(by: disposeBag)
  }
  
  private func conformedItem() {
    Providers.ItemProvider.request(target: .itemConfirmed(id: productId), instance: BaseResponse<itemConformedDTO>.self) { response in
      guard let data = response.data else { return }
      let registeVC = RegisteItemViewController(info: data)
      registeVC.itemInfo.accept(data)
      self.navigationController?.pushViewController(registeVC, animated: true)
    }
  }
}
