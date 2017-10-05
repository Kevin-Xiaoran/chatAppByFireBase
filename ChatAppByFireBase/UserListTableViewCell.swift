//
//  UserListTableViewCell.swift
//  ChatAppByFireBase
//
//  Created by Mr.小然 on 2017/10/2.
//  Copyright © 2017年 kairan zhai. All rights reserved.
//

import UIKit
import EasyPeasy
import Kingfisher

class UserListTableViewCell: UITableViewCell {
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.black
        return imageView
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.text = "User Name"
        return label
    }()
    
    let userEmailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.text = "email"
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(userImageView)
        userImageView <- [
            Top(10),
            Left(FrameAndUiControllersSize.leftPadding),
            Height(60),
            Width(60)
        ]
        
        contentView.addSubview(userNameLabel)
        userNameLabel <- [
            Top(10),
            Left(FrameAndUiControllersSize.leftPadding).to(userImageView, .right),
            Right(FrameAndUiControllersSize.rightPadding + 100),
            Height(25)
        ]
        
        contentView.addSubview(userEmailLabel)
        userEmailLabel <- [
            Bottom(10),
            Left(FrameAndUiControllersSize.leftPadding).to(userImageView, .right),
            Right(FrameAndUiControllersSize.rightPadding),
            Height(25)
        ]
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCell(userName: String, userEmail: String, userImage: String){
        userImageView.image = nil
        let imageUrl = URL(string: userImage)
        userImageView.kf.setImage(with: imageUrl)
        userNameLabel.text = userName
        userEmailLabel.text = userEmail
    }

}
