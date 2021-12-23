//
//  Contact.swift
//  BirthdayReminder
//
//  Created by Кирилл  Геллерт on 18.12.2021.
//

import Foundation

struct Contact {
    
    var name: String
    var birthDate: Date?
    var age: Int?
    var gender: Gender?
    var instagram: String?
    var imagePath: String?
    var identifier: Int
    
}

enum Gender: String, CaseIterable {
    case male = "Парень"
    case female = "Девушка"
}

func getElementByRawValue(rawValue: String) -> Gender {
    for gender in Gender.allCases {
        if gender.rawValue == rawValue {
            return gender
        }
    }
    return .male
}
