//
//  OrderContactDataViewController.swift
//  pestle
//
//  Created by Алексей on 27.05.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import UIKit
import Eureka
import PromiseKit

class OrderContactDataViewController: FormViewController {
  enum FormTags: String {
    case firstName
    case lastName
    case email
    case street
    case building
    case appt
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    form +++ Section("Пользователь")
      <<< TextRow(FormTags.firstName.rawValue) {
        $0.title = "Имя"
        $0.placeholder = "Имя"
        $0.add(rule: RuleRequired())
        $0.value = ProfileManager.instance.currentProfile?.firstName
      }
      <<< TextRow(FormTags.lastName.rawValue) {
        $0.title = "Фамилия"
        $0.placeholder = "Фамилия"
        $0.value = ProfileManager.instance.currentProfile?.lastName
      }
      <<< TextRow(FormTags.email.rawValue) {
        $0.title = "Email"
        $0.placeholder = "Не обязательно"
        $0.value = ProfileManager.instance.currentProfile?.email
    }

      let addressSection = Section("Адрес")
     form +++ addressSection

    addressSection <<< TextRow() {
        $0.title = "Город"
        $0.placeholder = "Город"
        $0.value = "Нижний Новгород"
        $0.disabled = true
    }
    let streetRow = TextRow(FormTags.street.rawValue) {
      $0.title = "Улица"
      $0.placeholder = "Улица"
      $0.add(rule: RuleRequired())
      $0.value = ProfileManager.instance.currentProfile?.street
      $0.validationOptions = .validatesOnChange
    }
    addressSection <<< streetRow
    let buildingRow = TextRow(FormTags.building.rawValue) {
        $0.title = "Дом"
        $0.placeholder = "Дом"
        $0.value = ProfileManager.instance.currentProfile?.building
      $0.add(rule: RuleRequired())
      $0.validationOptions = .validatesOnChange
    }
    addressSection <<< buildingRow
    let apptRow = TextRow(FormTags.appt.rawValue) {
        $0.title = "Квартира"
        $0.placeholder = "Квартира"
        $0.value = ProfileManager.instance.currentProfile?.appt
      $0.add(rule: RuleRequired())
      $0.validationOptions = .validatesOnChange
    }
    addressSection <<< apptRow
    addressSection <<< ButtonRow() {
      $0.title = "Выбрать на карте"
      $0.onCellSelection { [weak self] cell in
        let addressVC = SelectAddressViewController.storyboardInstance()!
        addressVC.doneButtonHandler = { [weak self] in
          streetRow.value = addressVC.address?.street
          buildingRow.value = addressVC.address?.number
        }
        self?.parent?.navigationController?.pushViewController(addressVC, animated: true)
      }
    }
  }

  func updateProfile() -> Promise<Void> {
    ProfileManager.instance.updateProfile { profile in
      profile.firstName = form.values()[FormTags.firstName.rawValue] as? String ?? ""
      profile.lastName = form.values()[FormTags.lastName.rawValue] as? String ?? ""
      profile.email = form.values()[FormTags.email.rawValue] as? String ?? ""
      profile.street = form.values()[FormTags.street.rawValue] as? String ?? ""
      profile.building = form.values()[FormTags.building.rawValue] as? String ?? ""
      profile.appt = form.values()[FormTags.appt.rawValue] as? String ?? ""
    }

    return DataManager.instance.updateUser()
  }
}
