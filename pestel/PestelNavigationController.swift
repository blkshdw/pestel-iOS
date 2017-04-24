//
//  PestelNavigationController.swift
//  pestle
//
//  Created by Алексей on 24.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import UIKit

protocol DefaultBarStyleViewController { }
protocol SelfControlledBarStyleViewController { }

class PestelNavigationController: UINavigationController, UINavigationControllerDelegate {

  let defaultBarTintColor = UIColor.white

  override func loadView() {
    super.loadView()
    delegate = self
    navigationBar.isTranslucent = false
    view.backgroundColor = UIColor.white
    navigationBar.barStyle = .default
    navigationBar.tintColor = .black
    navigationBar.setBackgroundImage(UIImage(), for: .default)
    //navigationBar.shadowImage = UIImage()
    navigationBar.backgroundColor = defaultBarTintColor
    navigationBar.barTintColor = defaultBarTintColor
    navigationBar.titleTextAttributes =
      [NSFontAttributeName: UIFont.systemFont(ofSize: 17)]
  }  
}
