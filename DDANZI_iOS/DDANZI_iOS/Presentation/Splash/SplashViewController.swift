//
//  SplashViewController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/15/24.
//

import UIKit

import Lottie
import SnapKit

final class SplashViewController: UIViewController {
  
  let splashView = LottieAnimationView(name: "splash")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
    splashView.loopMode = .playOnce
    splashView.play()
  }
  
  private func setUI() {
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    view.backgroundColor = .black
    view.addSubview(splashView)
  }
  
  private func setConstraints() {
    splashView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(80)
    }
  }
}
