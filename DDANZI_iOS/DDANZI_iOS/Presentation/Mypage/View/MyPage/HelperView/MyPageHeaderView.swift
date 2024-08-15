//
//  MyPageHeaderView.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/27/24.
//

import UIKit

import SnapKit
import Then

final class MyPageHeaderView: UIView {
    private let greetingLabel = UILabel().then {
        $0.text = "반가워요."
        $0.font = .title4Sb24
        $0.textColor = .blackground
    }
    
    private let nickNameLabel = UILabel().then {
        $0.text = "1224832947"
        $0.textColor = .black
        $0.font = .title2R32
    }
    
    private let surfixLabel = UILabel().then {
        $0.text = "님"
        $0.font = .title4Sb24
        $0.textColor = .blackground
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
        self.addSubviews(greetingLabel,
                         nickNameLabel,
                         surfixLabel)
    }
    
    private func setConstraints() {
        greetingLabel.snp.makeConstraints {
          $0.top.equalToSuperview().offset(33.adjusted)
          $0.leading.equalToSuperview().offset(20.adjusted)
        }
        
        nickNameLabel.snp.makeConstraints {
          $0.top.equalTo(greetingLabel.snp.bottom).offset(15.adjusted)
          $0.leading.equalToSuperview().offset(20.adjusted)
        }
        
        surfixLabel.snp.makeConstraints {
            $0.bottom.equalTo(nickNameLabel.snp.bottom)
          $0.leading.equalTo(nickNameLabel.snp.trailing).offset(5.adjusted)
        }
    }
}

