//
//  ChatViewController+HanldeFunction.swift
//  ChatAppByFireBase
//
//  Created by Mr.小然 on 2017/10/4.
//  Copyright © 2017年 kairan zhai. All rights reserved.
//

import UIKit
import Firebase
import EasyPeasy
import AVFoundation
import MobileCoreServices
import SVProgressHUD

extension ChatViewController{
    func sendButtonPressed(){
        if let message = inputTextField.text{
            if message != ""{
                let ref = FIRDatabase.database().reference().child("message")
                let childMessageId = ref.childByAutoId()
                
                let toId = self.userData["uuid"]
                let fromId = FIRAuth.auth()?.currentUser?.uid
                let timeStamp = String(NSDate().timeIntervalSince1970)
                let valueDictonary = ["message": message, "toId": toId, "fromId": fromId, "timeStamp": timeStamp] as! [String: String]
                
                childMessageId.updateChildValues(valueDictonary, withCompletionBlock: { (error, ref) in
                    if error != nil{
                        print((error?.localizedDescription)!)
                        return
                    }
                    //Create Sub Node For Chat
                    //For Example: A -> Message -> B
                    //New Node Tree: user-message -> A -> B -> [Message]
                    //               user-message -> B -> A -> [Message] as well
                    let senderReference = FIRDatabase.database().reference().child("user-message").child(fromId!).child(toId!)
                    let childId = childMessageId.key
                    senderReference.updateChildValues([childId: 1])
                    
                    let receiverReference = FIRDatabase.database().reference().child("user-message").child(toId!).child(fromId!)
                    receiverReference.updateChildValues([childId: 1])
                })
                
                inputTextField.text = ""
//                inputTextField.resignFirstResponder()
                self.didSendMessage = true
                self.scrollToBottom()
                
            }
        }
        print("You pressed send button")
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendButtonPressed()
        inputTextField.resignFirstResponder()
        
        return true
    }
    
    func sendImageButtonPressed(){
        let imagePickerView = UIImagePickerController()
        imagePickerView.delegate = self
        imagePickerView.allowsEditing = true
        imagePickerView.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
        self.present(imagePickerView, animated: true, completion: nil)
        
        print("You pressed send image button")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageOptional: UIImage?
        
        if let vedioUrl = info[UIImagePickerControllerMediaURL] as? URL{
            let fileName = "vedioFile"
            let ref = FIRStorage.storage().reference().child("message-vedios").child(fileName).putFile(vedioUrl, metadata: nil, completion: { (metaData, error) in
                if error != nil{
                    print((error?.localizedDescription)!)
                    return
                }
                
                if let vedioUrlString = metaData?.downloadURL()?.absoluteString{
                    self.uploadVedioToFireBase(vedioUrlString: vedioUrlString)
                    
                }
            })
            
            ref.observe(.progress, handler: { (snapShot) in
                if let progressFloat = snapShot.progress?.fractionCompleted{
                    SVProgressHUD.showProgress(Float(progressFloat))
                }
            })
            
            ref.observe(.success, handler: { (snapShot) in
                SVProgressHUD.showInfo(withStatus: "Upload Successfully")
                SVProgressHUD.dismiss(withDelay: 1.0)
            })
        }else{
            if let editedImg = info[UIImagePickerControllerEditedImage] as? UIImage{
                selectedImageOptional = editedImg
            }else if let originalImg = info[UIImagePickerControllerOriginalImage] as? UIImage{
                selectedImageOptional = originalImg
            }
            
            if let selectedImage = selectedImageOptional{
                uploadImageToFireBase(image: selectedImage)
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    private func uploadImageToFireBase(image: UIImage){
        let imageName = NSUUID().uuidString
        let ref = FIRStorage.storage().reference().child("message-image").child("\(imageName).jpeg")
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.2){
            ref.put(uploadData, metadata: nil) { (metaData, error) in
                
                if let uploadImageUrl = metaData?.downloadURL()?.absoluteString{
                    self.sendImageMessageToFirebase(imageUrl: uploadImageUrl)
                }
            }
        }
    }
    
    private func uploadVedioToFireBase(vedioUrlString: String){
        let ref = FIRDatabase.database().reference().child("message")
        let childMessageId = ref.childByAutoId()
        
        let toId = self.userData["uuid"]
        let fromId = FIRAuth.auth()?.currentUser?.uid
        let timeStamp = String(NSDate().timeIntervalSince1970)
        let valueDictonary = ["vedioUrl": vedioUrlString, "toId": toId, "fromId": fromId, "timeStamp": timeStamp] as! [String: String]
        
        childMessageId.updateChildValues(valueDictonary, withCompletionBlock: { (error, ref) in
            if error != nil{
                print((error?.localizedDescription)!)
                return
            }
            
            let senderReference = FIRDatabase.database().reference().child("user-message").child(fromId!).child(toId!)
            let childId = childMessageId.key
            senderReference.updateChildValues([childId: 1])
            
            let receiverReference = FIRDatabase.database().reference().child("user-message").child(toId!).child(fromId!)
            receiverReference.updateChildValues([childId: 1])
            
            self.didSendMessage = false
        })
        
        self.scrollToBottom()
    }
    
    func sendImageMessageToFirebase(imageUrl: String){
        let ref = FIRDatabase.database().reference().child("message")
        let childMessageId = ref.childByAutoId()
        
        let toId = self.userData["uuid"]
        let fromId = FIRAuth.auth()?.currentUser?.uid
        let timeStamp = String(NSDate().timeIntervalSince1970)
        let valueDictonary = ["imageUrl": imageUrl, "toId": toId, "fromId": fromId, "timeStamp": timeStamp] as! [String: String]
        
        childMessageId.updateChildValues(valueDictonary, withCompletionBlock: { (error, ref) in
            if error != nil{
                print((error?.localizedDescription)!)
                return
            }
            
            let senderReference = FIRDatabase.database().reference().child("user-message").child(fromId!).child(toId!)
            let childId = childMessageId.key
            senderReference.updateChildValues([childId: 1])
            
            let receiverReference = FIRDatabase.database().reference().child("user-message").child(toId!).child(fromId!)
            receiverReference.updateChildValues([childId: 1])
            
            self.didSendMessage = false
        })
        
        self.scrollToBottom()
    }
    
    func getNewMessageFromFirebase(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid, let userId = self.userData["uuid"] else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("user-message").child(uid).child(userId)
        ref.observe(.childAdded, with: { (snapShot) in
            let messageId = snapShot.key
            let messageRef = FIRDatabase.database().reference().child("message").child(messageId)
            messageRef.observeSingleEvent(of: .value, with: { (snapShot) in
                
                guard let messageDict = snapShot.value as? [String: String] else{
                    return
                }
                
                let messageModel = Message()
                messageModel.setValuesForKeys(messageDict)
                if messageModel.getRealReceiverId() ==  self.userData["uuid"]{
                    self.messages.append(messageModel)
                    self.messageCollectionView.reloadData()
                    self.scrollToBottom()
                }
                
                if self.didSendMessage{
                    self.inputChatView <- [
                        Bottom(self.keyBoardHeight),
                        Left(),
                        Right(),
                        Width(self.view.frame.size.width),
                        Height(50)
                    ]
                    
                    self.messageCollectionView <- [
                        Top(),
                        Left(),
                        Right(),
                        Height(self.view.frame.size.height - self.keyBoardHeight - 50)
                    ]
                    
                }
                
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    
    func getCellSizeBaseOnText(text: String) -> CGRect{
        let size = CGSize(width: 200, height: 1000)
        let option = NSStringDrawingOptions.usesLineFragmentOrigin.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: option, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }

    func scrollToBottom(){
        print(self.messageCollectionView.frame.size.height)
        let lastItem = collectionView(self.messageCollectionView, numberOfItemsInSection: 0) - 1
        if lastItem >= 1{
            let indexPath: NSIndexPath = NSIndexPath.init(item: lastItem, section: 0)
            self.messageCollectionView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
        }
    }
    
    func keyBoardWillShow(note: Notification){
        let viewFrame = view.frame.size
        
        //Get UserInfo
        let userInfo = note.userInfo
        
        //Get keyBoardFrame
        let keyBoardBounds = userInfo?[UIKeyboardFrameEndUserInfoKey] as! CGRect
        let keyBoardHeight = keyBoardBounds.size.height
        self.keyBoardHeight = keyBoardHeight
        print("keyBoardHeight: \(keyBoardHeight)")
        
        //Get keyBoard raise up time
        let keyBoardRaiseUpTime = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        print("keyBoardRaiseUpTime: \(keyBoardRaiseUpTime)")
        
        UIView.animate(withDuration: keyBoardRaiseUpTime ) {
            self.messageCollectionView.frame = CGRect(x: 0, y: 0, width: viewFrame.width, height: viewFrame.height - self.keyBoardHeight - 50)
            
            self.inputChatView <- [
                Bottom(self.keyBoardHeight),
                Left(),
                Right(),
                Width(viewFrame.width),
                Height(50)
            ]
            
            self.messageCollectionView <- [
                Top(),
                Left(),
                Right(),
                Height(viewFrame.height - self.keyBoardHeight - 50)
            ]
            
            self.scrollToBottom()
            print("When keyboard shows: \(self.messageCollectionView.frame.size.height)")
        }
    }
    
    func keyBoardWillHide(note: Notification){
        let viewFrame = view.frame.size
        
        //Get UserInfo
        let userInfo = note.userInfo
        
        //Get keyBoard drop down time
        let keyBoardDropDownTime = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        print("keyBoardDropDownTime: \(keyBoardDropDownTime)")
        
        UIView.animate(withDuration: keyBoardDropDownTime ) {
        
            self.inputChatView <- [
                Bottom(),
                Left(),
                Right(),
                Width(viewFrame.width),
                Height(50)
            ]
            
            self.messageCollectionView <- [
                Top(),
                Left(),
                Right(),
                Height(viewFrame.height - 50)
            ]
            
            self.scrollToBottom()
            print("When keyboard hides: \(self.messageCollectionView.frame.size.height)")
        }
    }
    
    func pushToDetailImageViewController(imageUrlString: String, timeStamp: String){
        let detailImageViewController = DetailImageViewController()
        detailImageViewController.imageUrlString = imageUrlString
        detailImageViewController.timeStamp = timeStamp
        _ = self.navigationController?.pushViewController(detailImageViewController, animated: false)
    }
}
