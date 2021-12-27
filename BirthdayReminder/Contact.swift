//
//  Contact.swift
//  BirthdayReminder
//
//  Created by Кирилл  Геллерт on 18.12.2021.
//

import Foundation

struct Contact {
    
    var name: String?
    var identifier: Int
    var birthday: Birthday?
    var gender: Gender?
    var instagram: String?
    var imagePath: String?
    
    static var identifierFactory = 0
    
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Contact.getUniqueIdentifier()
    }
  
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
