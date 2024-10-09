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
  
  func convertToDateFormat() -> String? {
    // 입력 형식에 맞는 DateFormatter 생성
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    // String -> Date로 변환
    guard let date = inputFormatter.date(from: self) else {
      return nil
    }
    
    // 원하는 출력 형식으로 DateFormatter 설정
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 24시간 형식
    outputFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    // Date -> String으로 변환 후 반환
    return outputFormatter.string(from: date)
  }
}
