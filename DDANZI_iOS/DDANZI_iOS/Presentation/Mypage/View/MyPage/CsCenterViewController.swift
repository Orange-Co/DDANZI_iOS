//
//  CsCenterViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/28/24.
//

import UIKit

import Then
import SnapKit
import RxSwift
import RxCocoa

final class CsCenterViewController: UIViewController {
    private let disposeBag = DisposeBag()
    let navigaionBar = CustomNavigationBarView(navigationBarType: .normal, title: "상담 센터")
    
    let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.text = "거래에 문제가 생겼나요?"
        $0.font = .title3Sb28
    }
    
    let guideView = UIView().then {
        $0.backgroundColor = .white
        $0.makeCornerRound(radius: 5)
        $0.makeBorder(width: 1, color: .black)
    }
    
    let guideLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .body4R16
        $0.text = """
        1. 상품이 10일 이상 배송되지 않았어요
        2. 판매글과 다른상품이 배송되었어요
        3. 이외 거래에 문제가 생겼어요
        
        해당 경우에는
        딴지 채널톡으로 문의해주세요
        """
        $0.textAlignment = .center
        $0.numberOfLines = 10
    }
    
    let contactButton = DdanziButton(title: "채널톡 연결")
    
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
        view.backgroundColor = .white
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        view.addSubviews(navigaionBar,
                         titleLabel,
                         guideView,
                         contactButton)
        guideView.addSubview(guideLabel)
    }
    
    private func setConstraints() {
        navigaionBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        guideView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(132)
        }
        
        guideLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        contactButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }
  
    private func bind() {
      navigaionBar.backButtonTap
        .subscribe(onNext: { [weak self] in
          self?.navigationController?.popViewController(animated: true)
        })
        .disposed(by: disposeBag)
    }
    
}
