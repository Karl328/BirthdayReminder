//
//  BirthdayListViewController.swift
//  BirthdayReminder
//
//  Created by Кирилл  Геллерт on 14.12.2021.
//

import UIKit

protocol BirthdayListViewControllerDelegate : AnyObject {
    func addNewContact(changedContact: Contact)
}

class BirthdayListViewController: UIViewController, BirthdayListViewControllerDelegate {
    
    var contacts = [Contact]()
    var currentSortDirection = SortDirection.down
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSortBtn()
    }
    
    @objc func sortContacts(sender: UIBarButtonItem) {
        switch currentSortDirection {
        case .down:
            contacts.sort {($0.birthday?.daysToNextBirthday ?? 0) < $1.birthday?.daysToNextBirthday ?? 0}
            currentSortDirection = .up
        case .up:
            contacts.sort {$0.birthday?.daysToNextBirthday ?? 0 > $1.birthday?.daysToNextBirthday ?? 0}
            currentSortDirection = .down
        }
        redrawBirthdayTable()
        sender.title = "\(currentSortDirection.rawValue)"
    }
    
    func createSortBtn() {
        let sortBtn = UIBarButtonItem(title: "\(currentSortDirection.rawValue)", style: .plain, target: self, action: #selector(sortContacts(sender:)))
        navigationItem.rightBarButtonItems?.append(sortBtn)
    }
    
    func redrawBirthdayTable() {
        for view in view.subviews {
            view.removeFromSuperview()
        }
        for index in contacts.indices {
            createViews(contact: contacts[index], index: index)
        }
    }
    
    func addNewContact(changedContact: Contact) {
        if let currentIndex = contacts.firstIndex(where: {$0.identifier == changedContact.identifier}) {
            contacts.remove(at: currentIndex)
            contacts.insert(changedContact, at: currentIndex)
            redrawBirthdayTable()
        } else {
            contacts.append(changedContact)
            createViews(contact: changedContact, index: contacts.count - 1)
        }
    }
    
    @objc func imageTapped(gesture: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "EditVC") as? EditViewController else {return}
        guard let identifier = gesture.view?.tag, let chosenContact = contacts.first(where: {$0.identifier == identifier}) else {return}
        vc.changedContact = chosenContact
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func createViews(contact: Contact, index: Int) {
        createNameLbl(frameIndex: index, name: contact.name)
        let imgPhoto = createPhotoImgView(frameIndex: index, imagePath: contact.imagePath, identifier: contact.identifier)
        let viewLine = createLineView(frameIndex: index)
        if let birthday = contact.birthday {
            let lblDaysTo = createDaysToLbl(frameIndex: index, birthday: birthday)
            let lblNextBirthday = createNextBirthdayLbl(frameIndex: index, birthday: birthday)
            setupLayout(lblDaysTo: lblDaysTo, lblNextBirthday: lblNextBirthday, viewLine: viewLine, imgPhoto: imgPhoto)
        }
    }
    
    func createNameLbl(frameIndex: Int, name: String?) {
        let lblName = UILabel()
        lblName.frame = CGRect(x: 83, y: 80 + (90 * frameIndex), width: 150, height: 50)
        lblName.text = name
        lblName.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        self.view.addSubview(lblName)
    }
    
    func createPhotoImgView(frameIndex: Int, imagePath: String?, identifier: Int) -> UIImageView {
        let imgPhoto = UIImageView()
        var image = getEmptyImage()
        if let imagePath = imagePath {
            image = UIImage(contentsOfFile: imagePath) ?? getEmptyImage()
        }
        imgPhoto.image = image
        imgPhoto.tag = identifier
        imgPhoto.frame = CGRect(x: 8, y: 100 + (90 * frameIndex), width: 70, height: 70)
        imgPhoto.layer.cornerRadius = imgPhoto.frame.size.width / 2
        imgPhoto.layer.masksToBounds = false
        imgPhoto.clipsToBounds = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
        imgPhoto.addGestureRecognizer(tapGestureRecognizer)
        imgPhoto.isUserInteractionEnabled = true
        self.view.addSubview(imgPhoto)
        return imgPhoto
    }
    
    func createLineView(frameIndex: Int) -> UIView {
        let viewLine = UIView()
        viewLine.frame = CGRect(x: 20, y: 175 + (90 * frameIndex), width: Int(self.view.frame.width) - 40, height: 1)
        viewLine.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        self.view.addSubview(viewLine)
        return viewLine
    }
    
    func createNextBirthdayLbl(frameIndex: Int, birthday: Birthday) -> UILabel {
        let lblNextBirthday = UILabel()
        let willBeAge = birthday.age + 1
        let attributesDayDescription: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .regular),
            .foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        ]
        lblNextBirthday.attributedText = NSAttributedString(string: "\(String(describing: birthday.dayNumber)) \(birthday.monthName), \(birthday.nextBirthDayWeekDayName.preWordForWeekday()) \(birthday.nextBirthDayWeekDayName) исполнится \(willBeAge) \(willBeAge.afterWordForAge())", attributes: attributesDayDescription)
        lblNextBirthday.frame = CGRect(x: 83, y: 107 + (90 * frameIndex), width: 350, height: 50)
        self.view.addSubview(lblNextBirthday)
        return lblNextBirthday
    }
    
    func createDaysToLbl(frameIndex: Int, birthday: Birthday) -> UILabel {
        let lblDaysTo = UILabel()
        let attributesDaysTo: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .regular),
            .foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        ]
        lblDaysTo.attributedText = NSAttributedString(string: "\(String(describing: birthday.nextBirthDay.daysToDescription()))", attributes: attributesDaysTo)
        lblDaysTo.frame = CGRect(x: 280, y: 80 + (90 * frameIndex), width: 150, height: 50)
        self.view.addSubview(lblDaysTo)
        return lblDaysTo
    }
    
    func setupLayout(lblDaysTo: UILabel, lblNextBirthday: UILabel, viewLine: UIView, imgPhoto: UIImageView) {
        lblDaysTo.translatesAutoresizingMaskIntoConstraints = false
        lblNextBirthday.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lblDaysTo.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            lblDaysTo.bottomAnchor.constraint(equalTo: viewLine.bottomAnchor, constant: -60),
            lblNextBirthday.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            lblNextBirthday.bottomAnchor.constraint(equalTo: viewLine.bottomAnchor, constant: -40),
            lblNextBirthday.leadingAnchor.constraint(equalTo: imgPhoto.trailingAnchor, constant: 5)
        ])
        lblNextBirthday.adjustsFontSizeToFitWidth = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowEditVC" else {return}
        guard let editVC = segue.destination as? EditViewController else {return}
        editVC.delegate = self
    }
    
    deinit {
        deleteImagesTempFolder()
    }
    
}
