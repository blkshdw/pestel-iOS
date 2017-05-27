//
//  CreateBouquetCollectionViewController.swift
//  pestle
//
//  Created by Алексей on 23.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import UIKit
import SideMenu

private let reuseIdentifier = "BouquetFlowerCollectionViewCell"

class CreateBouquetCollectionViewController: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var finishButton: GoButton!
  let badgeButton = BadgeButtonView.nibInstance()!

  enum ScreenType {
    case create
    case edit(CustomOrderBouquet)
  }

  var screenType: ScreenType = .create

  var bouquet: CustomOrderBouquet!
  var flowers: [Flower] = DataManager.instance.flowers
  
  @IBAction func finishButtonDidTap(_ sender: Any) {
    let viewController = BouquetPreviewViewController.storyboardInstance()!
    viewController.doneButtonHandler = { [weak self] in
      self?.bouquet = CustomOrderBouquet(quantity: 0, flowers: [])
      self?.collectionView.reloadData()
    }
    viewController.bouquet = bouquet
    present(PestelNavigationController(rootViewController: viewController), animated: true, completion: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    switch screenType {
    case .create:
      bouquet = CustomOrderBouquet(quantity: 1, flowers: [])
    case .edit(let orderBouquet):
      bouquet = orderBouquet
    }
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .done, target: self, action: #selector(CreateBouquetCollectionViewController.navigationLeftButtonDidTap))

    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: badgeButton)

    badgeButton.didTap = { [weak self] in
      self?.present(PestelNavigationController(rootViewController: BasketViewController.storyboardInstance()!), animated: true, completion: nil)
    }

    reloadData()
    refresh()
  }

  func navigationLeftButtonDidTap() {
    present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
  }

  func reloadData() {
    collectionView.reloadData()
    finishButton.isEnabled = bouquet.flowers.count > 0
  }

  func refresh() {
    _ = DataManager.instance.fetchFlowers().then { [weak self] flowers -> Void in
      self?.flowers = flowers
      self?.reloadData()
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    refresh()
  }

}

extension CreateBouquetCollectionViewController: UICollectionViewDelegate {

}

extension CreateBouquetCollectionViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return flowers.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BouquetFlowerCollectionViewCell
    let flower = flowers[indexPath.row]
    let isOrdered = bouquet.flowers.first { $0.flower.id == flower.id } != nil
    cell.configure(flower: flower, isOrdered: isOrdered)
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let viewController = FlowerItemInfoAlertViewController.storyboardInstance()!
    viewController.bouquet = bouquet

    let flower = flowers[indexPath.row]

    if let flowerItem = bouquet.flowers.first(where: { $0.flower.id == flower.id}) {
      viewController.screenType = .editItem(flowerItem)
    } else {
      viewController.screenType = .addItem(flower)
    }

    
    viewController.dismissHandler = { [weak self] in self?.reloadData() }

    viewController.modalPresentationStyle = .overCurrentContext
    present(viewController, animated: false, completion: nil)

  }
  
}
