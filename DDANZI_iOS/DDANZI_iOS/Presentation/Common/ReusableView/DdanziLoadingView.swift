//
//  DdanziLoadingView.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/4/24.
//

import UIKit

import Lottie
import SnapKit
import Then

final class DdanziLoadingView: UIView {

  // 싱글톤 인스턴스
  public static let shared = DdanziLoadingView()

  private var isIndicatorShow: Bool = false

  private let lottieView: LottieAnimationView = .init(name: "loading")
  private let dimView = UIView().then {
    $0.backgroundColor = .black.withAlphaComponent(0.4)
  }

  // private init으로 외부에서 새로운 인스턴스 생성 방지
  private init() {
    super.init(frame: .zero)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setUI() {
    setHierarchy()
    setConstraints()
  }

  private func setHierarchy() {
    dimView.addSubview(lottieView)
  }

  private func setConstraints() {
    dimView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    lottieView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.size.equalTo(130)
    }
  }

  func startAnimating() {
    if isIndicatorShow {
      stopAnimating()
    }

    guard let window = UIWindow.key else { return }

    window.addSubview(dimView)
    window.bringSubviewToFront(dimView)
    dimView.addSubview(lottieView)

    setConstraints()
    isIndicatorShow = true

    lottieView.play()
    lottieView.loopMode = .loop
  }

  func stopAnimating() {
    if isIndicatorShow {
      isIndicatorShow = false
      lottieView.stop()
      dimView.removeFromSuperview()
    }
  }
}
