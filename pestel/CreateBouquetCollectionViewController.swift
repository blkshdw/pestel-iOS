//
//  CreateBouquetCollectionViewController.swift
//  pestle
//
//  Created by Алексей on 23.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import UIKit

private let reuseIdentifier = "BouquetFlowerCollectionViewCell"

class CreateBouquetCollectionViewController: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var finishButton: GoButton!

  enum ScreenType {
    case create
    case edit(CustomOrderBouquet)
  }

  var screenType: ScreenType = .create

  var bouquet: CustomOrderBouquet!
  
  @IBAction func finishButtonDidTap(_ sender: Any) {
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
  }

}

extension CreateBouquetCollectionViewController: UICollectionViewDelegate {

}

extension CreateBouquetCollectionViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return DataManager.instance.flowers.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BouquetFlowerCollectionViewCell
    return cell
  }

  
}
