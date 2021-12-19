//
//  BirthdayListViewController.swift
//  BirthdayReminder
//
//  Created by Кирилл  Геллерт on 14.12.2021.
//

import UIKit

protocol BirthdayListViewControllerDelegate : AnyObject {
    func addNewContact(currentContact: Contact)
}

class BirthdayListViewController: UIViewController, BirthdayListViewControllerDelegate {
    
    var contacts = [Contact]()
    static var indexBetweenCells = 90
    
    func addNewContact(currentContact: Contact) {
        contacts.append(currentContact)
        //updatedContacts.sorted { $0.name < $1.name }
        for view in view.subviews {
            view.removeFromSuperview()
        }
        for index in contacts.indices {
            createBorderLine(index: index)
            createPhotoImg(contacts[index].image, index: index)
            createNameLbl(contacts[index].name, index: index)
            createDaysToLbl(dateOfBirth: contacts[index].birthDate, index: index)
            createDayDescriptionLbl(dateOfBirth: contacts[index].birthDate, index: index)
        }
    }
    
    func createBorderLine(index: Int) {
        let line = UIView(frame: CGRect(x: 20, y: 175 + (90 * index), width: Int(self.view.frame.width) - 40, height: 1))
        line.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        self.view.addSubview(line)
    }
    
    func createPhotoImg(_ contactImage: String?, index: Int) {
        let image = UIImage(named: contactImage ?? "EmptyPhoto")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 2, y: 100 + (90 * index), width: 80, height: 70)
        self.view.addSubview(imageView)
    }
    
    func createNameLbl(_ contactName: String?, index: Int) {
        if let name = contactName {
            let lblName = UILabel()
            lblName.frame = CGRect(x: 80, y: 80 + (90 * index), width: 150, height: 50)
            lblName.text = name
            lblName.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
            self.view.addSubview(lblName)
        }
    }
    
    func createDaysToLbl(dateOfBirth: Date?, index: Int) {
        if let dateOfBirth = dateOfBirth {
            let lblDaysTo = UILabel()
            let nameAttributes: [NSAttributedString.Key : Any] = [
                .font: UIFont.systemFont(ofSize: 18, weight: .regular),
                .foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            ]
            let cal = Calendar.current
            let today = cal.startOfDay(for: Date())
            let date = cal.startOfDay(for: dateOfBirth)
            let components = cal.dateComponents([.day, .month], from: date)
            let nextDate = cal.nextDate(after: today, matching: components, matchingPolicy: .nextTimePreservingSmallerComponents)
            if let daysTo = cal.dateComponents([.day], from: today, to: nextDate ?? today).day {
                lblDaysTo.attributedText = NSAttributedString(string: "\(daysTo - 1) дней", attributes: nameAttributes)
            }
            lblDaysTo.frame = CGRect(x: 300, y: 80 + (90 * index), width: 150, height: 50)
            self.view.addSubview(lblDaysTo)
        }
    }
    
    func createDayDescriptionLbl(dateOfBirth: Date?, index: Int) {
        if let dateOfBirth = dateOfBirth {
            let monthStr = Calendar.current.monthSymbols[Calendar.current.component(.month, from: dateOfBirth) - 1]
            //let monthStr = Calendar.current.weekdaySymbols[Calendar.current.component(.weekday, from: dateOfBirth) - 1]
            let lblDaysTo = UILabel()
            let nameAttributes: [NSAttributedString.Key : Any] = [
                .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                .foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            ]
            lblDaysTo.attributedText = NSAttributedString(string: "12 \(monthStr), в субботу исполнится 100 лет", attributes: nameAttributes)
            lblDaysTo.frame = CGRect(x: 80, y: 107 + (90 * index), width: 350, height: 50)
            self.view.addSubview(lblDaysTo)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowEditVC" else {return}
        guard let editVC = segue.destination as? EditViewController else {return}
        editVC.contacts = contacts
        editVC.delegate = self
    }
    
}
