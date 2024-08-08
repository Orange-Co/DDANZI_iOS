//
//  DdanziMiniButton.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/9/24.
//


import UIKit

final class DdanziMiniButton: UIButton {
  init (title: String) {
    super.init(frame: .init(x: 0, y: 0, width: 45, height: 30))
    configureButton(title: title)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureButton(title: String) {
    self.backgroundColor = .white
    self.setTitle(title, for: .normal)
    self.setTitleColor(.gray4, for: .normal)
    self.titleLabel?.font = .body6M12
    self.makeBorder(width: 1, color: .gray2)
    self.makeCornerRound(radius: 3)
  }
}
