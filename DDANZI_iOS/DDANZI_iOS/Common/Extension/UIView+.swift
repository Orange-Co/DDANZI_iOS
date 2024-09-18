//
//  UIView+.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/13/24.
//

import UIKit

extension UIView {
  
  enum VerticalLocation {
    case bottom
    case top
    case left
    case right
  }
  
  func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.8, radius: CGFloat = 5.0) {
    switch location {
    case .bottom:
      addShadow(offset: CGSize(width: 0, height: 10), color: color, opacity: opacity, radius: radius)
    case .top:
      addShadow(offset: CGSize(width: 0, height: -10), color: color, opacity: opacity, radius: radius)
    case .left:
      addShadow(offset: CGSize(width: -10, height: 0), color: color, opacity: opacity, radius: radius)
    case .right:
      addShadow(offset: CGSize(width: 10, height: 0), color: color, opacity: opacity, radius: radius)
    }
  }
  
  func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.1, radius: CGFloat = 3.0) {
    self.layer.masksToBounds = false
    self.layer.shadowColor = color.cgColor
    self.layer.shadowOffset = offset
    self.layer.shadowOpacity = opacity
    self.layer.shadowRadius = radius
  }
  
  func makeCornerRound(radius: CGFloat) {
    layer.cornerRadius = radius
    layer.masksToBounds = true
  }
  
  func makeBorder(width: CGFloat, color: UIColor) {
    layer.borderWidth = width
    layer.borderColor = color.cgColor
  }
  
  func addSubviews(_ views: UIView...) {
    views.forEach {
      self.addSubview($0)
    }
  }
  
  // 원하는 모서리에만 CornerRadius 주기
  func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
    clipsToBounds = true
    layer.cornerRadius = cornerRadius
    layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
  }
  
  // UIView를 UIImage로 변환하는 확장 메서드
  func asImage() -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
    defer { UIGraphicsEndImageContext() }
    guard let context = UIGraphicsGetCurrentContext() else { return nil }
    layer.render(in: context)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    return image
  }
  
  // 토스트 메세지
  func showToast(message: String, at: CGFloat = 25) {
    let toastLabel = UILabel()
    toastLabel.backgroundColor = UIColor(hex: "343A40", alpha: 0.9)
    toastLabel.textColor = .white
    toastLabel.textAlignment = .center
    toastLabel.font = .body6M12
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 8
    toastLabel.clipsToBounds = true
    
    let toastWidth = 253
    let toastHeight = 42
    let xPosition = self.frame.size.width / 2 - CGFloat(toastWidth / 2)
    let yPosition = self.frame.size.height - CGFloat(toastHeight) - at
    toastLabel.frame = CGRect(x: xPosition, y: yPosition, width: CGFloat(toastWidth), height: CGFloat(toastHeight))
    
    if let windowScene = UIApplication.shared.connectedScenes
      .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
       let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
      window.addSubview(toastLabel)
    }
    
    // 애니메이션 부분을 분리하여 명확하게 작성
    UIView.animate(
      withDuration: 3.0,
      delay: 0.1,
      options: .curveEaseOut,
      animations: {
        toastLabel.alpha = 0.0
      },
      completion: { _ in
        toastLabel.removeFromSuperview()
      }
    )
  }
  
  
  /// Border를 점선으로 처리해주는 함수
  func addDottedBorder(color: UIColor) {
    let dottedBorderLayer = CAShapeLayer()
    dottedBorderLayer.strokeColor = color.cgColor
    dottedBorderLayer.lineWidth = 1
    
    // 점선 스타일 설정
    dottedBorderLayer.lineDashPattern = [3, 3]
    dottedBorderLayer.fillColor = nil
    
    let path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius)
    dottedBorderLayer.path = path.cgPath
    
    layer.addSublayer(dottedBorderLayer)
  }
  
  func setBackgroundImageWithScaling(image: UIImage) {
    let backgroundImageView = UIImageView(image: image)
    backgroundImageView.contentMode = .scaleAspectFit
    
    addSubview(backgroundImageView)
    backgroundImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  func addBottomBorderWithColor(color: UIColor) {
    let border = CALayer()
    border.backgroundColor = color.cgColor
    border.frame = CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: 1)
    self.layer.addSublayer(border)
  }
  
  func addAboveTheBottomBorderWithColor(color: UIColor) {
    let border = CALayer()
    border.backgroundColor = color.cgColor
    border.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
    self.layer.addSublayer(border)
  }
  
  // 그라데이션 배경 적용
  func applyGradientBackground(topColor: UIColor, bottomColor: UIColor, startPointX: Double = 0.0, startPointY: Double = 0.0, endPointX: Double = 1.0, endPointY: Double = 1.0) {
    
    removeGradientBackground()
    
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = bounds
    gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
    gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
    gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
    layer.insertSublayer(gradientLayer, at: 0)
  }
  
  func removeGradientBackground() {
    if let gradientLayer = layer.sublayers?.first(where: { $0 is CAGradientLayer }) {
      gradientLayer.removeFromSuperlayer()
    }
  }
  
  func findViewController() -> UIViewController? {
    if let nextResponder = self.next as? UIViewController {
      return nextResponder
    } else if let nextResponder = self.next as? UIView {
      return nextResponder.findViewController()
    } else {
      return nil
    }
  }
}
