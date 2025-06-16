//
//  ButtonEx.swift
//  Trooper-currency-converter
//
//  Created by Md Refat Hossain on 17/06/2025.
//
import UIKit

extension UIButton {
    func setCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
