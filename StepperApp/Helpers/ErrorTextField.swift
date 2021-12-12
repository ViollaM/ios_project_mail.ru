//
//  ErrorTextField.swift
//  StepperApp
//
//  Created by Оля Галягина on 16.11.2021.
//

import UIKit

func displayAlert(message: String, viewController: UIViewController) {
    let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    viewController.present(alert, animated: true, completion: nil)
}
