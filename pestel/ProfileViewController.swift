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
import SideMenu

class ProfileViewController: FormViewController {
  enum FormTags: String {
    case firstName
    case lastName
    case email
    case birthdayDate
  }
  
  var didDismissHandler: (() -> Void)? = nil

  enum ScreenMode {
    case edit
    case registration
  }

  var screenMode: ScreenMode = .registration

  override func viewDidLoad() {
    super.viewDidLoad()

    let profile = ProfileManager.instance.currentProfile

    form +++ Section("Пользователь")
      <<< TextRow(FormTags.firstName.rawValue) {
        $0.title = "Имя"
        $0.placeholder = "Имя"
        $0.value = profile?.firstName
      }
      <<< TextRow(FormTags.lastName.rawValue) {
        $0.title = "Фамилия"
        $0.placeholder = "Фамилия"
        $0.value = profile?.lastName
      }
      <<< TextRow(FormTags.email.rawValue) {
        $0.title = "Email"
        $0.placeholder = "Email"
        $0.value = profile?.email
    }

    switch screenMode {
    case .edit:
      navigationItem.title = "Профиль"
      navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .done, target: self, action: #selector(ProfileViewController.navigationLeftButtonDidTap))
    default:
      break
    }

    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(ProfileViewController.rightBarItemDidTap))
  }


  func navigationLeftButtonDidTap() {
    present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
  }


  func rightBarItemDidTap() {
    ProfileManager.instance.updateProfile { profile in
      profile.firstName = form.values()[FormTags.firstName.rawValue] as? String ?? ""
      profile.lastName = form.values()[FormTags.lastName.rawValue] as? String ?? ""
      profile.email = form.values()[FormTags.email.rawValue] as? String ?? ""
    }

    DataManager.instance.updateUser().then { [weak self] _ -> Void in
      guard let `self` = self else { return }
      switch self.screenMode {
      case .registration:
        self.dismiss(animated: true, completion: { [weak self] _ in
          self?.didDismissHandler?()
        })
      default:
        break
      }

    }
  }


}
