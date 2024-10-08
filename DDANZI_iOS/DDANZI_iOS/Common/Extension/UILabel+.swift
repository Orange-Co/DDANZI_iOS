//
//  UILabel+.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/19/24.
//

import UIKit

extension UILabel {
    
    func setTextColor(_ color: UIColor, range: NSRange) {
        guard let attributedString = self.mutableAttributedString() else { return }
        
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        self.attributedText = attributedString
    }
    
    
    func setBoldFont(_ boldFontName: String, range: NSRange) {
        guard let font = self.font,
              let boldFont = UIFont(name: boldFontName, size: font.pointSize) else {
            return
        }
        
        return setFont(boldFont, range: range)
    }
    
    func setFont(_ font: UIFont, range: NSRange) {
        guard let attributedString = self.mutableAttributedString() else { return }
        
        attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        self.attributedText = attributedString
    }
    
  func setUnderline(for rangeText: String) {
      guard let fullText = self.text else { return }
      
      let attributedString = NSMutableAttributedString(string: fullText)
      
      // 해당 구간의 NSRange 찾기
      if let range = fullText.range(of: rangeText) {
          let nsRange = NSRange(range, in: fullText)
          
          // 밑줄 스타일 적용
          attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: nsRange)
      }
      
      // UILabel의 attributedText에 설정
      self.attributedText = attributedString
  }
    
    private func mutableAttributedString() -> NSMutableAttributedString? {
        guard let labelText = self.text, let labelFont = self.font else { return nil }
        
        var attributedString: NSMutableAttributedString?
        if let attributedText = self.attributedText {
            attributedString = attributedText.mutableCopy() as? NSMutableAttributedString
        } else {
            attributedString = NSMutableAttributedString(string: labelText,
                                                         attributes: [NSAttributedString.Key.font :labelFont])
        }
        
        return attributedString
    }
}

