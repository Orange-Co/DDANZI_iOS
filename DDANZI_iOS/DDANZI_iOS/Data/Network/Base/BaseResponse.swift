//
//  BaseResponse.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/18/24.
//

import Foundation


struct BaseResponse<T: Codable>: Codable {
  var status: Int
  var message: String
  var data: T?
}
