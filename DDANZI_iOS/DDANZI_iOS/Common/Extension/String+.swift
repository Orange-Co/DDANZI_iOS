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
  
  func toKoreanDateTimeFormat() -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSS"
    dateFormatter.locale = Locale(identifier: "ko_KR")
    
    guard let date = dateFormatter.date(from: self) else { return nil }
    
    let koreanFormatter = DateFormatter()
    koreanFormatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
    koreanFormatter.locale = Locale(identifier: "ko_KR")
    
    return koreanFormatter.string(from: date)
  }
}
