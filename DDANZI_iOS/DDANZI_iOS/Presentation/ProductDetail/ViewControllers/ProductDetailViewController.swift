//
//  ProductDetailViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/18/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import Then

final class ProductDetailViewController: UIViewController {
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    let dummy = ProductDetailModel(productTitle: "퓨어 오일 퍼퓸 10ml",
                                   discountRate: 30, price: 48900, beforePrice: 54000,
                                   remainAmount: 30)
    // MARK: Compenets
    private let customNavigationBar = CustomNavigationBarView(navigationBarType: .home)
    
    private let productImageView = UIImageView().then {
        $0.backgroundColor = .gray2
    }
    
    private let labelView = ProductChipView(labelText: "향수")
    
    private let productTitleLabel = UILabel().then {
        $0.font = .title4Sb24
        $0.textColor = .black
        $0.numberOfLines = 2
        $0.textAlignment = .left
    }
    
    private let discountLabel = UILabel().then {
        $0.font = .title3Sb28
        $0.textColor = .black
    }
    
    private let priceLabel = UILabel().then {
        $0.font = .title3Sb28
        $0.textColor = .black
    }
    
    private let beforePriceLabel = UILabel().then {
        $0.font = .body1B20
        $0.textColor = .gray2
    }
    
    private let remainLabel = UILabel().then {
        $0.text = StringLiterals.ProductDetail.Label.remainLabel
        $0.font = .body3Sb16
        $0.textColor = .black
    }
    
    private let amountLabel = UILabel().then {
        $0.font = .body3Sb16
        $0.textColor = .gray3
    }
    
    private let moreLinkButton = UIButton().then {
        $0.setTitle(StringLiterals.ProductDetail.Button.morelinkButtonText,
                    for: .normal)
        $0.setTitleColor(.gray3, for: .normal)
        $0.setImage(.rightChv, for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
        $0.titleLabel?.font = .body3Sb16
        var config = UIButton.Configuration.plain()
        config.imagePadding = 10
        $0.configuration = config
    }
    
    private let bottomButtonView = BottomButtonView(buttonText: "구매하기")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .white
        bindDummy()
        bind()
        setUI()
    }
    
    // MARK: LayoutHelper
    private func setUI() {
        setHierarchy()
        setConstraints()
    }
    
    private func bindDummy() {
        productTitleLabel.text = dummy.productTitle
        discountLabel.text = "\(dummy.discountRate)%"
        priceLabel.text = "\(dummy.price)"
        beforePriceLabel.attributedText = "\(dummy.beforePrice)".strikeThrough()
        
        amountLabel.text = "\(dummy.remainAmount)개"
    }
    
    private func bind() {
        bottomButtonView.button.rx.tap
            .bind{
                let optionViewController = OptionSelectViewController()
                
                if let sheet = optionViewController.sheetPresentationController {
                    sheet.detents = [.medium(), .large()]
                }
                
                self.present(optionViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func setHierarchy() {
        view.addSubviews(customNavigationBar,
                         productImageView,
                         labelView,
                         productTitleLabel,
                         discountLabel,
                         priceLabel,
                         beforePriceLabel,remainLabel,
                         amountLabel,
                         moreLinkButton,
                         bottomButtonView)
    }
    
    private func setConstraints() {
        customNavigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaInsets.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        productImageView.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(375)
        }
        
        labelView.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(13)
            $0.leading.equalToSuperview().offset(20)
        }
        
        productTitleLabel.snp.makeConstraints {
            $0.top.equalTo(labelView.snp.bottom).offset(13)
            $0.leading.trailing.equalToSuperview().inset(21)
            $0.height.equalTo(58)
        }
        
        discountLabel.snp.makeConstraints {
            $0.top.equalTo(productTitleLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(21)
        }
        
        beforePriceLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(discountLabel.snp.bottom)
        }
        
        priceLabel.snp.makeConstraints {
            $0.trailing.equalTo(beforePriceLabel.snp.leading).offset(-8)
            $0.bottom.equalTo(discountLabel.snp.bottom)
        }
        
        remainLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(21)
        }
        
        amountLabel.snp.makeConstraints {
            $0.leading.equalTo(remainLabel.snp.trailing).offset(8)
            $0.centerY.equalTo(remainLabel.snp.centerY)
        }
        
        moreLinkButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(remainLabel.snp.bottom).offset(15)
        }
        
        bottomButtonView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
}
