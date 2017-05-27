//
//  RegistrationPhoneInputViewController.swift
//  pestle
//
//  Created by Алексей on 22.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
import PhoneNumberKit

private let termsOfServiceUrl = URL(string: "")

class RegistrationPhoneInputViewController: UIViewController {
  @IBOutlet weak var phoneInputField: UITextField!
  @IBOutlet weak var sendButton: GoButton!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!

  var finishRegistrationHandler: (() -> Void)? = nil

  var observers: [Any] = []

  override func viewDidLoad() {
    hideKeyboardOnTapOutside()

    phoneInputField.inputAccessoryView = UIView()
    phoneInputField.tintColor = UIColor.sportUpAquaMarine

    navigationItem.backBarButtonItem = UIBarButtonItem(
      title: "",
      style: .plain,
      target: nil, action: nil
    )

    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: #imageLiteral(resourceName: "iconNavCanselBlack"),
      style: .plain,
      target: self, action: #selector(self.leftNavigationButtonDidTap)
    )
  }

  func leftNavigationButtonDidTap() {
    dismiss(animated: true, completion: nil)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    phoneInputField.becomeFirstResponder()
    self.observers = bottomLayoutConstraint.addObserversUpdateWithKeyboard()
  }

  override func viewWillDisappear(_ animated: Bool) {
    observers.forEach { NotificationCenter.default.removeObserver($0) }
    observers = []
  }

  @IBAction func licenseAgreementDidTap(_ sender: Any) {
    guard let url = termsOfServiceUrl else { return }
    let safariViewController = SFSafariViewController(url: url)

    present(safariViewController, animated: true, completion: nil)
  }

  @IBAction func sendButtonDidTap(_ sender: Any) {
    guard let phoneText = phoneInputField.text else { return presentAlertWithMessage("Неправильный формат номера телефона") }
    let phoneNumberKit = PhoneNumberKit()
    guard let _ = try? phoneNumberKit.parse(phoneText) else { return presentAlertWithMessage("Неправильный формат номера телефона") }
    _ = DataManager.instance
      .requestAuthCode(phone: Int(phoneText.onlyDigits) ?? 0).then { [weak self] _ -> Void in
        let viewController = RegistrationCodeInputViewController.storyboardInstance()!
        viewController.phoneNumberString = phoneText
        viewController.finishRegistrationHandler = self?.finishRegistrationHandler
        self?.navigationController?.pushViewController(viewController, animated: true)
      }.catch { [weak self ] _ -> Void in
        self?.presentAlertWithMessage("Номер телефона имеет неправильный формат или уже используется")
    }
    
  }
  
}
