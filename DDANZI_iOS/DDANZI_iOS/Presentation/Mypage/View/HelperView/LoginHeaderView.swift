//
//  LoginHeader.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/27/24.
//

import UIKit

import SnapKit
import Then

final class LoginHeaderView: UIView {
    let loginButton = UIButton().then {
        $0.setImage(.blueArrow, for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
        var config = UIButton.Configuration.plain()
        config.imagePadding = 10
        config.contentInsets = .zero
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.title2R32,
            .foregroundColor: UIColor.black
        ]
        let attributedTitle = NSAttributedString(string: "로그인해주세요", attributes: titleAttributes)
        
        // Set the attributed title for the normal state
        config.attributedTitle = AttributedString(attributedTitle)
        
        $0.configuration = config
    }
    
    let benefitButton = UIButton().then {
        $0.setTitle("회원가입 시 혜택 보기", for: .normal)
        $0.setTitleColor(.dBlue, for: .normal)
        $0.setUnderline()
        $0.titleLabel?.font = .buttonText
    }
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 10
    }
    
    init() {
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        stackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(benefitButton)
        
        self.addSubviews(stackView)
    }
    
    private func setConstraints() {
        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
    }
}

