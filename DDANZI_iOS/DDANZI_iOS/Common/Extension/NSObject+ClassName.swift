//
//  NSObject+ClassName.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/10/24.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
