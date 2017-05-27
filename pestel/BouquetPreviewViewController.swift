//
//  BouquetPreviewViewController.swift
//  pestle
//
//  Created by Алексей on 03.05.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import UIKit

class BouquetPreviewViewController: UIViewController {
  @IBOutlet weak var doneButton: GoButton!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var quantityLabel: UILabel!

  var doneButtonHandler: (() -> Void)? = nil

  var quantity: Int {
    get {
      return Int(quantityLabel.text ?? "") ?? 1
    }
    set {
      guard newValue > 0 else { return }
      quantityLabel.text = "\(newValue)"
      priceLabel.text = (Double(newValue) * self.bouquet.price).currencyString
    }
  }

  var bouquet: CustomOrderBouquet!

  enum Sections: Int {
    case package
    case flowers

    static let count = 2
  }

  enum ScreenMode {
    case create
    case edit
  }

  var screenMode: ScreenMode = .create

  override func viewDidLoad() {
    tableView.register(PestleOptionTableViewCell.classNamedNib!, forCellReuseIdentifier: PestleOptionTableViewCell.className)
    priceLabel.text = bouquet.price.currencyString

    navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconNavCanselBlack"), style: .plain, target: self, action: #selector(BouquetPreviewViewController.leftButtonTapped))


  }

  func leftButtonTapped() {
    dismiss(animated: true, completion: nil)
  }

  @IBAction func doneButtonTapped(_ sender: Any) {
    bouquet.quantity = quantity
    switch screenMode {
    case .create:
      OrderManager.instance.customBouquets.append(bouquet)
    default:
      break
    }
    doneButtonHandler?()
    dismiss(animated: true, completion: nil)
  }

  @IBAction func plusButtonDidTap(_ sender: UIButton) {
    quantity += 1
  }


  @IBAction func minusButtonDidTap(_ sender: UIButton) {
    quantity -= 1
  }
}

extension BouquetPreviewViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return Sections.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case Sections.package.rawValue:
      return 1
    case Sections.flowers.rawValue:
      return bouquet.flowers.count
    default:
      return 0
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case Sections.package.rawValue:
      let cell = tableView.dequeueReusableCell(withIdentifier: PestleOptionTableViewCell.className, for: indexPath) as! PestleOptionTableViewCell
      return cell
    case Sections.flowers.rawValue:
      let cell = tableView.dequeueReusableCell(withIdentifier: BouquetPreviewFlowerTableViewCell.className, for: indexPath) as! BouquetPreviewFlowerTableViewCell
      cell.configure(item: bouquet.flowers[indexPath.row])
      return cell
    default:
      return UITableViewCell()
    }
  }

}

extension BouquetPreviewViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    guard section == Sections.flowers.rawValue else { return 20 }
    return 40
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return indexPath.section == Sections.package.rawValue ? 50 : 100
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = BouquetPreviewTableHeaderView.nibInstance()!
    switch section {
    case Sections.package.rawValue:
      view.addButton.isHidden = true
      view.titleLabel.text = ""
    case Sections.flowers.rawValue:
      view.titleLabel.text = "Цветы"
      switch screenMode {
      case .create:
        view.addButton.isHidden = true
      case .edit:
        view.addButtonTapHandler = { [weak self] in
          guard let `self` = self else { return }
          let viewController = CreateBouquetCollectionViewController.storyboardInstance()!
          viewController.screenType = .edit(self.bouquet)
          self.navigationController?.pushViewController(viewController, animated: true)
        }
      }
    default:
      break
    }
    return view
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    switch indexPath.section {
    case Sections.package.rawValue:
      return
    case Sections.flowers.rawValue:
      let viewController = FlowerItemInfoAlertViewController.storyboardInstance()!
      viewController.screenType = .editItem(bouquet.flowers[indexPath.row])
      viewController.modalPresentationStyle = .overCurrentContext
      viewController.dismissHandler = { tableView.reloadData() }
      present(viewController, animated: false, completion: nil)
    default:
      break
    }
  }

  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    guard indexPath.section == Sections.flowers.rawValue, bouquet.flowers.count > 1 else { return nil }
    let action = UITableViewRowAction(style: .destructive, title: "Удалить", handler: { [weak self] _, indexPath in
      tableView.beginUpdates()
      self?.bouquet.flowers.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
      tableView.endUpdates()
    })
    return [action]
  }
}

