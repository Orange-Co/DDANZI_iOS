//
//  LandingViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/9/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class LandingViewController: UIViewController {
  
  private let guideImages: [UIImage] = [UIImage(resource: .image1), UIImage(resource: .image2), UIImage(resource: .image3)]
  private let guideTexts: [String] = [
    "선물받은 배송상품의 캡처화면을 업로드 해주세요.\n\n상품명이 확인 되어야 합니다!",
    "거래성사 시 푸시알림이 도착해요.\n\n정보확인 후 카카오선물창에 직접입력 해주세요!",
    "판매금 정산은 배송 및 구매확정 후 이루어집니다.\n\n딴지와 함께 즐거운 거래 되세요!"
  ]
  
  // 현재 이미지 인덱스
  private var currentImageIndex = 0
  private let disposeBag = DisposeBag()
  
  // MARK: - UI
  private let navigationBar = CustomNavigationBarView(navigationBarType: .cancel, title: "판매하기")
  private let imageView = UIImageView()
  
  private let pageControl = UIPageControl().then {
    $0.numberOfPages = 3
    $0.currentPage = 0
    $0.currentPageIndicatorTintColor = .dYellow
    $0.pageIndicatorTintColor = .gray2
  }
  
  private let guideLabel = UILabel().then {
    $0.font = .body4R16
    $0.numberOfLines = 3
    $0.textAlignment = .center
    $0.textColor = .black
  }
  
  private let nextButton = DdanziButton(title: "다음")
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
    bind()
  }
  
  private func setUI() {
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    self.view.backgroundColor = .white
    imageView.image = guideImages[currentImageIndex]
    guideLabel.text = guideTexts[currentImageIndex]
    
    
    view.addSubviews(
      navigationBar,
      imageView,
      pageControl,
      guideLabel,
      nextButton
    )
  }
  
  private func setConstraints() {
    navigationBar.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }
    
    imageView.snp.makeConstraints {
      $0.top.equalTo(navigationBar.snp.bottom).offset(62)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(295.adjusted)
    }
    
    pageControl.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.bottom).offset(10)
      $0.centerX.equalToSuperview()
    }
    
    guideLabel.snp.makeConstraints {
      $0.top.equalTo(pageControl.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview().inset(20)
    }
    
    nextButton.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaInsets).inset(63)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(50)
    }
  }
  
  private func bind() {
    nextButton.rx.tap
      .subscribe(with: self, onNext: { owner, _ in
        owner.currentImageIndex = (owner.currentImageIndex + 1) % owner.guideImages.count
        owner.updateImageView(for: owner.currentImageIndex)
      })
      .disposed(by: disposeBag)
    
    pageControl.rx.controlEvent(.valueChanged)
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        self.currentImageIndex = self.pageControl.currentPage
        self.updateImageView(for: self.currentImageIndex)
      })
      .disposed(by: disposeBag)
  }
  
  private func updateImageView(for index: Int) {
    imageView.image = guideImages[index]
    imageView.image = guideImages[index]
    guideLabel.text = guideTexts[index]
    index == 2 ?
    nextButton.setTitle("캡쳐화면 선택하기", for: .normal) : nextButton.setTitle("다음", for: .normal)
    pageControl.currentPage = index
  }
}
