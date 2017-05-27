//
//  UIViewController+hideKeyboardOnTapOutside.swift
//  SportUp
//
//  Created by Алексей on 30.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
  func hideKeyboardOnTapOutside(view: UIView? = nil) {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    let view = view ?? self.view
    view?.addGestureRecognizer(tap)
  }

  func dismissKeyboard() {
    view.endEditing(true)
  }
}
