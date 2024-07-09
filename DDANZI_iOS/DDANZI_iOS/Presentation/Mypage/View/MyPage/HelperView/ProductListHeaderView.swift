//
//  ProductListHeaderView.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/5/24.
//

import UIKit

import SnapKit
import Then

final class ProductListHeaderView: UIView {
    /// 상품 개수를 나타냅니다.
    var count = 10
    
    // MARK: - UIComponents
    private let countLabel = UILabel().then {
        $0.font = .body4R16
        $0.textColor = .gray3
    }
    private let editButton = UIButton().then {
        $0.setTitle("편집", for: .normal)
        $0.titleLabel?.font = .body4R16
        $0.setTitleColor(.gray4, for: .normal)
        $0.setUnderline()
    }
    
    // MARK: - Initalizer
    init(isEditable: Bool) {
        super.init(frame: .zero)
        editButton.isHidden = isEditable ? false : true
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Layout Helper
    private func setUI() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        self.addSubviews(countLabel,
                         editButton)
    }
    
    private func setConstraints() {
        countLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        editButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    func setCount(count: Int) {
        countLabel.text = "총 \(count)개"
    }
}

