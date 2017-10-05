    //
//  LoginViewController+HandleFunction.swift
//  ChatAppByFireBase
//
//  Created by Mr.小然 on 2017/10/2.
//  Copyright © 2017年 kairan zhai. All rights reserved.
//

import UIKit
import EasyPeasy
import Firebase
import SVProgressHUD

extension LoginViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func segmentControllerPressed(){
        let currentIndex = segmentController.selectedSegmentIndex
        let currentSegmentTitle = segmentController.titleForSegment(at: currentIndex)!
        self.loginAndRegisterButton.setTitle(currentSegmentTitle, for: .normal)
        
        if currentIndex == 1 {
            nickNameTextField.placeholder = ""
            nickNameTextField <- [
                Height(0)
            ]
            
//            confirmedPasswordTextField.placeholder = ""
//            confirmedPasswordTextField <- [
//                Height(0)
//            ]
            
            lineOne <- [
                Height(0)
            ]
            
            lineThree <- [
                Height(0)
            ]
            
            textFieldBackView <- [
                Height(100)
            ]
            
            userImageView.isHidden = true
        }else{
            nickNameTextField.placeholder = "Your Name"
            nickNameTextField <- [
                Height(textFieldHeight)
            ]
            
//            confirmedPasswordTextField.placeholder = "Re-enter Your Password"
//            confirmedPasswordTextField <- [
//                Height(textFieldHeight)
//            ]
            
            lineOne <- [
                Height(1)
            ]
            
            lineThree <- [
                Height(1)
            ]
            
            textFieldBackView <- [
                Height(textFieldContainerHeight)
            ]
            
            userImageView.isHidden = false
        }
        
        //Close keyboard after view changed
        for subView in textFieldBackView.subviews{
            if let textField = subView as? UITextField{
                textField.text = ""
                textField.resignFirstResponder()
            }
        }
        
    }
    
    func registerButtonPressed(){
        loginAndRegisterButton.isUserInteractionEnabled = false
        let currentIndex = segmentController.selectedSegmentIndex
        if currentIndex == 1{
            guard let email = emailTextField.text, let password = passwordTextField.text else {
                return
            }
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error != nil{
                    print((error?.localizedDescription)!)
                    SVProgressHUD.showError(withStatus: "Fail To Login")
                    SVProgressHUD.dismiss(withDelay: 1.0)
                    self.loginAndRegisterButton.isUserInteractionEnabled = true
                    return
                }
                
                
                self.mainViewController?.fetchCurrentUserData()
                self.mainViewController?.getNewMessageFromFireBase()
                
                SVProgressHUD.dismiss(withDelay: 1.0)
                SVProgressHUD.showSuccess(withStatus: "Login Successfully")
                self.dismiss(animated: true, completion: nil)
                self.loginAndRegisterButton.isUserInteractionEnabled = true
            })
        }else{
            guard let email = emailTextField.text, let password = passwordTextField.text, let userName = nickNameTextField.text else {
                return
            }
            
            FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                if error != nil{
                    SVProgressHUD.showError(withStatus: (error?.localizedDescription)!)
                    SVProgressHUD.dismiss(withDelay: 1.0)
                    self.loginAndRegisterButton.isUserInteractionEnabled = true
                    return
                }
                
                let storage = FIRStorage.storage().reference().child("userProfileImage").child("\((user?.uid)!).jpeg")
                // Using UIImageJPEGRepresentation can reduce image size which can help to download fast and save data
                // Because the original image data is about 800KB to 1.2MB, and we dont need that in further
                if let uploadUserImageData = UIImageJPEGRepresentation(self.userImageView.image!, 0.2){
                    storage.put(uploadUserImageData, metadata: nil, completion: { (metaData, error) in
                        
                        if error != nil{
                            SVProgressHUD.showError(withStatus: error?.localizedDescription)
                            SVProgressHUD.dismiss(withDelay: 1.0)
                            self.loginAndRegisterButton.isUserInteractionEnabled = true
                            return
                        }
                        
                        if let userImageUrl = metaData?.downloadURL()?.absoluteString{
                            self.registerWithUserEmailAndUserName(uuid: (user?.uid)!, userName: userName, email: email, userImageUrl: userImageUrl)
                        }
                    })
                }
                
                
                
            }
        }
    }
    
    func registerWithUserEmailAndUserName(uuid: String, userName: String, email: String, userImageUrl: String){
        //Create child node base on different user id
        let reference = FIRDatabase.database().reference(fromURL: "https://chatappbyfirebase-3cf51.firebaseio.com/").child("User").child(uuid)
        let value = ["name": userName, "email": email, "userImageUrl": userImageUrl]
        reference.updateChildValues(value, withCompletionBlock: { (error, reference) in
            if error != nil{
                SVProgressHUD.showError(withStatus: (error?.localizedDescription)!)
                SVProgressHUD.dismiss(withDelay: 1.0)
                self.loginAndRegisterButton.isUserInteractionEnabled = true
                return
            }
            
            self.mainViewController?.fetchCurrentUserData()
            self.mainViewController?.getNewMessageFromFireBase()
            
            SVProgressHUD.dismiss(withDelay: 1.0)
            SVProgressHUD.showInfo(withStatus: "Register Successfully, \(userName)!")
            self.dismiss(animated: true, completion: nil)
            self.loginAndRegisterButton.isUserInteractionEnabled = true

        })
    }
    
    func tapGestureForUserImageView(){
        let imagePickerView = UIImagePickerController()
        imagePickerView.delegate = self
        imagePickerView.allowsEditing = true
        self.present(imagePickerView, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImg = info[UIImagePickerControllerEditedImage] as? UIImage{
            userImageView.image = editedImg
        }else if let originalImg = info[UIImagePickerControllerOriginalImage] as? UIImage{
            userImageView.image = originalImg
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
