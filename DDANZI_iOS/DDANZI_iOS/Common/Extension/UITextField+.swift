//
//  UITextField+.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/9/24.
//

import UIKit

extension UITextField {
  func setPlaceholder(text: String, color: UIColor, font: UIFont) {
    let attributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: color,
      .font: font
    ]
    self.attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
  }
}
