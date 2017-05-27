//
//  ProfileViewController.swift
//  pestle
//
//  Created by Алексей on 23.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import UIKit
import Eureka

class ProfileViewController: FormViewController {
  enum FormTags: String {
    case firstName
    case lastName
    case email
    case birthdayDate
  }
  
  var didDismissHandler: (() -> Void)? = nil

  override func viewDidLoad() {
    super.viewDidLoad()

    form +++ Section("Пользователь")
      <<< TextRow(FormTags.firstName.rawValue) {
        $0.title = "Имя"
        $0.placeholder = "Имя"
      }
      <<< TextRow(FormTags.lastName.rawValue) {
        $0.title = "Фамилия"
        $0.placeholder = "Фамилия"
      }
      <<< TextRow(FormTags.email.rawValue) {
        $0.title = "Email"
        $0.placeholder = "Email"
    }

    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(ProfileViewController.rightBarItemDidTap))
  }

  func rightBarItemDidTap() {
    ProfileManager.instance.updateProfile { profile in
      profile.firstName = form.values()[FormTags.firstName.rawValue] as? String ?? ""
      profile.lastName = form.values()[FormTags.lastName.rawValue] as? String ?? ""
      profile.email = form.values()[FormTags.email.rawValue] as? String ?? ""
    }

    DataManager.instance.updateUser().then { [weak self] in
      self?.dismiss(animated: true, completion: { [weak self] _ in
        self?.didDismissHandler?()
      })
    }
  }


}
