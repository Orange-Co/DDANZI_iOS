//
//  CustomNavigationBarView.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/15/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

///네비게이션 버튼 유형 :
@frozen
enum NavigationBarType {
  case normal
  case home
  case cancel
  case search
  case setting
  case searching
  case logo
  case none
}

final class CustomNavigationBarView: UIView {
  // MARK: - properties
  private var navigationType: NavigationBarType = .normal
  
  private let disposeBag = DisposeBag()
  
  private let backButtonSubject = PublishSubject<Void>()
  private let cancelButtonSubject = PublishSubject<Void>()
  private let homeButtonSubject = PublishSubject<Void>()
  private let searchButtonSubject = PublishSubject<Void>()
  private let settingButtonSubject = PublishSubject<Void>()
  private let alarmButtonSubject = PublishSubject<Void>()
  private let searchBarSubject = PublishSubject<Void>()
  
  var backButtonTap: Observable<Void> { backButtonSubject.asObservable() }
  var cancelButtonTap: Observable<Void> { cancelButtonSubject.asObservable() }
  var homeButtonTap: Observable<Void> { homeButtonSubject.asObservable() }
  var searchButtonTap: Observable<Void> { searchButtonSubject.asObservable() }
  var settingButtonTap: Observable<Void> { settingButtonSubject.asObservable() }
  var searchBarTextEdit: Observable<Void> { searchBarSubject.asObservable() }
  var alarmButtonTap: Observable<Void> { alarmButtonSubject.asObservable() }
  
  // MARK: - componenets
  private var leftView = UIView(frame: .init(x: 0, y: 0, width: 25, height: 25))
  private var subView = UIView(frame: .init(x: 0, y: 0, width: 25, height: 25))
  private var rightView = UIView(frame: .init(x: 0, y: 0, width: 25, height: 25))
  
  private let titleLabel = UILabel().then {
    $0.text = ""
    $0.font = .body2Sb18
    $0.textColor = .black
  }
  
  private let backButton = UIButton().then {
    $0.setImage(.leftBtn, for: .normal)
    $0.imageView?.contentMode = .scaleAspectFit
  }
  
  private let cancelButton = UIButton().then {
    $0.setImage(.icCancel, for: .normal)
    $0.imageView?.contentMode = .scaleAspectFit
  }
  
  private let homeButton = UIButton().then {
    $0.setImage(.home, for: .normal)
    $0.imageView?.contentMode = .scaleAspectFit
  }
  
  private let alarmButton = UIButton().then {
    $0.setImage(.alarm, for: .normal)
    $0.imageView?.contentMode = .scaleAspectFit
  }
  
  private let logoButton = UIImageView().then {
    $0.image = .logo
    $0.contentMode = .scaleAspectFit
  }
  
  private let searchButton = UIButton().then {
    $0.setImage(.icSearch, for: .normal)
    $0.imageView?.contentMode = .scaleAspectFit
  }
  
  private let settingButton = UIButton().then {
    $0.setImage(.icSetting, for: .normal)
    $0.imageView?.contentMode = .scaleAspectFit
  }
  
  let searchTextField = UISearchTextField().then {
    $0.placeholder = "상품을 검색해보세요"
  }
  
  // MARK: - init
  init(navigationBarType: NavigationBarType, title: String = "") {
    super.init(frame: .zero)
    self.backgroundColor = .white
    self.titleLabel.text = title
    self.navigationType = navigationBarType
    setUI()
    bindButtons()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: Layout Helper
  private func setUI() {
    setHierarchy()
    setConstraints()
  }
  
  private func setHierarchy() {
    self.addSubviews(leftView, titleLabel, rightView, subView)
    
    switch navigationType {
    case .normal:
      leftView.addSubview(backButton)
      
      backButton.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    case .home:
      leftView.addSubview(backButton)
      rightView.addSubview(homeButton)
      backButton.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
      
      homeButton.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
      
    case .cancel:
      rightView.addSubview(cancelButton)
      
      cancelButton.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
      
    case .search:
      leftView.addSubview(logoButton)
      subView.addSubview(searchButton)
      rightView.addSubview(alarmButton)
      
      alarmButton.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
      
      logoButton.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
      
      searchButton.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    case .setting:
      rightView.addSubview(settingButton)
      settingButton.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
      
    case .searching:
      leftView.addSubview(backButton)
      backButton.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
      self.addSubviews(searchTextField)
      searchTextField.snp.makeConstraints {
        $0.centerY.equalToSuperview()
        $0.leading.equalTo(leftView.snp.trailing).offset(10.adjusted)
        $0.trailing.equalToSuperview().inset(20.adjusted)
        $0.height.equalTo(30)
      }
    case .logo:
      leftView.addSubview(logoButton)
      logoButton.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    case .none:
      break
    }
  }
  
  private func setConstraints() {
    self.snp.makeConstraints {
      $0.height.equalTo(58.adjusted)
    }
    
    leftView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(20.adjusted)
      $0.height.equalTo(20)
    }
    
    subView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalTo(rightView.snp.leading).offset(-10.adjusted)
      $0.size.equalTo(20)
    }
    
    rightView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().inset(20.adjusted)
      $0.height.equalTo(20)
    }
    
    titleLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalTo(leftView.snp.centerY)
      $0.height.equalTo(20)
    }
    
  }
  
  // MARK: - Bind Buttons
  private func bindButtons() {
    backButton.rx.tap
      .observe(on: MainScheduler.instance) // 메인 스레드에서 작업 실행
      .bind(to: backButtonSubject)
      .disposed(by: disposeBag)

    cancelButton.rx.tap
      .observe(on: MainScheduler.instance) // 메인 스레드에서 작업 실행
      .bind(to: cancelButtonSubject)
      .disposed(by: disposeBag)

    homeButton.rx.tap
      .observe(on: MainScheduler.instance) // 메인 스레드에서 작업 실행
      .bind(to: homeButtonSubject)
      .disposed(by: disposeBag)

    searchButton.rx.tap
      .observe(on: MainScheduler.instance) // 메인 스레드에서 작업 실행
      .bind(to: searchButtonSubject)
      .disposed(by: disposeBag)

    settingButton.rx.tap
      .observe(on: MainScheduler.instance) // 메인 스레드에서 작업 실행
      .bind(to: settingButtonSubject)
      .disposed(by: disposeBag)

    alarmButton.rx.tap
      .observe(on: MainScheduler.instance) // 메인 스레드에서 작업 실행
      .bind(to: alarmButtonSubject)
      .disposed(by: disposeBag)
  }
}
