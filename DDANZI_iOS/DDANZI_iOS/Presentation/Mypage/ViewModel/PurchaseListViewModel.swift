//
//  PurchaseListViewModel.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/10/24.
//

import Foundation

import RxSwift
import RxCocoa

final class PurchaseListViewModel {
  let disposeBag = DisposeBag()
  
  // Input
  let editModeTapped = PublishRelay<Void>()
  
  // Output
  let isEditMode: BehaviorRelay<Bool>
  let products: BehaviorRelay<[ProductModel]>
  
  init(products: [ProductModel]) {
    self.products = BehaviorRelay(value: products)
    self.isEditMode = BehaviorRelay(value: false)
    
    editModeTapped
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        self.isEditMode.accept(!self.isEditMode.value)
      })
      .disposed(by: disposeBag)
  }
}
