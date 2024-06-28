//
//  SectionHeaderView.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/24/24.
//

import UIKit
import Then
import SnapKit

class SectionHeaderView: UICollectionReusableView {
    static let identifier = "SectionHeaderView"
    
    private let titleLabel = UILabel().then {
        $0.font = .body3Sb16
        $0.textColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
    
    func bind(title: String, searchKeyword: String = "") {
        let attributedString = NSMutableAttributedString(string: title, attributes: [
            NSAttributedString.Key.font: UIFont.body3Sb16,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ])
        
        let specialAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.body2Sb18,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        
        if let range = title.range(of: "\"\(searchKeyword)\"") {
            attributedString.setAttributes(specialAttributes, range: NSRange(range, in: title))
        }
        
        titleLabel.attributedText = attributedString
    }
}
