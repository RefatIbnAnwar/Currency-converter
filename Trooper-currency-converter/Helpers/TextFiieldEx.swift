//
//  TextFiieldEx.swift
//  Trooper-currency-converter
//
//  Created by Md Refat Hossain on 17/06/2025.
//

import UIKit

extension UITextField {
    func addDoneButtonOnKeyboard() {
        let toolbar: UIToolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .done,
                                         target: self,
                                         action: #selector(dismissKeyboard))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil,
                                        action: nil)
        toolbar.items = [flexSpace, doneButton]

        self.inputAccessoryView = toolbar
    }

    @objc private func dismissKeyboard() {
        self.resignFirstResponder()
    }
}
