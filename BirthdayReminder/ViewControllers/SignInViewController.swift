//
//  ViewController.swift
//  BirthdayReminder
//
//  Created by Кирилл  Геллерт on 14.12.2021.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var lblBirthdayReminder: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    
    let btnPasswordEye = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblBirthdayReminder.setBorders()
        txtEmail.setOnlyBottomBorder()
        txtPassword.setOnlyBottomBorder()
        hideKeyboardWhenTappedAround()
        btnSignIn.layer.cornerRadius = 7
        createEyePasswordToggle()
    }
    
    func createEyePasswordToggle() {
        btnPasswordEye.setBackgroundImage(UIImage(systemName: "eye"), for: .normal)
        btnPasswordEye.frame = CGRect(x: 0, y: 0, width: 23, height: 16)
        view.addSubview(btnPasswordEye)
        txtPassword.rightView = btnPasswordEye
        txtPassword.rightViewMode = .always
        btnPasswordEye.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        btnPasswordEye.addTarget(self, action: #selector(showHidePassword), for: .touchUpInside)
    }
    
    @objc func showHidePassword() {
        txtPassword.isSecureTextEntry = !txtPassword.isSecureTextEntry
        if txtPassword.isSecureTextEntry {
            btnPasswordEye.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            btnPasswordEye.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        navigationItem.backBarButtonItem = backItem
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

