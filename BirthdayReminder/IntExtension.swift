//
//  IntExtension.swift
//  BirthdayReminder
//
//  Created by Кирилл  Геллерт on 21.12.2021.
//

import Foundation

extension Int {
    
    func afterWordForAge() -> String{
        
        let lastInt = self % 10
        
        if lastInt == 1 {
           return "год"
        } else if lastInt < 5 {
            return "года"
        } else {
            return "лет"
        }

    }
    
}
