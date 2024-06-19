//
//  ProductModel.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/18/24.
//

import Foundation
import RxCocoa
import RxDataSources

struct ProductDetailModel {
    let productTitle: String
    let discountRate: Int
    let price: Int
    let beforePrice: Int
    let remainAmount: Int
}

// RxDataSources 섹션 모델 정의
struct OptionSectionModel {
    var isExpanded: Bool
    var items: [String]
}

extension OptionSectionModel: SectionModelType {
    typealias Item = String
    
    
    init(original: OptionSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
