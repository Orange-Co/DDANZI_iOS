//
//  OptionCheckDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/9/24.
//

import Foundation

struct OptionCheckDTO: Codable {
  let address: String
  let detailAddress: String
  let zipCode: String
  let recipient: String
  let recipientPhone: String
  let selectedOptionList: [selectedOption]
}

struct selectedOption: Codable {
  let option: String
  let selectedOption: String
}
