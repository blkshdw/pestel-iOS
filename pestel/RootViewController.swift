//
//  RootViewController.swift
//  pestle
//
//  Created by Алексей on 23.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import UIKit
import SideMenu

class RootViewController: PestelNavigationController {
  static var instance: RootViewController!
  let sideMenuVC = RootSideMenuNavigationController(rootViewController: RootSideMenuViewController.storyboardInstance()!)

  override func viewDidLoad() {
    RootViewController.instance = self
    let isLoaded: Bool = StorageHelper.loadObjectForKey(.isLoaded) ?? false
    guard !isLoaded else {
      return configureSideMenu()
    }
    setViewControllers([OnboardingViewController.storyboardInstance()!], animated: true)
  }

  func configureSideMenu() {
    SideMenuManager.menuLeftNavigationController = sideMenuVC
    SideMenuManager.menuRightNavigationController = nil
    SideMenuManager.menuAddPanGestureToPresent(toView: navigationBar)
    SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: view)
    SideMenuManager.menuAnimationBackgroundColor = UIColor.clear
    SideMenuManager.menuPresentMode = .menuSlideIn
    SideMenuManager.menuAllowPushOfSameClassTwice = false
    setViewControllers([BouquetsCollectionViewController.storyboardInstance()!], animated: true)
  }
}
