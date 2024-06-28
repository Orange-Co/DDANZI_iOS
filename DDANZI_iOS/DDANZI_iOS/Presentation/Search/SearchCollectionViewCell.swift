//
//  SearchCollectionViewCell.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/23/24.
//

import UIKit

import RxSwift
import Then
import SnapKit

class SearchCollectionViewCell: UICollectionViewCell {
    // MARK: Properties
    static let identifier = "SearchCollectionViewCell"
    let disposeBag = DisposeBag()
    var heartCount = 29
    
    // MARK: Compenets
    private let productImageView = UIImageView().then {
        $0.backgroundColor = .gray
        $0.makeCornerRound(radius: 5)
    }
    
    let heartButtonView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.3)
        $0.makeCornerRound(radius: 10)
    }
    
    let heartButton = UIButton().then {
        $0.setImage(.icEmptyHeart, for: .normal)
    }
    
    let heartLabel = UILabel().then {
        $0.text = "22"
        $0.font = .body7M10
        $0.textColor = .white
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .body3Sb16
        $0.textColor = .black
    }
    
    let beforePriceLabel = UILabel().then {
        $0.font = .body6M12
        $0.textColor = .gray2
    }
    
    private let priceLabel = UILabel().then {
        $0.font = .body2Sb18
        $0.textColor = .black
    }
    
    var heartButtonTap: Observable<Void> {
        return heartButton.rx.tap.asObservable()
    }
    
    // MARK: LifeCycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LayoutHelper
    private func setUI() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        heartButtonView.addSubviews(heartButton, heartLabel)
        productImageView.addSubview(heartButtonView)
        
        self.addSubviews(productImageView,
                         titleLabel,
                         beforePriceLabel,
                         priceLabel)
    }
    
    private func setConstraints() {
        heartButton.snp.makeConstraints {
            $0.size.equalTo(10)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalTo(heartLabel.snp.leading).offset(-3)
        }
        
        heartLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8)
        }
        
        heartButtonView.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.top.trailing.equalToSuperview().inset(7)
        }
        
        productImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(170)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.top.equalTo(productImageView.snp.bottom).offset(8)
        }
        
        beforePriceLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.bottom.equalTo(priceLabel.snp.bottom)
        }
        
        priceLabel.snp.makeConstraints {
            $0.trailing.equalTo(productImageView.snp.trailing).offset(6)
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
    }
    
    func bindData(productTitle: String,
                  beforePrice: String,
                  price: String,
                  heartCount: Int) {
        titleLabel.text = productTitle
        beforePriceLabel.text = beforePrice
        priceLabel.text = price
        
        beforePriceLabel.attributedText = beforePriceLabel.text?.strikeThrough()
    }
}
