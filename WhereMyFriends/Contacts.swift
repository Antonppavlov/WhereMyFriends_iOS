//
//  Contacts.swift
//  WhereMyFriends
//
//  Created by Anton Pavlov on 08.06.17.
//  Copyright © 2017 Anton Pavlov. All rights reserved.
//

import Foundation
import Contacts


class Contacts {
 //нужно сделать как синглтон т.к. нужна одна одна на все приложение
//для удобства использования
    var contacts = [CNContact]()
    
    
    init() {
        loadDateFromContactStore()
    }
    
    
    //MARK: Load date from ContactStore
    func loadDateFromContactStore()  {
        let store = CNContactStore()
        var contacts = [CNContact]()
        let request = CNContactFetchRequest(keysToFetch: [CNContactIdentifierKey as NSString, CNContactPhoneNumbersKey as CNKeyDescriptor , CNContactFormatter.descriptorForRequiredKeys(for: .fullName)])
        do {
            try store.enumerateContacts(with: request) { contact, stop in
                contacts.append(contact)
            }
        } catch {
            print(error)
        }
        
        self.contacts = contacts;
        
    }

}
