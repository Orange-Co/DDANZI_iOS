//
//  OptionSelectViewModel.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/19/24.
//

import Foundation

import RxSwift
import RxCocoa

final class OptionSelectViewModel {
    let sections = BehaviorRelay(value: [
        SectionModel(isExpanded: false, items: ["S","M"]),
        SectionModel(isExpanded: false, items: ["색상 1", "색상 2"])
    ])
    
    func toggleSection(at index: Int) {
        var currentSections = sections.value
        currentSections[index].isExpanded.toggle()
        sections.accept(currentSections)
    }
}
