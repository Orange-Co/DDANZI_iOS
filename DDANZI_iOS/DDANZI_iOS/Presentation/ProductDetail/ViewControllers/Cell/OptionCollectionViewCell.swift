//
//  OptionCollectionViewCell.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/23/24.
//

import UIKit

import Then
import SnapKit

final class OptionCollectionViewCell: UICollectionViewCell {
    /// 옵션 선택 여부
    var isSelectedOption: Bool = false {
        didSet {
            titleLabel.textColor = .black
        }
    }
    static let identifier = "OptionCollectionViewCell"
    
    let titleLabel = UILabel().then {
        $0.font = .body5R14
        $0.textColor = .gray2
    }
    
    override init(frame: CGRect) {
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
        self.addSubviews(titleLabel)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
  func configureCell(text: String, isEnable: Bool){
    self.titleLabel.text = text
    self.titleLabel.textColor = isEnable ? .black : .gray2
  }
}

