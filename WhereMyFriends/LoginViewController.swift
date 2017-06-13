//
//  ViewController.swift
//  WhereMyFriends
//
//  Created by Anton Pavlov on 25.05.17.
//  Copyright © 2017 Anton Pavlov. All rights reserved.
//

import UIKit
import Foundation
import PhoneNumberKit
class LoginViewController: UIViewController {

    @IBOutlet weak var inputLogin: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    
    let storage = LoginStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let phoneNumberKit = PhoneNumberKit()
//        var phoneNumber:PhoneNumber?
//        
//        do {
//            phoneNumber = try phoneNumberKit.parse(inputPassword.text!, withRegion: "UA", ignoreType: true)                   }
//        catch {
//            print("Generic parser error")
//        }
     //   print(phoneNumber?.adjustedNationalNumber() ?? <#default value#>)
       // print(phoneNumber?.numberString)
        // print((phoneNumber?.adjustedNationalNumber())!)
       // print(phoneNumber?.countryCode.description)
       // print(phoneNumber?.nationalNumber.description)
        
        let number = format(phoneNumber: inputPassword.text!)
        print(inputPassword.text!)
        print(number)
        storage.save(login: inputLogin.text!)
        storage.save(phone: number)
    }

}

