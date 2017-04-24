//
//  RootMainMenuNavigationController.swift
//  pestle
//
//  Created by Алексей on 23.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import UIKit
import SideMenu

class RootSideMenuNavigationController: UISideMenuNavigationController {
  override func viewDidLoad() {
    SideMenuManager.menuRightNavigationController = self
    navigationBar.isHidden = true
  }
}
