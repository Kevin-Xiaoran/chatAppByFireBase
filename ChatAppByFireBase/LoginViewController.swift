//
//  LoginViewController.swift
//  ChatAppByFireBase
//
//  Created by Mr.小然 on 2017/10/1.
//  Copyright © 2017年 kairan zhai. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate{
    var textFieldHeight: CGFloat = 50
    var textFieldContainerHeight: CGFloat = 150
    
    weak var mainViewController: ViewController?
    
    lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "add1")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 70
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.white
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureForUserImageView)))
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    lazy var segmentController: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Register", "Login"])
        segment.backgroundColor = UIColor.myAppBlueColor
        segment.layer.cornerRadius = 5
        segment.layer.borderWidth = 1
        segment.layer.borderColor = UIColor.white.cgColor
        segment.clipsToBounds = true
        segment.selectedSegmentIndex = 1
        segment.tintColor = UIColor.white
        segment.addTarget(self, action: #selector(segmentControllerPressed), for: .valueChanged)
        return segment
    }()
    
    let nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Your Name"
        return textField
    }()
    
    let lineOne: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        return line
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Your Email"
        return textField
    }()
    
    let lineTwo: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        return line
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Your Password"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let lineThree: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        return line
    }()
    
//    let confirmedPasswordTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Re-enter Your Password"
//        textField.isSecureTextEntry = true
//        return textField
//    }()
    
    let textFieldBackView: UIView = {
        let littleView = UIView()
        littleView.backgroundColor = UIColor.white
        littleView.layer.cornerRadius = 5
        littleView.clipsToBounds = true
        return littleView
    }()
    
    lazy var loginAndRegisterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.myAppBlueColor
        button.setTitle("Login", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.myAppBlueColor
        
        addingUserImageView()
        addingSegmentControlView()
        addingTextFieldContainer()
        addingLoginAndRegisterButton()
        
        segmentControllerPressed()
    }

}

extension UIColor{
    static var myAppBlueColor: UIColor{
        return UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
    }
}
