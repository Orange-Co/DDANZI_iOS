//
//  RegisteItemCell.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/9/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class RegisteItemCell: UICollectionViewCell {
  
  private let terms: [String] = ["서비스 이용 약관", "딴지 판매 가이드"]
  var selectedTerms = BehaviorRelay<[Bool]>(value: [false, false])
  var itemInfo = PublishRelay<itemConformedDTO>()
  private let disposeBag = DisposeBag()
  
  private let imageView = UIImageView()
  private let productTitleLabel = UILabel().then {
    $0.font = .title4Sb24
    $0.text = "상품 정보"
    $0.textColor = .black
  }
  private let productNameStackView = UIStackView()
  
  private let productNameLabel = UILabel().then {
    $0.font = .body5R14
    $0.text = "상품명"
    $0.textColor = .gray3
  }
  
  private let productNameContentLabel = UILabel().then {
    $0.font = .body4R16
    $0.textColor = .black
  }
  
  private let kakaoPriceStackView = UIStackView()
  
  private let kakaoPriceLabel = UILabel().then {
    $0.font = .body5R14
    $0.text = "카카오 선물하기 가격"
    $0.textColor = .gray3
  }
  
  private let kakaoPriceContentLabel = UILabel().then {
    $0.font = .body4R16
    $0.textColor = .black
  }
  
  private let priceStackView = UIStackView()
  
  private let priceLabel = UILabel().then {
    $0.font = .body5R14
    $0.text = "판매 가격"
    $0.textColor = .gray3
  }
  
  private let priceContentLabel = UILabel().then {
    $0.font = .body4R16
    $0.textColor = .black
  }
  
  private let dateTitleLabel = UILabel().then {
    $0.font = .title4Sb24
    $0.text = "받은 날짜"
    $0.textColor = .black
  }
  
  private let guideLabel = UILabel().then {
    $0.text = "배송지 입력 기간 이내의 상품만 등록 가능합니다."
    $0.font = .body6M12
    $0.textColor = .black
  }
  
  private let dateLabelButton = UIButton().then {
    $0.setTitle("클릭해서 날짜를 선택하세요", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 10
    $0.layer.borderColor = UIColor.black.cgColor
    $0.layer.borderWidth = 1
    $0.clipsToBounds = true
  }
  
  private let fullAgreementButton = UIButton().then {
    $0.setTitle("아래 약관에 전체동의해요", for: .normal)
    $0.setTitleColor(.gray2, for: .normal)
    $0.setTitleColor(.black, for: .selected)
    $0.setImage(.icBlackCheck.withTintColor(.gray2), for: .normal)
    $0.setImage(.icBlackCheck, for: .selected)
  }
  
  private let termsTableView = UITableView().then {
    $0.register(TermsTableViewCell.self, forCellReuseIdentifier: TermsTableViewCell.className)
    $0.rowHeight = 82
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
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
    self.addSubviews(imageView, productTitleLabel, productNameStackView, kakaoPriceStackView, priceStackView, dateTitleLabel, dateLabelButton, fullAgreementButton, termsTableView)
  }
  
  private func setConstraints() {
    imageView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(15)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    productTitleLabel.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.bottom).offset(20)
      $0.leading.equalToSuperview().offset(20)
    }
    
    productNameStackView.snp.makeConstraints {
      $0.top.equalTo(productTitleLabel.snp.bottom).offset(15)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    kakaoPriceStackView.snp.makeConstraints {
      $0.top.equalTo(productNameStackView.snp.bottom).offset(9)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    priceStackView.snp.makeConstraints {
      $0.top.equalTo(kakaoPriceStackView.snp.bottom).offset(9)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    dateTitleLabel.snp.makeConstraints {
      $0.top.equalTo(priceStackView.snp.bottom).offset(15)
      $0.leading.equalToSuperview().offset(20)
    }
    
    guideLabel.snp.makeConstraints {
      $0.top.equalTo(dateTitleLabel.snp.bottom).offset(5)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    dateLabelButton.snp.makeConstraints {
      $0.top.equalTo(guideLabel.snp.bottom).offset(15)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(50)
    }
    
    fullAgreementButton.snp.makeConstraints {
      $0.top.equalTo(dateLabelButton.snp.bottom).offset(20)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    termsTableView.snp.makeConstraints {
      $0.top.equalTo(fullAgreementButton.snp.bottom).offset(10)
      $0.horizontalEdges.equalToSuperview()
    }
  }
  
  func configure(info: itemConformedDTO) {
    itemInfo.accept(info)
  }
  
  
  private func configureTableView() {
    termsTableView.dataSource = self
    termsTableView.delegate = self
  }
  
  private func bindTableView() {
    itemInfo
      .subscribe(with: self) { owner, info in
        self.imageView.setImage(with: info.imgUrl)
        self.productNameContentLabel.text = info.productName
        self.kakaoPriceContentLabel.text = info.originPrice.toKoreanWon()
        self.priceLabel.text = info.salePrice.toKoreanWon()
      }
      .disposed(by: disposeBag)
    
    
    // 전체 동의 버튼 클릭 시
    fullAgreementButton.rx.tap
      .withLatestFrom(selectedTerms)
      .subscribe(onNext: { [weak self] termsSelected in
        let allSelected = termsSelected.allSatisfy { $0 }
        self?.toggleSelectAllTerms(!allSelected)
      })
      .disposed(by: disposeBag)
    
    // 선택된 약관 배열이 변경될 때마다 테이블뷰 및 전체 동의 버튼 상태 업데이트
    selectedTerms
      .subscribe(onNext: { [weak self] termsSelected in
        self?.termsTableView.reloadData()
        self?.updateFullAgreementButtonState(termsSelected)
      })
      .disposed(by: disposeBag)
  }
  
  // 전체 약관 선택 및 해제 로직
  private func toggleSelectAllTerms(_ select: Bool) {
    let newSelections = Array(repeating: select, count: terms.count)
    selectedTerms.accept(newSelections)
  }
  
  // 전체 동의 버튼 상태 업데이트
  private func updateFullAgreementButtonState(_ termsSelected: [Bool]) {
    let allSelected = termsSelected.allSatisfy { $0 }
    fullAgreementButton.isSelected = allSelected
  }
}

extension RegisteItemCell: UITableViewDataSource {
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

extension RegisteItemCell: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    var updatedSelections = selectedTerms.value
    updatedSelections[indexPath.row].toggle()
    selectedTerms.accept(updatedSelections)
  }
}
