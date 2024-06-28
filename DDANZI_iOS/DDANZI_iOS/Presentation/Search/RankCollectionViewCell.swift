//
//  RankCollectionViewCell.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/23/24.
//

import UIKit

import SnapKit
import Then

final class RankCollectionViewCell: UICollectionViewCell {
    static let identifier = "RankCollectionViewCell"
    
    let label = UILabel().then {
        $0.font = .body5R14
        $0.textColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.makeCornerRound(radius: 14)
        self.makeBorder(width: 1, color: .black)
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        self.addSubviews(label)
    }
    
    private func setConstraints() {
        label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
        }
    }
    
    func bindData(labelText: String) {
        self.label.text = labelText
        self.label.sizeToFit()
    }
}
