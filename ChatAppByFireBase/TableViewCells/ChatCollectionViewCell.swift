//
//  ChatCollectionViewCell.swift
//  ChatAppByFireBase
//
//  Created by Mr.小然 on 2017/10/4.
//  Copyright © 2017年 kairan zhai. All rights reserved.
//

import UIKit
import EasyPeasy
import Firebase
import Kingfisher

class ChatCollectionViewCell: UICollectionViewCell {
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = view.tintColor
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    let currentUserImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.blue
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let chatPartnerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.red
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(bubbleView)
        contentView.addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCell(message: String, bubbleViewWith: CGFloat, senderId: String, currentUserUrl: String){
        textLabel.text = message
        
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            if senderId == uid {
                bubbleView.backgroundColor = self.tintColor
                
                
                bubbleView <- [
                    Top(),
                    Bottom(),
                    CenterY(),
                    Right(FrameAndUiControllersSize.rightPadding*2 + 40),
                    Left(UIScreen.main.bounds.size.width - FrameAndUiControllersSize.leftPadding*2 - bubbleViewWith - 40),
                    Width(bubbleViewWith)
                ]
                
                chatPartnerImageView.removeFromSuperview()
                contentView.addSubview(currentUserImageView)
                currentUserImageView <- [
                    Top(),
                    Right(FrameAndUiControllersSize.rightPadding),
                    Width(40),
                    Height(40)
                ]
                
//                let currentUserImageUrl = URL(string: currentUserUrl)
//                currentUserImageView.kf.setImage(with: currentUserImageUrl)
                
            }else{
                bubbleView.backgroundColor = UIColor.lightGray
                
                bubbleView <- [
                    Top(),
                    Bottom(),
                    CenterY(),
                    Left(FrameAndUiControllersSize.rightPadding*2 + 40),
                    Right(UIScreen.main.bounds.size.width - FrameAndUiControllersSize.rightPadding*2 - bubbleViewWith - 40),
                    Width(bubbleViewWith)
                ]
                
                currentUserImageView.removeFromSuperview()
                contentView.addSubview(chatPartnerImageView)
                chatPartnerImageView <- [
                    Top(),
                    Left(FrameAndUiControllersSize.rightPadding),
                    Width(40),
                    Height(40)
                ]
                
//                let chatPartnerImageUrl = URL(string: currentUserUrl)
//                chatPartnerImageView.kf.setImage(with: chatPartnerImageUrl)
            }
            
            textLabel <- [
                Top(5),
                Bottom(5),
                CenterY(),
                Right(FrameAndUiControllersSize.rightPadding).to(bubbleView, .right),
                Left(FrameAndUiControllersSize.leftPadding).to(bubbleView, .left)
            ]
        }
    }

}
