//
//  DatabaseTool.swift
//  WhereMyFriends
//
//  Created by Anton Pavlov on 25.05.17.
//  Copyright © 2017 Anton Pavlov. All rights reserved.
//

import Foundation

class LoginStorage {
    static let loginKey = "login"
    static let phoneKey = "phone"
    static let photoKey = "photo"
    
    
    func fetchLogin() -> String? {
        return UserDefaults.standard.string(forKey: LoginStorage.loginKey)
    }
    
    func fetchPhone() -> String? {
        return UserDefaults.standard.string(forKey: LoginStorage.phoneKey)
    }
    
    func fetchPhoto() -> String? {
        return UserDefaults.standard.string(forKey: LoginStorage.photoKey)
    }
    
    
    func save(login: String) {
        UserDefaults.standard.set(login, forKey: LoginStorage.loginKey)
    }
    
    func save(phone: String) {
        UserDefaults.standard.set(phone, forKey: LoginStorage.phoneKey)
    }
    
    func save(photo: String) {
        UserDefaults.standard.set(photo, forKey: LoginStorage.photoKey)
    }
    
    
    func isLoginExist() -> Bool {
        return self.fetchLogin() != nil
    }
    
    func isPhoneExist() -> Bool {
        return self.fetchPhone() != nil
    }
    
    func isPhotoExist() -> Bool {
        return self.fetchPhoto() != nil
    }
}
