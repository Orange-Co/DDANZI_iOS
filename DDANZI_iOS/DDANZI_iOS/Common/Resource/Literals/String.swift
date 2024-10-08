//
//  String.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/18/24.
//

import Foundation

enum StringLiterals {
    
    enum TabBar {
        enum ItemTitle {
            static let home = "홈"
            static let myPage = "마이페이지"
        }
    }
    
    enum ProductDetail {
        enum Label {
            static let remainLabel = "남은 재고"
        }
        enum Button{
            static let morelinkButtonText = "이 상품에 대한 자세한 정보를 보고 싶다면?"
        }
        enum Option{
            static let optionTitle = "원하는 옵션을 선택해주세요"
            static let moreButtonText = "이 상품에 대한 자세한 정보를 보고 싶다면?"
            static let optionCaptionText = "* 각인 옵션은 사용할 수 없습니다."
        }
    }
  
  enum Link {
    enum Terms {
      static let privacy = "https://www.notion.so/5a8b57e78f594988aaab08b8160c3072?pvs=4"
      static let serviceTerm = "https://www.notion.so/faa1517ffed44f6a88021a41407ed736?pvs=4"
      static let sellTerm = "https://brawny-guan-098.notion.site/6d77260d027148ceb0f806f0911c284a?pvs=4"
      static let purchaseTerm = "https://brawny-guan-098.notion.site/56bcbc1ed0f3454ba08fa1070fa5413d?pvs=4"
    }
  }
}
