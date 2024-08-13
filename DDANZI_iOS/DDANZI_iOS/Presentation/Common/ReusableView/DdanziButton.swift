//
//  DdanziButton.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/4/24.
//

import UIKit

final class DdanziButton: UIButton {
  init (title: String, enable: Bool = true) {
    super.init(frame: .init(x: 0, y: 0, width: 0, height: 50))
    enable ? configureButton(title: title) : configureUnableButton(title: title)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setEnable() {
    self.backgroundColor = .black
    self.isEnabled = true
  }
  
  private func configureButton(title: String) {
    self.backgroundColor = .black
    self.setTitle(title, for: .normal)
    self.setTitleColor(.white, for: .normal)
    self.titleLabel?.font = .body3Sb16
    self.makeCornerRound(radius: 10)
  }
  
  private func configureUnableButton(title: String) {
    self.backgroundColor = .gray2
    self.isEnabled = false
    self.setTitle(title, for: .normal)
    self.setTitleColor(.white, for: .normal)
    self.titleLabel?.font = .body3Sb16
    self.makeCornerRound(radius: 10)
  }
}
