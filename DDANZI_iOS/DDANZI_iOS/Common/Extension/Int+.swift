//
//  Int+.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/9/24.
//

import Foundation

extension Int {
    func toKoreanWon() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        if let formattedNumber = numberFormatter.string(from: NSNumber(value: self)) {
            return "\(formattedNumber)원"
        } else {
            return "\(self)원"
        }
    }
}
