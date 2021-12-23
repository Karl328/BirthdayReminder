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
    var currentSortDirection : SortDirection?
    
    @IBOutlet weak var sortBtn: UIBarButtonItem!
    
    @IBAction func sortContacts(_ sender: UIBarButtonItem) {
        
        //TODO: Sorting
        
        switch currentSortDirection {
        case nil:
            contacts.sort(by: {$0.name < $1.name})
            currentSortDirection = .up
        case .down:
            contacts.sort(by: {$0.name < $1.name})
            currentSortDirection = .up
        case .up:
            contacts.sort(by: {$0.name > $1.name})
            currentSortDirection = .down
        }
        redrawBirthdayTable()
    }
    
    func redrawBirthdayTable() {
        for view in view.subviews {
            view.removeFromSuperview()
        }
        for index in contacts.indices {
            createBorderLine(index: index)
            createPhotoImg(contacts[index].imagePath, index: index)
            createNameLbl(contacts[index].name, index: index)
            createDayDescriptionLbls(dateOfBirth: contacts[index].birthDate, index: index)
        }
    }
    
    func addNewContact(currentContact: Contact) {
        contacts.append(currentContact)
        //TODO: updatedContacts.sorted { $0.name < $1.name}
        redrawBirthdayTable()
    }
    
    func createBorderLine(index: Int) {
        let line = UIView(frame: CGRect(x: 20, y: 175 + (90 * index), width: Int(self.view.frame.width) - 40, height: 1))
        line.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        self.view.addSubview(line)
    }
    
    func createPhotoImg(_ contactImagePath: String?, index: Int) {
        var image = UIImage(named: "EmptyPhoto")
        if let imagePath = contactImagePath {
            image = UIImage(contentsOfFile: imagePath)
        }
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 8, y: 100 + (90 * index), width: 70, height: 70)
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.layer.masksToBounds = false
        imageView.clipsToBounds = true
        self.view.addSubview(imageView)
    }
    
    func createNameLbl(_ contactName: String?, index: Int) {
        if let name = contactName {
            let lblName = UILabel()
            lblName.frame = CGRect(x: 83, y: 80 + (90 * index), width: 150, height: 50)
            lblName.text = name
            lblName.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
            self.view.addSubview(lblName)
        }
    }
    
    func createDayDescriptionLbls(dateOfBirth: Date?, index: Int) {
        if let dateOfBirth = dateOfBirth {
            let nextBirthDay = dateOfBirth.nextDateFromToday()
            let dayNumberStr = Calendar.current.component(.day, from: nextBirthDay)
            let nextDateDescriptionLbl = UILabel()
            let attributesDayDescription: [NSAttributedString.Key : Any] = [
                .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                .foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            ]
            
            let age = dateOfBirth.ageIfSelfBirthday()
            let weekday = nextBirthDay.weekdayName()
            
            nextDateDescriptionLbl.attributedText = NSAttributedString(string: "\(dayNumberStr) \(nextBirthDay.monthName()), \(weekday.preWordForWeekday()) \(weekday) исполнится \(age) \(age.afterWordForAge())", attributes: attributesDayDescription)
            nextDateDescriptionLbl.frame = CGRect(x: 83, y: 107 + (90 * index), width: 350, height: 50)
            self.view.addSubview(nextDateDescriptionLbl)
            
            let lblDaysTo = UILabel()
            let attributesDaysTo: [NSAttributedString.Key : Any] = [
                .font: UIFont.systemFont(ofSize: 18, weight: .regular),
                .foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            ]
            lblDaysTo.attributedText = NSAttributedString(string: "\(dateOfBirth.daysToNextThisDay())", attributes: attributesDaysTo)
            lblDaysTo.frame = CGRect(x: 280, y: 80 + (90 * index), width: 150, height: 50)
            self.view.addSubview(lblDaysTo)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowEditVC" else {return}
        guard let editVC = segue.destination as? EditViewController else {return}
        editVC.contacts = contacts
        editVC.delegate = self
    }
    
    deinit {
        deleteAllImageFromContactImages()
    }
    
}
