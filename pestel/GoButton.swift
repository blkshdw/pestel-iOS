//
//  GoButton.swift
//  pestle
//
//  Created by Алексей on 22.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class GoButton: UIButton {
  let animationDuration = 0.2

  @IBInspectable var defaultBackgroundColor: UIColor = UIColor.sportUpAquaMarine

  @IBInspectable var defaultDisabledColor: UIColor = UIColor.sportUpPaleGrey

  override var isEnabled: Bool {
    didSet {
      if isEnabled {
        backgroundColor = defaultBackgroundColor
      } else {
        backgroundColor = defaultDisabledColor
      }
    }
  }

  override var isHighlighted: Bool {
    didSet {
      if isHighlighted {
        self.backgroundColor = self.defaultBackgroundColor.darker()
      } else {
        UIView.animate(withDuration: animationDuration, animations: {
          self.backgroundColor = self.defaultBackgroundColor
        })
      }
    }
  }
  
}
