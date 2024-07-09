//
//  PurchaseSectionModel.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/9/24.
//

import Foundation

import RxDataSources

struct PurchaseSectionModel {
  var items: [Item]
}

extension PurchaseSectionModel: SectionModelType {
  typealias Item = ProductModel

  init(original: PurchaseSectionModel, items: [ProductModel]) {
    self = original
    self.items = items
  }
  
}
