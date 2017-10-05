//
//  messageTableViewCell.swift
//  ChatAppByFireBase
//
//  Created by Mr.小然 on 2017/10/3.
//  Copyright © 2017年 kairan zhai. All rights reserved.
//

import UIKit
import EasyPeasy
import Kingfisher

class messageTableViewCell: UserListTableViewCell {

    let timeStampLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.sizeToFit()
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(timeStampLabel)
        timeStampLabel <- [
            Top(5),
            Right(FrameAndUiControllersSize.rightPadding)
        ]
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateMessageCell(userName: String, userEmail: String, userImage: String, timeStamp: String) {
        userImageView.image = nil
        let imageUrl = URL(string: userImage)
        userImageView.kf.setImage(with: imageUrl)
        
        userNameLabel.text = userName
        userEmailLabel.text = userEmail
        
        let date = NSDate(timeIntervalSince1970: Double(timeStamp)!)
        let dateFormmater = DateFormatter()
        dateFormmater.dateFormat = "hh:mm a"
        timeStampLabel.text = dateFormmater.string(from: date as Date)
    }

}
