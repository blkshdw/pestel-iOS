//
//  RegistrationCodeInputViewController.swift
//  pestle
//
//  Created by Алексей on 22.04.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

private let termsOfServiceUrl = URL(string: "")

class RegistrationCodeInputViewController: UIViewController {
  var phoneNumberString: String = ""
  let maskedCodeInput = MaskedInput(formattingType: .pattern("* ∙ * ∙ * ∙ * ∙ * ∙ *"))

  @IBOutlet weak var codeField: UITextField!
  @IBOutlet weak var repeatButton: UIButton!
  @IBOutlet weak var subTitleLabel: UILabel!
  @IBOutlet weak var licenseAgreementLabel: UILabel!

  @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!

  var observers: [NSObjectProtocol] = []

  override func viewDidLoad() {
    hideKeyboardOnTapOutside()
    codeField.inputAccessoryView = UIView()

    navigationItem.backBarButtonItem = UIBarButtonItem(
      title: "",
      style: .plain,
      target: nil, action: nil
    )
    
    codeField.tintColor = UIColor.sportUpAquaMarine
    subTitleLabel.text = "На номер \(phoneNumberString) был отправлен код"
    maskedCodeInput.configure(textField: codeField)

    maskedCodeInput.isValidHandler = { [weak self] isValid in
      guard isValid else { return }
      self?.codeField.isEnabled = false
      _ = DataManager.instance.confirmCode(code: self?.codeField.text?.onlyDigits ?? "").then { [weak self] _ -> Void in
        self?.navigationController?.pushViewController(ProfileViewController(), animated: true)
      }.always {
        self?.codeField.isEnabled = true
      }
    }

  }

  override func viewWillAppear(_ animated: Bool) {
    codeField.becomeFirstResponder()
    addObserverUpdateWithKeyboard()
  }

  override func viewWillDisappear(_ animated: Bool) {
    observers.forEach { NotificationCenter.default.removeObserver($0) }
    observers = []
  }

  func addObserverUpdateWithKeyboard() {
    let currentConstant = bottomLayoutConstraint.constant

    let didShowObserver = NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil, using: { [weak self] notification in
      if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        let keyboardHeight = keyboardSize.height
        UIView.animate(withDuration: 0.4, animations: {
          self?.bottomLayoutConstraint.constant = currentConstant + keyboardHeight
          self?.view.layoutIfNeeded()
        })
      }
    })

    observers.append(didShowObserver)

    let willHideObserver = NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil, using: { [weak self] notification in
      UIView.animate(withDuration: 0.4, animations: {
        self?.bottomLayoutConstraint.constant = currentConstant
        self?.view.layoutIfNeeded()
      })
    })

    observers.append(willHideObserver)
  }

  @IBAction func licenseAgreementDidTap(_ sender: Any) {
    guard let url = termsOfServiceUrl else { return }
    let safariViewController = SFSafariViewController(url: url)
    present(safariViewController, animated: true, completion: nil)
    
  }
  
}
