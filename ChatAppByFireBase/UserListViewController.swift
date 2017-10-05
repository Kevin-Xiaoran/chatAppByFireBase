//
//  UserListViewController.swift
//  ChatAppByFireBase
//
//  Created by Mr.小然 on 2017/10/2.
//  Copyright © 2017年 kairan zhai. All rights reserved.
//

import UIKit
import EasyPeasy
import Firebase

class UserListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    weak var mainViewController: ViewController?
    let cellId = "Cell"
    lazy var userListTableView: UITableView = {
        let tableView = UITableView(frame:CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserListTableViewCell.self, forCellReuseIdentifier: self.cellId)
        return tableView
    }()
    
    var userDataList = [[String: String]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let ref = FIRDatabase.database().reference()
        ref.child("User").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if let value = snapshot.value as? NSDictionary{
                for singleDict in value{
                    var userData = singleDict.value as! [String: String]
                    userData["uuid"] = singleDict.key as? String
                    self.userDataList.append(userData)
                }
                self.userListTableView.reloadData()
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        view.addSubview(userListTableView)
        userListTableView <- [
            Top(),
            Left(),
            Right(),
            Bottom()
        ]
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserListTableViewCell
        let indexPathRow = indexPath.row
        if let userName = self.userDataList[indexPathRow]["name"], let userEmail = self.userDataList[indexPathRow]["email"],
            let userImage = self.userDataList[indexPathRow]["userImageUrl"]{
            cell.updateCell(userName: userName, userEmail: userEmail, userImage: userImage)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userData = self.userDataList[indexPath.row]
        self.navigationController?.popViewController(animated: false)
        self.mainViewController?.pushToUserChatView(userData: userData)
    }
   
}
