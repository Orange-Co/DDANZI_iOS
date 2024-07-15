//
//  BottomButtonView.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/18/24.
//

import UIKit

class BottomButtonView: UIView {
    let backgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.addShadow(offset: .init(width: 1, height: 1))
    }
    
    let button = UIButton().then {
        $0.backgroundColor = .black
        $0.makeCornerRound(radius: 5)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .body3Sb16
    }
    
    let heartButton = UIButton().then {
        $0.setImage(.icBlackEmptyHeart, for: .normal)
    }
    
    let heartCountLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .body6M12
    }
    
    init(buttonText: String, heartCount: Int = 0) {
        super.init(frame: .zero)
        self.button.setTitle(buttonText, for: .normal)
        self.heartCountLabel.text = "\(heartCount)"
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.backgroundColor = .white
      self.addShadow(offset: .init(width: 0, height: 2), opacity: 0.3)
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        self.addSubviews(heartButton,
                         heartCountLabel,
                         button)
    }
    
    private func setConstraints() {
        self.snp.makeConstraints {
            $0.height.equalTo(82)
        }
        
        heartButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(23)
            $0.leading.equalToSuperview().offset(32)
            $0.width.equalTo(23)
        }
        
        heartCountLabel.snp.makeConstraints {
            $0.top.equalTo(heartButton.snp.bottom).offset(3)
            $0.centerX.equalTo(heartButton.snp.centerX)
        }
        
        button.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalTo(heartButton.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().inset(23)
            $0.height.equalTo(50)
        }
    }
}
