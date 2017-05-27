//
//  BadgeButonView.swift
//  pestle
//
//  Created by Алексей on 27.05.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import UIKit

class BadgeButtonView: UIView {
  @IBOutlet weak var button: UIButton!
  @IBOutlet weak var badgeView: UIView!
  @IBOutlet weak var badgeLabel: UILabel!

  var didTap: (() -> Void)? = nil

  @IBAction func headerViewDidTap(_ sender: Any) {
    didTap?()
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    let image = #imageLiteral(resourceName: "iconCart").withRenderingMode(.alwaysTemplate)
    button.setImage(image, for: .normal)
    button.tintColor = UIColor.black
  }

  @IBAction func handleLongPressGesture(_ sender: UILongPressGestureRecognizer) {
    switch sender.state {
    case .began:
      button.isHighlighted = true
    case .ended:
      didTap?()
      button.isHighlighted = false
    case .cancelled:
      button.isHighlighted = false
    default:
      break
    }
  }
}
