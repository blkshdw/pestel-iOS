//
//  BouquetFlowerCollectionViewCell.swift
//  pestle
//
//  Created by Алексей on 23.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import UIKit

class BouquetFlowerCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var bouquetImageView: UIImageView!
  @IBOutlet weak var bouquetTitleLabel: UILabel!
  @IBOutlet weak var bouquetDescriptionLabel: UILabel!
  @IBOutlet weak var iconCheckImageView: UIImageView!

  func configure(flower: Flower) {
    bouquetTitleLabel.text = flower.name
    bouquetDescriptionLabel.text = flower.price.currencyString
    
  }
}
