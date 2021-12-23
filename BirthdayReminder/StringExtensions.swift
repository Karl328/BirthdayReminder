//
//  StringExtensions.swift
//  BirthdayReminder
//
//  Created by Кирилл  Геллерт on 21.12.2021.
//

import Foundation

extension String {
    
    func preWordForWeekday() -> String {
        if self == "вторник" {
            return "во"
        } else {
            return "в"
        }
    }
}
