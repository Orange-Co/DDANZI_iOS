//
//  UIWindow+.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/4/24.
//

import UIKit

/// 가장 상위의 `UIWindow`를 반환
/// guard let window = UIWindow.key else { return }
/// window.addSubview(loadingView)
extension UIWindow {
  /// 찾지 못하였을 경우 `nil`을 반환합니다.
  public static var key: UIWindow? {
    return UIApplication.shared.connectedScenes
      .filter { $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive }
      .first(where: { $0 is UIWindowScene })
      .flatMap({ $0 as? UIWindowScene })?.windows
      .first(where: \.isKeyWindow)
  }
}
