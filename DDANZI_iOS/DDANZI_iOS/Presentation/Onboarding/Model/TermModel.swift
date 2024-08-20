//
//  TermModel.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/20/24.
//

import Foundation

struct TermModel {
  let title: String
  let isRequired: Bool
  let moreLink: String?
  
  init(
    title: String,
    isRequired: Bool,
    moreLink: String? = nil
  ) {
    self.title = title
    self.isRequired = isRequired
    self.moreLink = moreLink
  }
}
