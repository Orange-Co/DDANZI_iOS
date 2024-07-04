//
//  InfoTableViewCell.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/29/24.
//

import UIKit

import Then
import SnapKit

final class InfoTableViewCell: UITableViewCell {

    static let identifier = "InfoTableViewCell"
    private let titleLabel = UILabel().then {
        $0.font = .body5R14
        $0.textColor = .gray3
    }
    private let infoLabel = UILabel().then {
        $0.font = .body3Sb16
        $0.textColor = .black
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.backgroundColor = .white
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        self.addSubviews(titleLabel,
                         infoLabel)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        infoLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(109)
            $0.centerY.equalToSuperview()
        }
        
    }
    
    func bindData(title: String, info: String) {
        self.titleLabel.text = title
        self.infoLabel.text = info
    }

}
