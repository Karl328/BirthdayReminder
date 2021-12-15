//
//  UITextFieldExtensions.swift
//  BirthdayReminder
//
//  Created by Кирилл  Геллерт on 15.12.2021.
//

import UIKit

extension UITextField {
    func setOnlyBottomBorder() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.1)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
