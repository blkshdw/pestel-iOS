//
//  FlowerItemInfoAlertViewController.swift
//  pestle
//
//  Created by Алексей on 24.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import UIKit

class FlowerItemInfoAlertViewController: UIViewController {
  @IBOutlet weak var flowerImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var quantityTextField: UITextField!
  @IBOutlet weak var deleteButton: GoButton!
  @IBOutlet weak var addButton: GoButton!
/*
  var quantity: Int {
    get {
      return Int(quantityLabel.text ?? "") ?? 1
    }
    set {
      guard newValue > 0 else { return }
      quantityLabel.text = "\(newValue)"
      totalPriceLabel.text = (Double(newValue) * self.screenType.bouquet.price ).currencyString
    }
  }

  enum ScreenType {
    case addItem(Flower)
    case editItem(CustomOrderBouquetFlower)

    var flower: Flower {
      switch self {
      case .addItem(let flower):
        return flower
      case .editItem(let orderBouquetFlower):
        return orderBouquetFlower.flower
      }
    }
  }

  var screenType: ScreenType!

  override func viewDidLoad() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconNavCanselBlack"), style: .plain, target: self, action: #selector(BouquetItemInfoViewController.navigationLeftButtonDidTap))
    let screenType = self.screenType!
    switch screenType {
    case .addItem(_):
      buttonsStackView.removeArrangedSubview(deleteButton)
      deleteButton.removeFromSuperview()
      saveButton.setTitle("Добавить", for: .normal)
    case .editItem(let orderBouquet):
      quantity = orderBouquet.quantity
    }
    let bouquet = screenType.bouquet
    totalPriceLabel.text = bouquet.price.currencyString
    bouquetImageView.kf.setImage(with: bouquet.image)
    navigationItem.title = bouquet.name
    bouquetDescriptionLabel.text = bouquet.description
  }

  @IBAction func plusButtonDidTap(_ sender: Any) {
  }

  @IBAction func minusButtonDidTap(_ sender: Any) {
  }


  @IBAction func addButtonDidTap(_ sender: Any) {
    let screenType = self.screenType!
    switch screenType {
    case .addItem(let bouquet):
      OrderManager.instance.bouquets.append(OrderBouquet(bouquet: bouquet, quantity: self.quantity))
      dismiss(animated: true, completion: nil)
    default:
      break
    }
  }

  @IBAction func deleteButtonDidTap(_ sender: Any) {
  }
  */
}
