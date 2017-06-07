//
//  ContactsViewController.swift
//  WhereMyFriends
//
//  Created by Anton Pavlov on 01.06.17.
//  Copyright © 2017 Anton Pavlov. All rights reserved.
//

import UIKit
import Contacts

class ContactsViewController: UITableViewController{
  
    @IBOutlet weak var notesTable: UITableView!
    @IBOutlet weak var labelDownloadContacts: UILabel!
    
    var peoples = Array<CNContact>()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDateFromFarabase()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return peoples.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        
        // Configure the cell...
        let employeList = peoples[indexPath.row]
        configureCell(cell: cell, indexPath: indexPath)
        //cellCheckbox(cell: cell, isDev: employeList.developer)
        return cell
    }
    
    func configureCell(cell:UITableViewCell, indexPath:IndexPath) {
        let employeList = peoples[indexPath.row]
      
       // let dobTimeInterval = employeList.dob as TimeInterval
        
        cell.textLabel?.text = employeList.givenName
        cell.detailTextLabel?.text = employeList.phoneNumbers[0].value.stringValue
            
//            populateTimeInterval(dobTimeInterval: dobTimeInterval)
//        cell.imageView?.image = populateImage(imageString: employeList.photo)
        
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            //finde snepshot and delete
            //let emloyee = peoples[indexPath.row]
           // emloyee.ref?.removeValue()
            peoples.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath)
//        
//        let emloyee = peoples[indexPath.row]
//        let toogle = !(emloyee.developer!)
//        
//        cellCheckbox(cell: cell!, isDev: toogle)
//        emloyee.developer = toogle
//        emloyee.ref?.updateChildValues(["developer":toogle])
//        peoples[indexPath.row] = emloyee
//        
//        self.tableView.reloadData()
//    }
//    
    
    
    //MARK: Configure Cell
//    func cellCheckbox(cell:UITableViewCell, isDev:Bool) {
//        if isDev{
//            cell.accessoryType = UITableViewCellAccessoryType.checkmark
//            cell.textLabel?.textColor = UIColor.red
//            cell.detailTextLabel?.textColor = UIColor.red
//        }else{
//            cell.accessoryType = UITableViewCellAccessoryType.none
//            cell.textLabel?.textColor = UIColor.black
//            cell.detailTextLabel?.textColor = UIColor.black
//        }
//    }
    
    //MARK: Populate TimeInterval
//    func populateTimeInterval(dobTimeInterval: TimeInterval) ->String{
//        let date = Date(timeIntervalSinceNow: dobTimeInterval)
//        let dateString = formatDate(date: date)
//        
//        return dateString
//        
//    }
    
    //MARK: Populate Image
    func populateImage(imageString: String) ->UIImage{
        let decodedData = Data(base64Encoded: imageString, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
        let decodedImage = UIImage(data: decodedData!)
        return decodedImage!
    }
    
    //MARK: Load date from firebase
    func loadDateFromFarabase()  {
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
    
    
    
    
    
    
    
    
    
    
    
    
//    override func viewDidLoad() {
//              super.viewDidLoad()
//      //  printContacts()
//
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let notesCount = notes.count
//        labelDownloadContacts.isHidden=notesCount>0
//        return notesCount
//    }
//    
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell")! as UITableViewCell
//        cell.textLabel?.text = notes[indexPath.row].givenName
//        cell.detailTextLabel?.text = notes[indexPath.row].phoneNumbers[0].value.stringValue
//        return cell
//    }
//    
//    
//    func deleteNotes(index:Int)  {
//        notes.remove(at: index)
//    }
//    
//   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete{
//            deleteNotes(index: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
//        }
//    }
//    
//   override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 10.0
//    }
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return UIView()
//    }
//    
    
    
//    
//    func printContacts()  {
//        let status = CNContactStore.authorizationStatus(for: .contacts)
//        if status == .denied || status == .restricted {
//            presentSettingsActionSheet()
//            return
//        }
//        
//        // open it
//        
//        let store = CNContactStore()
//        store.requestAccess(for: .contacts) { granted, error in
//            guard granted else {
//                DispatchQueue.main.async {
//                    self.presentSettingsActionSheet()
//                }
//                return
//            }
//            
//            // get the contacts
//            
//            
//            var contacts = [CNContact]()
//            let request = CNContactFetchRequest(keysToFetch: [CNContactIdentifierKey as NSString, CNContactPhoneNumbersKey as CNKeyDescriptor , CNContactFormatter.descriptorForRequiredKeys(for: .fullName)])
//            do {
//                try store.enumerateContacts(with: request) { contact, stop in
//                    contacts.append(contact)
//                }
//            } catch {
//                print(error)
//            }
//            
//            // do something with the contacts array (e.g. print the names)
//            
//
//            let formatter = CNContactFormatter()
//            formatter.style = .fullName
//            for contact in contacts {
//                for phone in contact.phoneNumbers {
//                    print(phone.value.stringValue)
//                }
//              //  self.notes.append(formatter.string(from: contact) ?? "???")
//               // print(formatter.string(from: contact) ?? "???")
//               
//                //self.notesTable.reloadData()
//            }
//            self.notes = contacts;
//             self.notesTable.reloadData()
//        }
//         //notesTable.reloadData()
//    }
//    
//    
//    
//    func presentSettingsActionSheet() {
//        let alert = UIAlertController(title: "Permission to Contacts", message: "This app needs access to contacts in order to ...", preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default) { _ in
//            let url = URL(string: UIApplicationOpenSettingsURLString)!
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(url)
//            } else {
//                // Fallback on earlier versions
//            }
//        })
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        present(alert, animated: true)
//    }
}
