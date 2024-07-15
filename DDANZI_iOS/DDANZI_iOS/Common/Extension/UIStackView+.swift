//
//  UIStackView+.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/10/24.
//

import UIKit

extension UIStackView {
  /// SwifterSwift: Adds array of views to the end of the arrangedSubviews array.
  ///
  /// - Parameter views: views array.
  func addArrangedSubviews(_ views: UIView...) {
    views.forEach({
      addArrangedSubview($0)
    })
  }

  /// SwifterSwift: Removes all views in stack’s array of arranged subviews.
  func removeArrangedSubviews() {
      for view in arrangedSubviews {
          removeArrangedSubview(view)
      }
  }
}
