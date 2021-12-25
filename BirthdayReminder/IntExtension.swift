//
//  IntExtension.swift
//  BirthdayReminder
//
//  Created by Кирилл  Геллерт on 21.12.2021.
//

import Foundation

extension Int {
    
    func afterWordForAge() -> String{
        var lastNumber = self % 100;
        if (lastNumber > 19) {
            lastNumber = lastNumber % 10;
        }
        switch lastNumber {
        case 1:
            return("год")
        case 2...4:
            return("года")
        default:
            return("лет")
        }
    }
    
}

