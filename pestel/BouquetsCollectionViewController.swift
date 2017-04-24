//
//  BouquetsCollectionViewController.swift
//  pestle
//
//  Created by Алексей on 23.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import UIKit
import SideMenu

private let reuseIdentifier = "BouquetCollectionViewCell"

class BouquetsCollectionViewController: UICollectionViewController {
  var bouquets: [Bouquet] = DataManager.instance.bouquets
  let orderManager = OrderManager.instance

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .done, target: self, action: #selector(BouquetsCollectionViewController.navigationLeftButtonDidTap))

    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Корзина", style: .plain, target: self, action: #selector(BouquetsCollectionViewController.rightBarItemDidTap))
    _ = DataManager.instance.fetchBouquets().then { [weak self] bouquets -> Void in
      self?.bouquets = bouquets
      self?.collectionView?.reloadData()
    }
  }

  func rightBarItemDidTap() {
    present(PestelNavigationController(rootViewController: RegistrationPhoneInputViewController.storyboardInstance()!), animated: true, completion: nil)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    collectionView?.reloadData()
  }

  func navigationLeftButtonDidTap() {
    present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return bouquets.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BouquetCollectionViewCell
    let bouquet = bouquets[indexPath.row]
    cell.configure(bouquet: bouquet, isOrdered: OrderManager.instance.bouquets.first(where: { $0.bouquet.id == bouquet.id}) != nil)
    return cell
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let viewController = BouquetItemInfoViewController.storyboardInstance()!
    let navigationController = PestelNavigationController(rootViewController: viewController)
    let bouquet = bouquets[indexPath.row]

    if let orderBouquet = OrderManager.instance.bouquets.first(where: { $0.bouquet.id == bouquet.id}) {
      viewController.screenType = .editItem(orderBouquet)
    } else {
      viewController.screenType = .addItem(bouquet)
    }

    present(navigationController, animated: true, completion: nil)

  }
  
}
