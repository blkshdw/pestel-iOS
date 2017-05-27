//
//  RootMainMenuViewController.swift
//  pestle
//
//  Created by Алексей on 23.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import UIKit

private enum Row: Int {
  case user = 0
  case bouquet
  case createBouqet
  case orderExistingBouqet
  case myOrders
  case sale
  case promoCode

  var viewController: UIViewController? {
    switch self {
    case .user:
      let viewController = ProfileViewController()
      viewController.screenMode = .edit
      return viewController
    case .createBouqet:
      return CreateBouquetCollectionViewController.storyboardInstance()!
    case .orderExistingBouqet:
      return BouquetsCollectionViewController.storyboardInstance()!
    default:
      return nil
    }
  }
}

class RootSideMenuViewController: UITableViewController {
  override func viewDidLoad() {
    tableView.tableFooterView = UIView()
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let row = Row(rawValue: indexPath.row), let vc = row.viewController else { return }
    navigationController?.pushViewController(vc, animated: true)
  }

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return UIView()
  }

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 64
  }

}
