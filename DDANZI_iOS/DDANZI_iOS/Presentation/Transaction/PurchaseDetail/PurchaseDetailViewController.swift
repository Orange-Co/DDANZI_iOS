//
//  PurchaseDetailViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/10/24.
//

import UIKit

final class PurchaseDetailViewController: UIViewController {
  
  private let statusView = StatusView(title: "배송 중",
                                      code: "RDAFSD391480")
  
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .white
  }
  
  private let bottomButtonView = UIView().then {
    $0.backgroundColor = .white
    $0.addShadow(offset: .init(width: 0, height: 2))
  }
  
  

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
}
