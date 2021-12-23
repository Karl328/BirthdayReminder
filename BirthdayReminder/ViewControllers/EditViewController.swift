//
//  EditViewController.swift
//  BirthdayReminder
//
//  Created by Кирилл  Геллерт on 14.12.2021.
//

import UIKit

class EditViewController: UIViewController {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtBirthDate: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtInstagram: UITextField!
    @IBOutlet weak var imgContactPhoto: UIImageView!
    @IBOutlet weak var btnAdd: UIButton!
    
    weak var delegate: BirthdayListViewControllerDelegate?
    
    var contacts = [Contact]()
    
    lazy var currentContact = Contact(name: "", identifier: contacts.count + 1)
    
    let datePicker = UIDatePicker()
    let agePicker = UIPickerView()
    let genderPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for case let view as UIStackView in self.view.subviews {
            for case let textField as UITextField in view.arrangedSubviews {
                textField.setOnlyBottomBorder()
            }
        }
        createDatePicker()
        createAgeViewPicker()
        createGenderViewPicker()
        imgContactPhoto.layer.cornerRadius = imgContactPhoto.frame.size.width / 2
        btnAdd.isEnabled = false
    }
    
    @IBAction func cancelAdding(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addUser(_ sender: UIButton) {
        if let nameText = txtName.text {
            currentContact.name = nameText
        }
        if let genderText = txtGender.text {
            currentContact.gender = getElementByRawValue(rawValue: genderText)
        }
        if let ageText = txtAge.text {
            currentContact.age = Int(ageText)
        }
        if let instagramText = txtInstagram.text {
            currentContact.instagram = instagramText
        }
        if let delegateVC = delegate {
            delegateVC.addNewContact(currentContact: currentContact)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func choosePhoto(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @IBAction func showInstagramAlert(_ sender: UITextField) {
        let alert = UIAlertController(title: "Instagram", message: "Введите username Instagram", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [unowned self] _ in self.txtInstagram.text = alert.textFields?.first?.text
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [unowned self]_ in self.view.endEditing(true)
        }))
        alert.addTextField(configurationHandler: nil)
        self.present(alert, animated: true)
    }
    
    @IBAction func tapOnTxtAge(_ sender: UITextField) {
        if sender.text == "" {
            setText(firstValue: "1", in: sender)
        }
    }
    
    @IBAction func tapOnTxtGender(_ sender: UITextField) {
        if let genderItem = Gender.allCases.first?.rawValue, sender.text == "" {
            setText(firstValue: genderItem, in: sender)
        }
    }
    
    @IBAction func textEdited(_ sender: UITextField) {
        if let nameText = txtName.text {
            btnAdd.isEnabled = nameText != ""
        }
    }
    
    func setText(firstValue: String, in textField: UITextField) {
        textField.text = firstValue
    }
    
    func createDatePicker() {
        let toolbar = createDoneToolbarWith(action: #selector(donePressedBirthDate))
        txtBirthDate.inputAccessoryView = toolbar
        txtBirthDate.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale.init(identifier: "ru")
    }
    
    func createAgeViewPicker() {
        let toolbar = createDoneToolbarWith(action: #selector(donePressed))
        txtAge.inputAccessoryView = toolbar
        txtAge.inputView = agePicker
        agePicker.dataSource = self
        agePicker.delegate = self
        agePicker.tag = 1
    }
    
    func createGenderViewPicker() {
        let toolbar = createDoneToolbarWith(action: #selector(donePressed))
        txtGender.inputAccessoryView = toolbar
        txtGender.inputView = genderPicker
        genderPicker.dataSource = self
        genderPicker.delegate = self
        genderPicker.tag = 2
    }
    
    func createDoneToolbarWith(action: Selector) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let btnDone = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: action)
        toolbar.setItems([btnDone], animated: true)
        return toolbar
    }
    
    @objc func donePressed() {
        self.view.endEditing(true)
    }
    
    @objc func donePressedBirthDate() {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "ru")
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        txtBirthDate.text = formatter.string(from: datePicker.date)
        currentContact.birthDate = datePicker.date
        self.view.endEditing(true)
    }
    
}

extension EditViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1: return 150
        case 2: return 2
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1: return String(row + 1)
        case 2: return Gender.allCases[row].rawValue
        default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1: txtAge.text = String(row + 1)
        case 2: txtGender.text = Gender.allCases[row].rawValue
        default: break
        }
    }
}

extension EditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgContactPhoto.image = image
            currentContact.imagePath = saveImageToContactImages(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
