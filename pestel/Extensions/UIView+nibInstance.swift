//
//  UIView+nibInstance.swift
//  SportUp
//
//  Created by Алексей on 27.03.17.
//  Copyright © 2017 binaryblitz. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

  internal class var className: String {
    return String(describing: self)
  }

  internal class var classNamedNib: UINib? {
    return UINib(nibName: String(describing: self), bundle: nil)
  }

  internal class func getNibInstance<T:UIView>() -> T? {
    return classNamedNib?.instantiate(withOwner: nil, options: nil).first as? T
  }

  class func nibInstance() -> Self? {
    return getNibInstance()
  }
}
