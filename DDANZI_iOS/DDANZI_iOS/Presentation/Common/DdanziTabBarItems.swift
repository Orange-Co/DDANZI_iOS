//
//  DdanziTabBarItems.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/16/24.
//

import UIKit

enum TabBarItem: Int, CaseIterable {
    case home
    case profile
}

extension TabBarItem {
    var title: String {
        switch self {
        case .home:
            return "홈"
        case .profile:
            return "프로필"
        }
    }
}

extension TabBarItem {
    var Icon: UIImage? {
        switch self {
        case .home:
            return .icHomeUnselect
        case .profile:
            return .icMypageEmpty
        }
    }
    
    var selectedIcon: UIImage? {
        switch self {
        case .home:
            return .icHome
        case .profile:
            return .icMypage
        }
    }
}

extension TabBarItem {
    public func asTabBarItem() -> UITabBarItem {
        let tabBarItem = UITabBarItem(
            title: title,
            image: Icon,
            selectedImage: selectedIcon
        )
        
        tabBarItem.imageInsets = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
        
        return tabBarItem
    }
}

