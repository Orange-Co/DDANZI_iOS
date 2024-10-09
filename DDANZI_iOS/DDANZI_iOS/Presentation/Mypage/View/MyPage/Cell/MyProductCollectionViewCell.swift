//
//  MyProductCollectionViewCell.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/4/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

enum ListType {
  case sales
  case purchase
  case interest
}

final class MyProductCollectionViewCell: UICollectionViewCell {
  static let identifier = "MyProductCollectionViewCell"
  
  var disposeBag = DisposeBag()
  private let listTypeRelay = BehaviorRelay<ListType>(value: .sales)
  private var itemId: String = ""
  private var isInterst: Bool = true
  
  var listType: ListType {
    get {
      return listTypeRelay.value
    }
    set {
      listTypeRelay.accept(newValue)
    }
  }
  
  private let imageView = UIImageView().then {
    $0.backgroundColor = .gray2
  }
  private let cancelButton = UIButton().then {
    $0.setImage(.btnXCircle, for: .normal)
  }
  private let titleLabel = UILabel().then {
    $0.font = .body3Sb16
    $0.numberOfLines = 2
    $0.textColor = .blackground
  }
  private let purchaseDateLabel = UILabel().then {
    $0.font = .body6M12
    $0.textColor = .black
  }
  private let beforeLabel = UILabel().then {
    $0.font = .body6M12
    $0.textColor = .gray2
  }
  private let priceLabel = UILabel().then {
    $0.font = .body3Sb16
    $0.textColor = .black
  }
  private let heartView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 3
    $0.alignment = .center
  }
  private let heartIconImageView = UIImageView().then {
    $0.image = .icSmallHeart
  }
  private let heartLabel = UILabel().then {
    $0.font = .body8M8
    $0.textColor = .black
  }
  private let heartButton = UIButton().then {
    $0.setImage(.icFillHeartYellow, for: .normal)
  }
  
  let deleteButton = UIButton().then {
    $0.setImage(.btnXCircle, for: .normal)
    $0.isHidden = true
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
    bindUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    self.isInterst = true
    self.itemId = ""
    self.disposeBag = DisposeBag()
    super.prepareForReuse()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    
    if heartButton.frame.contains(location) {
      addInterest()
      return
    }
    
    if deleteButton.frame.contains(location) {
      // 삭제 로직 추가하기
    }
    
    super.touchesBegan(touches, with: event)
  }
  
  private func bindUI() {
    listTypeRelay
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] listType in
        guard let self = self else { return }
        self.updateUI(for: listType)
      })
      .disposed(by: disposeBag)
  }
  
  private func updateUI(for listType: ListType) {
    imageView.subviews.forEach { $0.removeFromSuperview() }
    purchaseDateLabel.removeFromSuperview()
    heartView.removeFromSuperview()
    
    switch listType {
    case .sales:
      setSalesConstraints()
    case .purchase:
      setPurchaseConstraints()
    case .interest:
      setInterestConstraints()
    }
  }
  
  private func setUI() {
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    heartView.addArrangedSubview(heartIconImageView)
    heartView.addArrangedSubview(heartLabel)
    self.addSubviews(imageView,
                     titleLabel,
                     beforeLabel,
                     priceLabel,
                     heartView,
                     deleteButton)
  }
  
  private func setConstraints() {
    imageView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(164)
    }
    
    deleteButton.snp.makeConstraints {
      $0.size.equalTo(18.adjusted)
      $0.trailing.top.equalToSuperview().inset(8.adjusted)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.bottom).offset(9)
      $0.leading.trailing.equalToSuperview()
    }
    
  }
  
  private func setPurchaseConstraints() {
    self.addSubviews(purchaseDateLabel)
    
    purchaseDateLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(5)
      $0.leading.equalToSuperview()
    }
    
    priceLabel.snp.remakeConstraints {
      $0.bottom.equalToSuperview().inset(5)
      $0.trailing.equalToSuperview().inset(5)
    }
    
    beforeLabel.snp.remakeConstraints {
      $0.bottom.equalTo(priceLabel.snp.bottom)
      $0.leading.equalToSuperview()
    }
  }
  
  private func setSalesConstraints() {
    self.addSubviews(heartView)
    beforeLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(7)
      $0.leading.equalToSuperview()
    }
    
    priceLabel.snp.remakeConstraints {
      $0.top.equalTo(beforeLabel.snp.bottom).offset(7)
      $0.leading.equalToSuperview()
    }
    
    heartView.snp.makeConstraints {
      $0.bottom.equalTo(priceLabel.snp.bottom)
      $0.trailing.equalToSuperview().inset(5)
    }
  }
  
  private func setInterestConstraints() {
    self.addSubviews(heartView)
    imageView.addSubviews(heartButton)
    
    heartButton.snp.makeConstraints {
      $0.top.trailing.equalToSuperview().inset(7)
    }
    
    beforeLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(7)
      $0.leading.equalToSuperview()
    }
    
    priceLabel.snp.makeConstraints {
      $0.top.equalTo(beforeLabel.snp.bottom).offset(7)
      $0.leading.equalToSuperview()
    }
    
    heartView.snp.makeConstraints {
      $0.bottom.equalTo(priceLabel.snp.bottom)
      $0.trailing.equalToSuperview().inset(5)
    }
  }
  
  private func addInterest() {
    var heartCount: Int = 0
    if let count = Int(self.heartLabel.text ?? "0") {
      heartCount = count
    }
    
    if isInterst {
      Providers.InterestProvider.request(target: .deleteInterest(self.itemId), instance: BaseResponse<InterestResponseDTO>.self) { response in
        guard let data = response.data else { return }
        self.heartLabel.text = "\(max(heartCount - 1, 0))"
        self.heartButton.setImage(.icEmptyHeart, for: .normal)
        self.isInterst.toggle()
      }
    } else {
      Providers.InterestProvider.request(target: .addInterest(self.itemId), instance: BaseResponse<InterestResponseDTO>.self) { response in
        guard let data = response.data else { return }
        self.heartLabel.text = "\(heartCount + 1)"
        self.heartButton.setImage(.icFillHeartYellow, for: .normal)
        self.isInterst.toggle()
      }
    }
  }
  
  func bindData(
    image: String,
    title: String,
    beforePrice: String,
    price: String,
    heartCount: Int,
    completedAt: String = "",
    isInterst: Bool = true,
    itemId: String
  ) {
    imageView.setImage(with: image)
    titleLabel.text = title
    beforeLabel.text = beforePrice
    priceLabel.text = price
    heartLabel.text = "\(heartCount)"
    self.isInterst = isInterst
    self.itemId = itemId
    
    beforeLabel.attributedText = beforeLabel.text?.strikeThrough()
    
    
    purchaseDateLabel.text = completedAt
  }
}
