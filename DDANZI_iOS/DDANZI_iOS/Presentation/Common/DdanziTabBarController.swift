//
//  DdanziTabBarController.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/16/24.
//

import UIKit

class DdanziTabBarController: UITabBarController {
    private var tabs: [UIViewController] = []
    private let tabBarHeight: CGFloat = 100

    private let homeViewController = HomeViewController()
    let mypageViewController  = MyPageViewController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.delegate = self
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var tabBarFrame = self.tabBar.frame
        tabBarFrame.size.height = tabBarHeight
        tabBarFrame.origin.y = self.view.frame.size.height - tabBarHeight
        self.tabBar.frame = tabBarFrame
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarItems()
        setTabBarAppearance()
    }
    
    func setTabBarItems() {
        tabs = [
            UINavigationController(rootViewController: homeViewController),
            UINavigationController(rootViewController: mypageViewController)
        ]
        
        TabBarItem.allCases.forEach {
            tabs[$0.rawValue].tabBarItem = $0.asTabBarItem()
            tabs[$0.rawValue].tabBarItem.tag = $0.rawValue
        }
        
        setViewControllers(tabs, animated: true)
    }
    
    func setTabBarAppearance() {
        tabBar.backgroundColor = .black
        tabBar.tintColor = .white
        tabBar.barTintColor = .black
    
        tabBar.roundCorners(cornerRadius: 10, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        
        let myFont = UIFont(name: "Pretendard-Bold", size: 10.0)!
        let fontAttributes = [NSAttributedString.Key.font: myFont]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
        
    }
}

extension DdanziTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if let selectedViewController = tabBarController.selectedViewController {
            let myFont = UIFont(name: "Pretendard-Bold", size: 10.0)!
            let selectedFontAttributes = [NSAttributedString.Key.font: myFont]
            selectedViewController.tabBarItem.setTitleTextAttributes(selectedFontAttributes, for: .normal)
        }
        
        for (index, controller) in tabBarController.viewControllers!.enumerated() {
            if let tabBarItem = controller.tabBarItem {
                if index != tabBarController.selectedIndex {
                    let myFont = UIFont(name: "Pretendard-Medium", size: 10.0)!
                    let defaultFontAttributes = [NSAttributedString.Key.font: myFont]
                    tabBarItem.setTitleTextAttributes(defaultFontAttributes, for: .normal)
                }
            }
        }
        
        let selectedIndex = tabBarController.selectedIndex
        switch selectedIndex {
        case 0:
            tabBar.items?[0].imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case 1:
            tabBar.items?[0].imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            tabBar.items?[0].imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
}
