//
//  BouquetItemInfoViewController.swift
//  pestle
//
//  Created by Алексей on 23.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import UIKit

class BouquetItemInfoViewController: UIViewController {
  @IBOutlet weak var bouquetImageView: UIImageView!
  @IBOutlet weak var bouquetDescriptionLabel: UILabel!
  @IBOutlet weak var totalPriceLabel: UILabel!
  @IBOutlet weak var quantityLabel: UILabel!
  @IBOutlet weak var deleteButton: GoButton!
  @IBOutlet weak var saveButton: GoButton!
  @IBOutlet weak var buttonsStackView: UIStackView!
  @IBOutlet weak var tableView: UITableView!

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
    case addItem(Bouquet)
    case editItem(OrderBouquet)

    var bouquet: Bouquet {
      switch self {
      case .addItem(let bouquet):
        return bouquet
      case .editItem(let orderBouquet):
        return orderBouquet.bouquet
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

  func navigationLeftButtonDidTap() {
    dismiss(animated: true, completion: nil)
  }

  @IBAction func saveButtonDidTap(_ sender: Any) {
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
    guard let index = OrderManager.instance.bouquets.index(where: { $0.bouquet.id == screenType.bouquet.id }) else { return }
    OrderManager.instance.bouquets.remove(at: index)
    dismiss(animated: true, completion: nil)
  }

  @IBAction func plusButtonDidTap(_ sender: UIButton) {
    quantity += 1
  }


  @IBAction func minusButtonDidTap(_ sender: UIButton) {
    quantity -= 1
  }

}

extension BouquetItemInfoViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 0
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }
}
