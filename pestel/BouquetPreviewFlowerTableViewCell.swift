//
//  BouquetPreviewFlowerTableViewCell.swift
//  pestle
//
//  Created by Алексей on 03.05.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import UIKit

class BouquetPreviewFlowerTableViewCell: UITableViewCell {
  @IBOutlet weak var flowerNameLabel: UILabel!
  @IBOutlet weak var flowerCountLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var flowerImageView: UIImageView!

  func configure(item: CustomOrderBouquetItem) {
    flowerNameLabel.text = item.flower.name
    flowerCountLabel.text = item.quantity.getRussianNumEnding(endings: ["цветок", "цветка", "цветков"])
    priceLabel.text = item.price.currencyString
  }

}
