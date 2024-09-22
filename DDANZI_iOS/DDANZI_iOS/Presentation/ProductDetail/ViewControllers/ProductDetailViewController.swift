//
//  ProductDetailViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/18/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources
import SnapKit
import Then
import Amplitude

// MARK: - OptionDelegate
protocol OptionViewControllerDelegate: AnyObject {
  func optionViewControllerDidFinish(_ viewController: OptionSelectViewController, optionList: [Int])
}

final class ProductDetailViewController: UIViewController {
  // MARK: Properties
  
  private let disposeBag = DisposeBag()
  private var productId: String
  private var optionList: [OptionList] = []
  private var isInterest: Bool = false
  private var interestCount = 0
  private var moreLink = ""
  
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
  
  private let bottomButtonView = BottomButtonView(buttonText: "구매하기", isEnable: true)
  
  
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
    Amplitude.instance().logEvent("view_detail", withEventProperties: ["product_id":"productId"])
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
      $0.top.equalTo(view.safeAreaLayoutGuide)
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
      bindUI(productDetail: .init(
        imgURL: data.imgURL,
        productTitle: data.name,
        discountRate: data.discountRate,
        price: data.salePrice,
        beforePrice: data.originPrice,
        remainAmount: data.stockCount,
        infoURL: data.infoURL,
        interestCount: data.interestCount,
        isImminent: data.isImminent,
        category: data.category,
        isInterest: data.isInterested ?? false
      )
      )
      self.moreLink = data.infoURL
      self.isInterest = data.isInterested ?? false
      self.interestCount = data.interestCount
      self.optionList = data.optionList
    }
  }
  
  private func bindUI(productDetail: ProductDetailModel){
    productImageView.setImage(with: productDetail.imgURL)
    productTitleLabel.text = productDetail.productTitle
    discountLabel.text = "\(productDetail.discountRate)%"
    priceLabel.text = productDetail.price.toKoreanWon()
    beforePriceLabel.attributedText = productDetail.beforePrice.toKoreanWon().strikeThrough()
    labelView.configureChip(text: productDetail.category)
    amountLabel.text = "\(productDetail.remainAmount)개"
    bottomButtonView.heartCountLabel.text = "\(productDetail.interestCount)"
    bottomButtonView.heartButton.isSelected = productDetail.isInterest
  }
  
  private func bind() {
    customNavigationBar.backButtonTap
      .subscribe(onNext: { [weak self] in
        Amplitude.instance().logEvent("click_detail_quit")
        self?.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
    
    customNavigationBar.homeButtonTap
      .subscribe(onNext: {
        Amplitude.instance().logEvent("click_detail_home")
        let homeViewController = DdanziTabBarController()
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
        sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: homeViewController)
      })
      .disposed(by: disposeBag)
    
    bottomButtonView.heartButtonTap
      .subscribe(with: self) { owner, _ in
        Amplitude.instance().logEvent("click_detail_heart")
        let id = owner.productId
        owner.isInterest ? owner.deleteInterest(id: id) : owner.addInterest(id: id)
      }
      .disposed(by: disposeBag)
    
    moreLinkButton.rx.tap
      .bind(with: self) { owner, _ in
        Amplitude.instance().logEvent("click_detail_detail")
        if let url = URL(string: owner.moreLink) {
          if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
          }
        }
      }
      .disposed(by: disposeBag)
    
    bottomButtonView.button.rx.tap
      .bind(with: self, onNext: { owner, void in
        Amplitude.instance().logEvent("click_detail_purchase")
        if !(UserDefaults.standard.bool(forKey: .isLogin)) {
          self.navigationController?.pushViewController(LoginViewController(signUpFrom: "buy"), animated: true)
          return
        }
        if owner.optionList.isEmpty {
          let purchaseVC = PurchaseViewController()
          purchaseVC.orderModel = .init(productId: owner.productId, optionList: owner.optionList.map({ $0.optionID }))
          self.navigationController?.pushViewController(purchaseVC, animated: true)
        } else {
          let optionViewController = OptionSelectViewController()
          optionViewController.option = self.optionList.map { option in
              .init(optionId: option.optionID, type: option.type, optionDetailList: option.optionDetailList)
          }
          if let sheet = optionViewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
          }
          optionViewController.delegate = self
          self.present(optionViewController, animated: true)
        }
      })
      .disposed(by: disposeBag)
    
  }
  
  private func addInterest(id: String) {
    Providers.InterestProvider.request(target: .addInterest(id),
                                       instance: BaseResponse<InterestResponseDTO>.self) { result in
      self.bottomButtonView.heartButton.isSelected = true
      self.bottomButtonView.heartCountLabel.text = "\(self.interestCount + 1)"
    }
  }
  
  private func deleteInterest(id: String) {
    Providers.InterestProvider.request(target: .deleteInterest(id),
                                       instance: BaseResponse<InterestResponseDTO>.self) { result in
      self.bottomButtonView.heartButton.isSelected = false
      self.bottomButtonView.heartCountLabel.text = "\(self.interestCount - 1)"
    }
  }
}

extension ProductDetailViewController: OptionViewControllerDelegate {
  func optionViewControllerDidFinish(_ viewController: OptionSelectViewController, optionList: [Int]) {
    let purchaseVC = PurchaseViewController()
    purchaseVC.orderModel = .init(productId: productId, optionList: optionList)
    self.navigationController?.pushViewController(purchaseVC, animated: true)
  }
}
