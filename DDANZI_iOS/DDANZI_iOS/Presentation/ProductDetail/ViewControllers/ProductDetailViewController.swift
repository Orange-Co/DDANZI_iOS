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
  private var productId: String
  
    // MARK: Compenets
    private let customNavigationBar = CustomNavigationBarView(navigationBarType: .home)
    private let scrollView = UIScrollView()
    private let contentView = UIView()
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
    
  
  init(productId: String) {
    self.productId = productId
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .white
        fetchProductDetail(id: productId)
        bind()
        setUI()
    }
    
    // MARK: LayoutHelper
    private func setUI() {
        setHierarchy()
        setConstraints()
    }
  
    private func setHierarchy() {
        view.addSubviews(customNavigationBar,
                         scrollView,
                         bottomButtonView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(productImageView,
                                labelView,
                                productTitleLabel,
                                discountLabel,
                                priceLabel,
                                beforePriceLabel,remainLabel,
                                amountLabel,
                                moreLinkButton)
    }
    
    private func setConstraints() {
        customNavigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaInsets.top)
            $0.leading.trailing.equalToSuperview()
        }
      
        scrollView.snp.makeConstraints {
          $0.top.equalTo(customNavigationBar.snp.bottom)
          $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
          $0.edges.equalToSuperview()
          $0.width.equalToSuperview()
        }
        
        productImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
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
            $0.trailing.equalTo(priceLabel.snp.leading).offset(-8)
            $0.bottom.equalTo(discountLabel.snp.bottom)
        }
        
        priceLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
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
            $0.leading.equalTo(remainLabel.snp.leading).offset(-10)
            $0.top.equalTo(remainLabel.snp.bottom).offset(5)
        }
        
        bottomButtonView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
      
        contentView.snp.makeConstraints {
            $0.bottom.equalTo(moreLinkButton.snp.bottom).offset(104)
        }
    }
    
  private func fetchProductDetail(id: String) {
    Providers.HomeProvider.request(target: .loadItemsDetail(id), instance: BaseResponse<ProductDetailResponseDTO>.self) { [weak self] result in
      guard let self = self else { return }
      guard let data = result.data else { return }
      bindUI(productDetail: .init(imgURL: data.imgURL,
                                  productTitle: data.name,
                                  discountRate: data.discountRate,
                                  price: data.salePrice,
                                  beforePrice: data.originPrice,
                                  remainAmount: data.stockCount,
                                  infoURL: data.infoURL,
                                  interestCount: data.interestCount,
                                  isImminent: data.isImminent)
      )
    }
  }
  
  private func bindUI(productDetail: ProductDetailModel){
    productImageView.setImage(with: productDetail.imgURL)
    productTitleLabel.text = productDetail.productTitle
    discountLabel.text = "\(productDetail.discountRate)%"
    priceLabel.text = productDetail.price.toKoreanWon()
    beforePriceLabel.attributedText = productDetail.beforePrice.toKoreanWon().strikeThrough()
    
    amountLabel.text = "\(productDetail.remainAmount)개"
  }
    
    private func bind() {
        customNavigationBar.backButtonTap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        customNavigationBar.homeButtonTap
            .subscribe(onNext: { 
                let homeViewController = DdanziTabBarController()
                let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
                sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: homeViewController)
            })
            .disposed(by: disposeBag)
        
        
        bottomButtonView.button.rx.tap
            .bind{
                let optionViewController = OptionSelectViewController()
                
                if let sheet = optionViewController.sheetPresentationController {
                    sheet.detents = [.medium(), .large()]
                }
              optionViewController.delegate = self
                self.present(optionViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
}

extension ProductDetailViewController: OptionViewControllerDelegate {
    func optionViewControllerDidFinish(_ viewController: OptionSelectViewController) {
        let purchaseVC = PurchaseViewController()
        self.navigationController?.pushViewController(purchaseVC, animated: true)
    }
}
