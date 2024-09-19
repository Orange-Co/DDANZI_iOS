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
  var dateString = BehaviorRelay<String>(value: "")
  private let disposeBag = DisposeBag()
  
  private let imageView = UIImageView()
  private let productTitleLabel = UILabel().then {
    $0.font = .title4Sb24
    $0.text = "상품 정보"
    $0.textColor = .black
  }
  private let productNameStackView = UIStackView().then {
    $0.spacing = 10
  }
  
  private let productNameLabel = UILabel().then {
    $0.font = .body5R14
    $0.text = "상품명"
    $0.textColor = .gray3
  }
  
  private let productNameContentLabel = UILabel().then {
    $0.font = .body4R16
    $0.textColor = .black
  }
  
  private let kakaoPriceStackView = UIStackView().then {
    $0.spacing = 10
  }
  
  private let kakaoPriceLabel = UILabel().then {
    $0.font = .body5R14
    $0.text = "카카오 선물하기 가격"
    $0.textColor = .gray3
  }
  
  private let kakaoPriceContentLabel = UILabel().then {
    $0.font = .body4R16
    $0.textColor = .black
  }
  
  private let priceStackView = UIStackView().then {
    $0.spacing = 10
  }
  
  private let priceLabel = UILabel().then {
    $0.font = .body5R14
    $0.text = "판매 가격"
    $0.textColor = .gray3
  }
  
  private let priceContentLabel = UILabel().then {
    $0.font = .body4R16
    $0.textColor = .black
  }
  
  private let priceSeperatorLine = UIView().then {
    $0.backgroundColor = .gray4
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
  
  let dateLabelButton = UIButton().then {
    $0.setTitle("클릭해서 날짜를 선택하세요", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 10
    $0.layer.borderColor = UIColor.black.cgColor
    $0.layer.borderWidth = 1
    $0.clipsToBounds = true
  }
  
  private let termSeperatorLine = UIView().then {
    $0.backgroundColor = .gray4
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
    $0.rowHeight = 50
    $0.separatorStyle = .none
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
    productNameStackView.addArrangedSubviews(productNameLabel, productNameContentLabel)
    kakaoPriceStackView.addArrangedSubviews(kakaoPriceLabel, kakaoPriceContentLabel)
    priceStackView.addArrangedSubviews(priceLabel, priceContentLabel)
    self.addSubviews(imageView, productTitleLabel, productNameStackView, kakaoPriceStackView, priceStackView, dateTitleLabel, guideLabel, dateLabelButton, fullAgreementButton, termsTableView, termSeperatorLine, priceSeperatorLine)
  }
  
  private func setConstraints() {
    imageView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(15)
      $0.centerX.equalToSuperview()
      $0.size.equalTo(225.adjusted)
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
    
    priceSeperatorLine.snp.makeConstraints {
      $0.height.equalTo(1)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.top.equalTo(priceStackView.snp.bottom).offset(32.adjusted)
    }
    
    dateTitleLabel.snp.makeConstraints {
      $0.top.equalTo(priceSeperatorLine.snp.bottom).offset(29.adjusted)
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
    
    termSeperatorLine.snp.makeConstraints {
      $0.height.equalTo(1)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.top.equalTo(dateLabelButton.snp.bottom).offset(20.adjusted)
    }
    
    fullAgreementButton.snp.makeConstraints {
      $0.top.equalTo(termSeperatorLine.snp.bottom).offset(30.adjusted)
      $0.leading.equalToSuperview().inset(20)
    }
    
    termsTableView.snp.makeConstraints {
      $0.top.equalTo(fullAgreementButton.snp.bottom).offset(35.adjusted)
      $0.leading.trailing.bottom.equalToSuperview()
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
        self.imageView.setImage(with: info.imgURL)
        self.productNameContentLabel.text = info.productName
        self.kakaoPriceContentLabel.text = info.originPrice.toKoreanWon()
        self.priceContentLabel.text = info.salePrice.toKoreanWon()
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
    
    // dateLabelButton을 눌렀을 때 DatePicker 표시
    dateLabelButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.showDatePicker()
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
  
  private func showDatePicker() {
    // DatePicker를 포함한 AlertController 생성
    let alert = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
    
    // DatePicker 생성
    let datePicker = UIDatePicker()
    datePicker.datePickerMode = .date
    datePicker.preferredDatePickerStyle = .wheels // iOS 14 이상에서 wheels 스타일
    datePicker.frame = CGRect(x: 0, y: 0, width: alert.view.frame.width - 20, height: 150)
    
    // DatePicker를 AlertController에 추가
    alert.view.addSubview(datePicker)
    
    // 선택 버튼
    let selectAction = UIAlertAction(title: "선택", style: .default) { _ in
      let selectedDate = datePicker.date
      self.updateDateLabel(with: selectedDate)
    }
    
    // 취소 버튼
    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    
    alert.addAction(selectAction)
    alert.addAction(cancelAction)
    
    // ViewController에 AlertController를 표시
    if let viewController = self.findViewController() {
      viewController.present(alert, animated: true, completion: nil)
    }
  }
  
  // 날짜를 버튼에 반영하는 메서드
  private func updateDateLabel(with date: Date) {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd" // 원하는 날짜 형식
    let dateString = formatter.string(from: date)
    
    self.dateString.accept(dateString)
    self.dateLabelButton.setTitle(dateString, for: .normal)
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
