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
    private let disposeBag = DisposeBag()
    /// BehaviorRelay는 변경 가능한 상태를 나타내며, 기본값을 가질 수 있습니다.
    let sections = BehaviorRelay<[OptionSectionModel]>(value: [])
    
    init() {
        sections.accept([
            OptionSectionModel(isExpanded: false, items: ["Item 1", "Item 2"]),
            OptionSectionModel(isExpanded: false, items: ["Item 3", "Item 4"])
        ])
    }
    
    func toggleSection(at index: Int) {
        var currentSections = sections.value
        currentSections[index].isExpanded.toggle()
        sections.accept(currentSections)
    }
}
