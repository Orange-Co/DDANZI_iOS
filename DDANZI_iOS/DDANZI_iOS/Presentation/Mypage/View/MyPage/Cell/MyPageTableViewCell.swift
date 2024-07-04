//
//  MyPageTableViewCell.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/27/24.
//

import UIKit

import Then
import SnapKit

final class MyPageTableViewCell: UITableViewCell {
    
    let titleLabel = UILabel().then {
        $0.font = .body4R16
        $0.textColor = .black
    }
    let rightButton = UIButton()
    let buttonImageView = UIImageView(image: .rightChv)
    let bottomLine = UIView().then {
        $0.backgroundColor = .gray2
    }
    
    static let identifier = "MyPageTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        self.addSubviews(titleLabel,
                         buttonImageView,
                         bottomLine)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        buttonImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
        
        bottomLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
    
    func setTitleLabel(title: String){
        titleLabel.text = title
    }
}
