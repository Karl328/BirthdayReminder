//
//  DateExtension.swift
//  BirthdayReminder
//
//  Created by Кирилл  Геллерт on 20.12.2021.
//

import Foundation

var cal = createLocalizedCalendar()

func createLocalizedCalendar() -> Calendar {
    var currentCalendar = Calendar.current
    currentCalendar.locale = Locale.init(identifier: "ru")
    return currentCalendar
}

extension Date {
    
    func monthName() -> String {
        return cal.monthSymbols[Calendar.current.component(.month, from: self) - 1]
    }
    
    func weekdayName() -> String {
        return cal.weekdaySymbols[Calendar.current.component(.weekday, from: self) - 1].replacingOccurrences(of: "а", with: "у")
    }
    
    func ageIfSelfBirthday() -> Int {
        let ageComponents = cal.dateComponents([.year], from: self, to: Date())
        let ageStr = ageComponents.year ?? 0
        return ageStr + 1
    }
    
    func nextDateFromToday() -> Date {
        let today = cal.startOfDay(for: Date())
        let date = cal.startOfDay(for: self)
        let components = cal.dateComponents([.day, .month], from: date)
        if cal.dateComponents([.day, .month, .year], from: today) == cal.dateComponents([.day, .month, .year], from: date) {
            return Date()
        }
        return cal.nextDate(after: today, matching: components, matchingPolicy: .nextTimePreservingSmallerComponents) ?? Date()
    }
    
    func daysToNextThisDay() -> String {
        let today = cal.startOfDay(for: Date())
        guard let daysTo = cal.dateComponents([.day], from: today, to: nextDateFromToday()).day else { return "" }
        return dayDescription(dayCount: daysTo - 1)
    }
    
    func dayDescription(dayCount: Int) -> String {
        if dayCount == -1 {
            return "Сегодня"
        } else if dayCount == 0 {
            return "Завтра"
        } else if dayCount == 1 {
            return "Послезавтра"
        } else if (dayCount % 10) < 5, dayCount % 10 != 0 {
            return ("\(dayCount) дня")
        } else {
            return ("\(dayCount) дней")
        }
    }
    
}
