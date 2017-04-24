//
//  BouquetPackageTableViewCell.swift
//  pestle
//
//  Created by Алексей on 23.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import UIKit

class BouquetQuantityTableViewCell: UITableViewCell {
  @IBOutlet weak var quantityField: UITextField!

  var quantity: Int {
    get {
      return Int(quantityField.text ?? "") ?? 0
    }
    set {
      quantityField.text = "\(quantity)"
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    quantityField.delegate = self
  }

}

extension BouquetQuantityTableViewCell: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.endEditing(true)
    return true
  }
}
