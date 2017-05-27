//
//  OrderContactDataContainerViewController.swift
//  pestle
//
//  Created by Алексей on 27.05.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

class OrderContactDataContainerViewController: UIViewController {
  var contactDataViewController: OrderContactDataViewController? = nil

  @IBOutlet weak var orderConfirmButton: GoButton!

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "embed", let viewController = segue.destination as? OrderContactDataViewController else { return }
    self.contactDataViewController = viewController
  }

  override func viewDidLoad() {
    orderConfirmButton.setTitle("Оплатить: \(OrderManager.instance.price.currencyString)", for: .normal)
  }

  
  @IBAction func confirmOrderButtonDidTap(_ sender: Any) {
    guard let contactDataViewController = contactDataViewController else { return }
    if !contactDataViewController.form.validate().isEmpty {
      let alert = UIAlertController(title: "Ошибка", message: "Пожалуйста, заполните все необходимые поля", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
      present(alert, animated: true, completion: nil)
      return
    }
    contactDataViewController.updateProfile().then {
      OrderManager.instance.createOrder().then { _ -> Void in
        let alertController = UIAlertController(title: "Заказ оформлен", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
      }
    }
  }
}
