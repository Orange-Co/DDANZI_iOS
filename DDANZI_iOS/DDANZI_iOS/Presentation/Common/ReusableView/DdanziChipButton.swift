//
//  DdanziChipButton.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/9/24.
//

import UIKit

final class DdanziChipButton: UIButton {
  init (title: String) {
    super.init(frame: .init(x: 0, y: 0, width: 0, height: 22))
    configureButton(title: title)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureButton(title: String) {
    var config = UIButton.Configuration.plain()
    
    config.title = title
    
    config.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 15, bottom: 7, trailing: 15)
    
    config.baseForegroundColor = .gray3
    config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
      var outgoing = incoming
      outgoing.font = .body6M12
      return outgoing
    }
    
    config.background.backgroundColor = .white
    config.background.strokeColor = .gray3
    config.background.strokeWidth = 1
    config.background.cornerRadius = 11 
    
    self.configuration = config
  }
}
