//
//  ChatViewController+HanldeFunction.swift
//  ChatAppByFireBase
//
//  Created by Mr.小然 on 2017/10/4.
//  Copyright © 2017年 kairan zhai. All rights reserved.
//

import UIKit
import Firebase

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
                    
                    let senderReference = FIRDatabase.database().reference().child("user-message").child(fromId!)
                    let childId = childMessageId.key
                    senderReference.updateChildValues([childId: 1])
                    
                    let receiverReference = FIRDatabase.database().reference().child("user-message").child(toId!)
                    receiverReference.updateChildValues([childId: 1])
                })
                
                inputTextField.text = ""
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
        print("You pressed send image button")
    }
    
    func getNewMessageFromFirebase(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("user-message").child(uid)
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
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    func getCellSizeBaseOnText(text: String) -> CGRect{
        let size = CGSize(width: 200, height: 1000)
        let option = NSStringDrawingOptions.usesLineFragmentOrigin.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: option, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }

    func scrollToBottom(){
        let lastItem = collectionView(self.messageCollectionView, numberOfItemsInSection: 0) - 1
        if lastItem >= 1{
            let indexPath: NSIndexPath = NSIndexPath.init(item: lastItem, section: 0)
            self.messageCollectionView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
        }
    }
}