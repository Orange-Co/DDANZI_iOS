//
//  ProductChipView.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/19/24.
//

import UIKit

import Then

final class ProductChipView: UIView {
    private let label = UILabel().then {
        $0.font = .body5R14
        $0.textColor = .black
    }

    init(labelText: String) {
        super.init(frame: .zero)
        label.text = labelText
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
        self.backgroundColor = .white
        self.makeCornerRound(radius: 5)
        self.makeBorder(width: 1, color: .black)
        self.addSubview(label)
    }
    
    private func setConstraints() {
        label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.bottom.equalToSuperview().inset(5)
        }
    }
  
  func configureChip(text: String) {
    label.text = text
  }
}
