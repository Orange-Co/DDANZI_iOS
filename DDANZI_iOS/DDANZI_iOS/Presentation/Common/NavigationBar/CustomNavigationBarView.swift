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
}

final class CustomNavigationBarView: UIView {
    // MARK: - properties
    private var navigationType: NavigationBarType = .normal
    
    private let disposeBag = DisposeBag()
    
    private let backButtonSubject = PublishSubject<Void>()
    private let cancelButtonSubject = PublishSubject<Void>()
    private let homeButtonSubject = PublishSubject<Void>()
    private let logoButtonSubject = PublishSubject<Void>()
    private let searchButtonSubject = PublishSubject<Void>()
    private let searchBarSubject = PublishSubject<Void>()
    
    var backButtonTap: Observable<Void> { backButtonSubject.asObservable() }
    var cancelButtonTap: Observable<Void> { cancelButtonSubject.asObservable() }
    var homeButtonTap: Observable<Void> { homeButtonSubject.asObservable() }
    var logoButtonTap: Observable<Void> { logoButtonSubject.asObservable() }
    var searchButtonTap: Observable<Void> { searchButtonSubject.asObservable() }
    var searchBarTextEdit: Observable<Void> { searchBarSubject.asObservable() }
    
    // MARK: - componenets
    private var leftView = UIView(frame: .init(x: 0, y: 0, width: 25, height: 25))
    private var rightView = UIView(frame: .init(x: 0, y: 0, width: 25, height: 25))
    
    private let titleLabel = UILabel().then {
        $0.text = ""
        $0.font = .body2Sb18
        $0.textColor = .black
    }
    
    private let backButton = UIButton().then {
        $0.setImage(.leftBtn, for: .normal)
    }
    
    private let cancelButton = UIButton().then {
        $0.setImage(.icCancel, for: .normal)
    }
    
    private let homeButton = UIButton().then {
        $0.setImage(.home, for: .normal)
    }
    
    private let logoButton = UIButton().then {
        $0.setTitle("LOGO", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    private let searchButton = UIButton().then {
        $0.setImage(.icSearch, for: .normal)
    }
    
    private let settingButton = UIButton().then {
        $0.setImage(.icSetting, for: .normal)
    }
    
    let searchTextField = UISearchTextField()
    
    // MARK: - init
    init(navigationBarType: NavigationBarType, title: String = "") {
        super.init(frame: .zero)
        self.backgroundColor = .white
        self.navigationType = navigationBarType
        self.titleLabel.text = title
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
        self.addSubviews(leftView, titleLabel, rightView)
        
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
            rightView.addSubview(searchButton)
            
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
                $0.top.equalTo(leftView.snp.top)
                $0.leading.equalTo(leftView.snp.trailing).offset(10)
                $0.trailing.equalToSuperview().inset(20)
            }
        case .logo:
            leftView.addSubview(logoButton)
            logoButton.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    private func setConstraints() {
        self.snp.makeConstraints {
            $0.height.equalTo(110)
        }
        
        leftView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(26)
            $0.leading.equalToSuperview().offset(20)
            $0.size.equalTo(25)
        }
        
        rightView.snp.makeConstraints {
            $0.centerY.equalTo(leftView.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(25)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(leftView.snp.centerY)
        }

    }
    
    // MARK: - Bind Buttons
    private func bindButtons() {
        backButton.rx.tap
            .bind(to: backButtonSubject)
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .bind(to: cancelButtonSubject)
            .disposed(by: disposeBag)
        
        homeButton.rx.tap
            .bind(to: homeButtonSubject)
            .disposed(by: disposeBag)
        
        logoButton.rx.tap
            .bind(to: logoButtonSubject)
            .disposed(by: disposeBag)
        
        searchButton.rx.tap
            .bind(to: searchButtonSubject)
            .disposed(by: disposeBag)
        
    
    }
    
}
