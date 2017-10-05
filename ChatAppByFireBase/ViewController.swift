//
//  ViewController.swift
//  ChatAppByFireBase
//
//  Created by Mr.小然 on 2017/9/28.
//  Copyright © 2017年 kairan zhai. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase
import EasyPeasy

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var messages = [Message]()
    var messageDictonary = [String: Message]()
    var timer: Timer?
    
    let cellId = "Cell"
    lazy var messageTableView: UITableView = {
        let tableView = UITableView(frame:CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(messageTableViewCell.self, forCellReuseIdentifier: self.cellId)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonPressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pushToUserListView))
        
        setUpMessageTableView()
        getNewMessageFromFireBase()
        
        //Check if user has logged in or not
        if FIRAuth.auth()?.currentUser?.uid == nil {
            //No one has logged in
            logoutButtonPressed()
        }else{
            //Some one successfully login
            fetchCurrentUserData()
        }
        
    }
    
    func setUpMessageTableView(){
        view.addSubview(messageTableView)
        messageTableView <- [
            Top(),
            Left(),
            Bottom(),
            Right()
        ]
    }
    
        
    func pushToUserChatView(userData: [String: String]){
        let userChatView = ChatViewController()
        userChatView.userData = userData
        _ = self.navigationController?.pushViewController(userChatView, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! messageTableViewCell
        
        let singleMessage = self.messages[indexPath.row]
        
        if let toId = singleMessage.getRealReceiverId(){
            //Get user data base on user id
            let toRef = FIRDatabase.database().reference().child("User").child(toId)
            toRef.observeSingleEvent(of: .value, with: { (snapShot) in
                if let userData = snapShot.value as? [String: String]{
                    
                    cell.updateMessageCell(userName: userData["name"]!, userEmail: singleMessage.message!, userImage: userData["userImageUrl"]!, timeStamp: singleMessage.timeStamp!)
                }
            })

        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleMessage = messages[indexPath.row]
        guard let realReceiverId = singleMessage.getRealReceiverId() else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("User").child(realReceiverId)
        ref.observeSingleEvent(of: .value, with: { (snapShot) in
            
            if let value = snapShot.value as? [String: String]{
                print("loading")
                var userData = value
                userData["uuid"] = realReceiverId
                self.pushToUserChatView(userData: userData)
            }
        }, withCancel: nil)
    }

}

