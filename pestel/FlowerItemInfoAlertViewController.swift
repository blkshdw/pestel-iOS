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
  @IBOutlet weak var buttonsStackView: UIStackView!
  @IBOutlet weak var contentView: UIView!

  var dismissHandler: (() -> Void)? = nil

  var quantity: Int {
    get {
      return Int(quantityTextField.text ?? "") ?? 1
    }
    set {
      guard newValue > 0 else { return }
      quantityTextField.text = "\(newValue)"
      priceLabel.text = (Double(newValue) * self.screenType.flower.price).currencyString
    }
  }

  var bouquet: CustomOrderBouquet!

  enum ScreenType {
    case addItem(Flower)
    case editItem(CustomOrderBouquetItem)

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
    view.backgroundColor = UIColor(white: 0, alpha: 0.5)
    hideKeyboardOnTapOutside(view: contentView)
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconNavCanselBlack"), style: .plain, target: self, action: #selector(BouquetItemInfoViewController.navigationLeftButtonDidTap))
    let screenType = self.screenType!
    switch screenType {
    case .addItem(_):
      buttonsStackView.removeArrangedSubview(deleteButton)
      deleteButton.removeFromSuperview()
      addButton.setTitle("Добавить", for: .normal)
    case .editItem(let orderBouquet):
      quantity = orderBouquet.quantity
    }
    let flower = screenType.flower
    priceLabel.text = flower.price.currencyString
    flowerImageView.kf.setImage(with: flower.image)
    nameLabel.text = flower.name
    descriptionLabel.text = flower.description
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
      self?.view.alpha = 0
      self?.view.alpha = 1
    }
  }

  @IBAction func plusButtonDidTap(_ sender: Any) {
    quantity += 1
  }

  @IBAction func minusButtonDidTap(_ sender: Any) {
    quantity -= 1
  }


  @IBAction func addButtonDidTap(_ sender: Any) {
    let screenType = self.screenType!
    switch screenType {
    case .addItem(let flower):
      bouquet.flowers.append(CustomOrderBouquetItem(quantity: quantity, flower: flower))
    case .editItem(let bouquetItem):
      bouquetItem.quantity = quantity
    }
    dismiss()
  }

  @IBAction func deleteButtonDidTap(_ sender: Any) {
    let screenType = self.screenType!
    switch screenType {
    case .editItem(let bouquetItem):
      guard let index = bouquet.flowers.index(where: { $0.id == bouquetItem.id }) else { return }
      bouquet.flowers.remove(at: index)
    default:
      break
    }
    dismiss()
  }

  @IBAction func backgroundViewTapped(_ sender: Any) {
    dismiss()
  }

  func dismiss() {
    UIView.animate(withDuration: Constants.animationDuration, animations: { [weak self] in
      self?.view.alpha = 0
    }, completion: { [weak self] _ in
      self?.dismissHandler?()
      self?.dismiss(animated: false, completion: nil)
    })
  }
}

extension FlowerItemInfoAlertViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return touch.view == gestureRecognizer.view && touch.view != contentView
  }
}
