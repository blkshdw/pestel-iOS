//
//  OnboardingViewController.swift
//  pestle
//
//  Created by Алексей on 23.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import UIKit

class OnboardingViewController: UIViewController {

  @IBAction func makeOrderButtonDidTap(_ sender: GoButton) {
    try? StorageHelper.save(true, forKey: .isLoaded)
    RootViewController.instance.configureSideMenu()
  }
}
