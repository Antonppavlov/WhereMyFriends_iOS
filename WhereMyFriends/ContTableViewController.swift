//
//  ContactsViewController.swift
//  WhereMyFriends
//
//  Created by Anton Pavlov on 01.06.17.
//  Copyright © 2017 Anton Pavlov. All rights reserved.
//

import UIKit
import Contacts

class ContViewController: UITableViewController{
    
    var peoples = Array<CNContact>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDateFromContactStore()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peoples.count
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
         let contacts = peoples[indexPath.row]
        
        cell.textLabel?.text = contacts.givenName
         cell.detailTextLabel?.text = contacts.phoneNumbers[0].value.stringValue

        return cell
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{

            peoples.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
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
        
        peoples = contacts;
        
    }
    
}
