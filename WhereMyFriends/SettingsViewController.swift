//
//  SettingsViewController.swift
//  WhereMyFriends
//
//  Created by Anton Pavlov on 08.06.17.
//  Copyright © 2017 Anton Pavlov. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var inputLogin: UITextField!
    @IBOutlet weak var imagePhoto: UIImageView!
    
    var imagePicker = UIImagePickerController()
     let storage = LoginStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputLogin.placeholder = storage.fetchLogin()!
        imagePhoto.image = populateImage(imageString: storage.fetchPhoto()!)
    }

    @IBAction func pressButtonChange(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }else{
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
            
        }
    }
   

    @IBAction func pressButtonCancel(_ sender: UIBarButtonItem) {
        inputLogin.text = ""
        imagePhoto.image = populateImage(imageString: storage.fetchPhoto()!)
    }
    

    
    @IBAction func pressButtonSave(_ sender: UIBarButtonItem) {
      
        
        var data:NSData = NSData()
        if let image = imagePhoto.image {
            //компресию сделать больше
            data = UIImageJPEGRepresentation(image, 0.01)! as NSData
        }
        let base64String = data.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
        LoginStorage().save(photo: base64String)
        
        
        
        storage.save(login: inputLogin.text!)
        storage.save(photo: base64String)
        
        inputLogin.text=""
        inputLogin.placeholder = storage.fetchLogin()
    }
    
    
}
extension SettingsViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imagePhoto.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
}
