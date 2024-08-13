//
//  OptionDataSource.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/14/24.
//

import Foundation

import RxDataSources
import RxSwift
import RxCocoa

//// Define the item model
//struct Item: Hashable {
//  let id: UUID
//  let title: String
//}
//
//// Define the section model
//struct OptionSectionModel {
//  let title: String
//  var items: [Item]
//}
//
//// Conform SectionModel to SectionModelType for RxDataSources
//extension OptionSectionModel: SectionModelType {
//  typealias ItemType = Item
//  
//  init(original: OptionSectionModel, items: [ItemType]) {
//    self = original
//    self.items = items
//  }
//}
//
//
//struct OptionItem: Hashable {
//    let id = UUID()
//    var title: String
//    var subItems: [OptionItem]
//    var item: AnyHashable?
//}
//
//
//struct Option: Hashable {
//    let id = UUID()
//    var title: String
//    var isSelected: Bool
//}

import RxDataSources

struct OptionSectionModel {
    var header: String
    var items: [OptionDetailList]
}

extension OptionSectionModel: SectionModelType {
    typealias Item = OptionDetailList
    
    init(original: OptionSectionModel, items: [OptionDetailList]) {
        self = original
        self.items = items
    }
}
