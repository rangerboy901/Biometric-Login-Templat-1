//
//  UIApplication+Extension.swift
//  Biometric Login Templat 1
//
//  Created by Joseph  DeWeese on 1/29/23.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

