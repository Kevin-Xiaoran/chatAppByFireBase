//
//  ChatViewController.swift
//  ChatAppByFireBase
//
//  Created by Mr.小然 on 2017/10/3.
//  Copyright © 2017年 kairan zhai. All rights reserved.
//

import UIKit
import EasyPeasy
import Firebase

class ChatViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var cellId = "cellId"
    var messages = [Message]()
    
    var userData: [String: String] = [:]{
        didSet{
            navigationItem.title = userData["name"]
            
            self.getNewMessageFromFirebase()
        }
    }
    
    let inputChatView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        return view
    }()
    
    let addImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "add3S"), for: .normal)
        button.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(sendImageButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.setTitleColor(self.view.tintColor, for: .normal)
        button.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Message..."
        textField.delegate = self
        textField.backgroundColor = UIColor.white
        
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: FrameAndUiControllersSize.leftPadding, height: 35))
        textField.leftView = leftPadding
        textField.leftViewMode = .always
        
        return textField
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    lazy var messageCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: self.cellId)
        collectionView.backgroundColor = UIColor.white
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        setUpMessageCollectionView()
        setUpInputView()
        
    }

    func setUpInputView(){
        
        
        inputChatView.addSubview(addImageButton)
        addImageButton <- [
            Top(10),
            Bottom(10),
            CenterY(),
            Right(FrameAndUiControllersSize.rightPadding),
            Height(30),
            Width(30)
        ]
        
        inputChatView.addSubview(sendButton)
        sendButton <- [
            Top(5),
            Bottom(5),
            CenterY(),
            Right(FrameAndUiControllersSize.rightPadding).to(addImageButton, .left),
            Width(50),
            Height(40)
        ]
        
        inputChatView.addSubview(inputTextField)
        inputTextField <- [
            Top(7.5),
            Bottom(7.5),
            CenterY(),
            Right(FrameAndUiControllersSize.rightPadding).to(sendButton, .left),
            Left(FrameAndUiControllersSize.leftPadding)
        ]
        
        inputChatView.addSubview(lineView)
        lineView <- [
            Top(),
            Width(view.frame.size.width),
            Height(1)
        ]
        
        view.addSubview(inputChatView)
        inputChatView <- [
            Bottom(),
            Left(),
            Right(),
            Width(view.frame.size.width),
            Height(50)
        ]
    }
    
    func setUpMessageCollectionView(){
        view.addSubview(messageCollectionView)
        messageCollectionView <- [
            Top(),
            Left(),
            Right(),
            Bottom(50)
        ]
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatCollectionViewCell

        let singleMessageModel = self.messages[indexPath.row]
        if let singleMessage = singleMessageModel.message{
            
            //Cant get chatParters so far because its gonna invoke server for several times and its gonna refresh cell for many times
            cell.updateCell(message: singleMessage, bubbleViewWith: self.getCellSizeBaseOnText(text: singleMessage).width + 35, senderId: singleMessageModel.fromId!, currentUserUrl: "")
        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        if let singleMessage = messages[indexPath.row].message{
            height = getCellSizeBaseOnText(text: singleMessage).height + 20
        }
        
        return CGSize(width: view.frame.size.width, height: height)
    }
    
}
