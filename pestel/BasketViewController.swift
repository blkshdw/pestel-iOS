//
//  BasketViewController.swift
//  pestle
//
//  Created by Алексей on 05.05.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import UIKit

class BasketViewController: UIViewController {
  @IBOutlet weak var orderPriceLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var confirmOrderButton: GoButton!

  enum Sections: Int {
    case bouquets
    case customBouquets

    static let count = 2
  }

  var bouquets: [OrderBouquet] {
    return OrderManager.instance.bouquets
  }

  var customBouquets: [CustomOrderBouquet] {
    return OrderManager.instance.customBouquets
  }

  override func viewDidLoad() {
    tableView.tableFooterView = UIView()
    orderPriceLabel.text = OrderManager.instance.price.currencyString
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: #imageLiteral(resourceName: "iconNavCanselBlack"),
      style: .plain,
      target: self, action: #selector(BasketViewController.leftNavigationButtonDidTap)
    )
  }

  func leftNavigationButtonDidTap() {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func confirmOrderButtonTapped(_ sender: GoButton) {
    if ProfileManager.instance.isAuthorized {
      let contactDataVc = OrderContactDataContainerViewController.storyboardInstance()!
      navigationController?.pushViewController(contactDataVc, animated: true)
    } else {
      let viewController = RegistrationPhoneInputViewController.storyboardInstance()!
      viewController.finishRegistrationHandler = { [weak self] _ in
        let viewController = OrderContactDataContainerViewController.storyboardInstance()!
        self?.navigationController?.pushViewController(viewController, animated: true)
      }
      present(PestelNavigationController(rootViewController: viewController), animated: true, completion: nil)
    }
  }


  override func viewWillAppear(_ animated: Bool) {
    confirmOrderButton.isEnabled = !bouquets.isEmpty || !customBouquets.isEmpty
    tableView.reloadData()
  }
}

extension BasketViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return Sections.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case Sections.bouquets.rawValue:
      return OrderManager.instance.bouquets.count
    case Sections.customBouquets.rawValue:
      return OrderManager.instance.customBouquets.count
    default:
      return 0
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: BasketItemTableViewCell.className, for: indexPath) as! BasketItemTableViewCell
    switch indexPath.section {
    case Sections.bouquets.rawValue:
      cell.configure(orderBouquet: bouquets[indexPath.row])
    case Sections.customBouquets.rawValue:
      cell.configure(customBouquet: customBouquets[indexPath.row], count: indexPath.row + 1)
    default:
      break
    }
    return cell
  }
}

extension BasketViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case Sections.bouquets.rawValue:
      let viewController = BouquetItemInfoViewController.storyboardInstance()!
      viewController.screenType = .editItem(bouquets[indexPath.row])
      present(PestelNavigationController(rootViewController: viewController), animated: true, completion: nil)
    case Sections.customBouquets.rawValue:
      let viewController = BouquetPreviewViewController.storyboardInstance()!
      viewController.bouquet = customBouquets[indexPath.row]
      viewController.screenMode = .edit
      present(PestelNavigationController(rootViewController: viewController), animated: true, completion: nil)
    default:
      break
    }
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UITableViewHeaderFooterView()
    switch section {
    case Sections.bouquets.rawValue:
      headerView.textLabel?.text = "Готовые букеты"
      headerView.isHidden = bouquets.isEmpty
    case Sections.customBouquets.rawValue:
      headerView.textLabel?.text = "Настраиваемые букеты"
      headerView.isHidden = bouquets.isEmpty
    default:
      break
    }
    return headerView
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
    case Sections.bouquets.rawValue where !bouquets.isEmpty:
      return 40
    case Sections.customBouquets.rawValue where !customBouquets.isEmpty:
      return 40
    default:
      return 0
    }
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0
  }
}
