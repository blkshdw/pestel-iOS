//
//  BouqetCollectionViewCell.swift
//  pestle
//
//  Created by Алексей on 23.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class BouquetCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var bouquetImageView: UIImageView!
  @IBOutlet weak var bouquetTitleLabel: UILabel!
  @IBOutlet weak var bouquetDescriptionLabel: UILabel!
  @IBOutlet weak var iconCheckImageView: UIImageView!
  
  func configure(bouquet: Bouquet, isOrdered: Bool = false) {
    iconCheckImageView.isHidden = !isOrdered
    iconCheckImageView.isHighlighted = isOrdered
    bouquetTitleLabel.text = bouquet.name
    bouquetDescriptionLabel.text = bouquet.price.currencyString
    bouquetImageView.kf.setImage(with: bouquet.image)
  }
}
