//
//  String+.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/16/24.
//

import UIKit

extension String {
    func strikeThrough() -> NSAttributedString {
           let attributeString = NSMutableAttributedString(string: self)
           attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
           return attributeString
       }
}
