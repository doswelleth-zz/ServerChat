//
//  LoginController+helpers.swift
//  serverchat
//
//  Created by David Oliver Doswell on 1/23/18.
//  Copyright © 2018 David Oliver Doswell. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
    // Log in new server with credentials
    @objc func joinTap(sender:UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else  { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
            
            guard let uid = user?.uid else { return }
            
            let imageID = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("\(imageID).jpg")
            
            if let serverImage = self.serverImage.image, let uploadData = UIImageJPEGRepresentation(serverImage, 0.1) {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print("Error: ", error?.localizedDescription as Any)
                    }
                    if let serverImageURL = metadata?.downloadURL()?.absoluteString {
                        let values = ["name": name, "email": email, "serverImageURL": serverImageURL]
                        self.createNewServer(uid: uid, values: values as [String : AnyObject])
                    }
                })
            }
        }
    }
    
    // Enter server in our database
    func createNewServer(uid: String, values: [String:AnyObject]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err as Any)
            }
            let user = User()
            user.setValuesForKeys(values)
            self.messagesTableViewController?.setUpNavBarWithUser(user: user)
            
            let destination = MessageTableViewController()
            self.navigationController?.pushViewController(destination, animated: true)
        })
    }
    
    // Handle image tapped
    @objc func serverImageTap() {
        DispatchQueue.main.async {
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    // Replace preview image with selected image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedPickerImage: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedPickerImage = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedPickerImage = originalImage
        }
        if let selectedImage = selectedPickerImage {
             DispatchQueue.main.async {
                self.serverImage.image = selectedImage
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    // Dimiss picker controller when finished
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}








