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

enum FormTags: String {
  case firstName
  case lastName
  case email
  case birthdayDate
}

class ProfileViewController: FormViewController {

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
    dismiss(animated: true, completion: nil)
  }


}
