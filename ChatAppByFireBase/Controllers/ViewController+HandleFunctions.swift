//
//  ViewController+HandleFunctions.swift
//  ChatAppByFireBase
//
//  Created by Mr.小然 on 2017/10/3.
//  Copyright © 2017年 kairan zhai. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

extension ViewController{

    func getNewMessageFromFireBase(){
        guard let uuid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("user-message").child(uuid)
        ref.observe(.childAdded, with: { (snapShot) in
            
            let messageId = snapShot.key
            let newRef = FIRDatabase.database().reference().child("message").child(messageId)
            newRef.observeSingleEvent(of: .value, with: { (snapShot) in
                
                if let messageDict = snapShot.value as? [String: AnyObject]{
                    let messageModel = Message()
                    messageModel.setValuesForKeys(messageDict)
                    
                    if let toId = messageModel.getRealReceiverId(){
                        self.messageDictonary[toId] = messageModel
                        self.messages = Array(self.messageDictonary.values)
                        
                        //Keep the lastest message on the top base on timeStamp
                        self.messages.sort(by: { (message1, message2) -> Bool in
                            return Double(message1.timeStamp!)! > Double(message2.timeStamp!)!
                        })
                        
                        self.timer?.invalidate()
                        
                        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                    }
                }
            }, withCancel: nil)
            
        }, withCancel:nil)
    }
    
    func handleReloadTable() {
        self.messageTableView.reloadData()
    }
    
    //After login successfully, fetch current user data
    func fetchCurrentUserData(){
        messages.removeAll()
        messageDictonary.removeAll()
        messageTableView.reloadData()
        
        guard let userID = FIRAuth.auth()?.currentUser?.uid else {
            SVProgressHUD.showError(withStatus: "Please Check the Internet")
            SVProgressHUD.dismiss(withDelay: 1.0)
            return
        }
        
        let ref = FIRDatabase.database().reference()
        ref.child("User").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.title = value?["name"] as? String
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    //Go to login View And log out from current user
    func logoutButtonPressed(){
        
        //Clean cache and uuid
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        //Using Presenting func so that we dont need to hide navi bar
        let loginViewController = LoginViewController()
        loginViewController.mainViewController = self
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    // Go to user list view to find out other users
    func pushToUserListView(){
        let userListView = UserListViewController()
        userListView.mainViewController = self
        _ = self.navigationController?.pushViewController(userListView, animated: true)
    }
}
