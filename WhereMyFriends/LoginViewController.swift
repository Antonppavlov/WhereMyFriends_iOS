//
//  ViewController.swift
//  WhereMyFriends
//
//  Created by Anton Pavlov on 25.05.17.
//  Copyright © 2017 Anton Pavlov. All rights reserved.
//

import UIKit
import Foundation
import NKVPhonePicker

class LoginViewController: UIViewController {

    @IBOutlet weak var inputLogin: UITextField!
    @IBOutlet weak var inputPassword: NKVPhonePickerTextField!
    
    let storage = LoginStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let number = format(phoneNumber: inputPassword.text!)
        print(inputPassword.text!)
        print(number)
        storage.save(login: inputLogin.text!)
        storage.save(phone: number)
    }

}

