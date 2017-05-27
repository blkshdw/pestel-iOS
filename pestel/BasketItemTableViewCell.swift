//
//  BasketItemTableViewCell.swift
//  pestle
//
//  Created by Алексей on 05.05.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import UIKit


class BasketItemTableViewCell: UITableViewCell {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var flowerImageView: UIImageView!
  @IBOutlet weak var countLabel: UILabel!
  
  func configure(orderBouquet: OrderBouquet) {
    nameLabel.text = orderBouquet.bouquet.name
    descriptionLabel.text = orderBouquet.bouquet.description
    priceLabel.text = orderBouquet.price.currencyString
    countLabel.text = "\(orderBouquet.quantity!) шт"
  }

  func configure(customBouquet: CustomOrderBouquet, count: Int) {
    nameLabel.text = "Мой букет \(count)"
    var descriptionString = ""
    for (index, flowerItem) in customBouquet.flowers.enumerated() {
      descriptionString += "\(flowerItem.flower.name) \(flowerItem.quantity!) шт"
      if index < customBouquet.flowers.count - 1 {
        descriptionString += ", "
      }
    }
    descriptionLabel.text = descriptionString
    priceLabel.text = customBouquet.price.currencyString
    countLabel.text = "\(customBouquet.quantity!) шт"
  }
}
