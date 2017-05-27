//
//  BouquetPreviewTableHeaderView.swift
//  pestle
//
//  Created by Алексей on 03.05.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import UIKit

class BouquetPreviewTableHeaderView: UIView {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var addButton: UIButton!

  var addButtonTapHandler: (() -> Void)? = nil
  
  @IBAction func addButtonDidTap(_ sender: Any) {
    addButtonTapHandler?()
  }
}
