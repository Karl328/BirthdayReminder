//
//  LabelExtensions.swift
//  BirthdayReminder
//
//  Created by Кирилл  Геллерт on 15.12.2021.
//

import UIKit

extension UILabel {
    func setBorderByCurrentSize() {
        self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.borderWidth = 1
    }
}
