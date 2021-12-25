//
//  Birthday.swift
//  BirthdayReminder
//
//  Created by Кирилл  Геллерт on 25.12.2021.
//

import Foundation

class Birthday {
    
    var date: Date
    var nextBirthDay: Date
    var dayNumber: Int
    var monthName: String
    var nextBirthDayWeekDayName: String
    var age: Int
    var daysToNextBirthday: Int
    
    init(dateOfBirth: Date) {
        self.date = dateOfBirth
        self.nextBirthDay = dateOfBirth.nextDateFromToday()
        self.dayNumber = Calendar.current.component(.day, from: nextBirthDay)
        self.monthName = self.date.monthName()
        self.nextBirthDayWeekDayName = self.nextBirthDay.weekdayName() 
        self.age = self.date.currentAge()
        self.daysToNextBirthday = self.date.daysTo()
    }
}
