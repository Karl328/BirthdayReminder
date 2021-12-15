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
    @IBOutlet weak var butSignIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblBirthdayReminder.setBorderByCurrentSize()
        txtEmail.setOnlyBottomBorder()
        txtPassword.setOnlyBottomBorder()
        butSignIn.layer.cornerRadius = 7
    }
}

