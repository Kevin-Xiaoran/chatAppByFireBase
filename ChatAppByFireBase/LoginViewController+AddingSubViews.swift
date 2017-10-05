//
//  LoginViewController+AddingSubViews.swift
//  ChatAppByFireBase
//
//  Created by Mr.小然 on 2017/10/1.
//  Copyright © 2017年 kairan zhai. All rights reserved.
//

import UIKit
import EasyPeasy

extension LoginViewController{
    
    func addingUserImageView(){
        view.addSubview(userImageView)
        userImageView <- [
            Top(60),
            CenterX(),
            Width(140),
            Height(140)
        ]
    }
    
    func addingSegmentControlView(){
        view.addSubview(segmentController)
        segmentController <- [
            Top(20).to(userImageView, .bottom),
            CenterX(),
            Left(FrameAndUiControllersSize.leftPadding),
            Right(FrameAndUiControllersSize.rightPadding),
            Height(FrameAndUiControllersSize.buttonHeight)
        ]
    }
    
    func addingTextFieldContainer(){
        view.addSubview(textFieldBackView)
        textFieldBackView <- [
            Top(20).to(segmentController, .bottom),
            CenterX(),
            Left(FrameAndUiControllersSize.leftPadding),
            Right(FrameAndUiControllersSize.rightPadding),
            Height(textFieldContainerHeight)
        ]
        
        textFieldBackView.addSubview(nickNameTextField)
        nickNameTextField <- [
            Top().to(textFieldBackView, .top),
            Left(FrameAndUiControllersSize.leftPadding),
            Right(),
            Height(textFieldHeight)
        ]
        
        textFieldBackView.addSubview(emailTextField)
        emailTextField <- [
            Top().to(nickNameTextField, .bottom),
            Left(FrameAndUiControllersSize.leftPadding),
            Right(),
            Height(textFieldHeight)
        ]
        
        textFieldBackView.addSubview(passwordTextField)
        passwordTextField <- [
            Top().to(emailTextField, .bottom),
            Left(FrameAndUiControllersSize.leftPadding),
            Right(),
            Height(textFieldHeight)
        ]
        
        textFieldBackView.addSubview(confirmedPasswordTextField)
        confirmedPasswordTextField <- [
            Top().to(passwordTextField, .bottom),
            Left(FrameAndUiControllersSize.leftPadding),
            Right(),
            Height(textFieldHeight)
        ]
        
        textFieldBackView.addSubview(lineOne)
        lineOne <- [
            Top().to(emailTextField, .top),
            Left(FrameAndUiControllersSize.leftPadding),
            Right(),
            Height(1)
        ]
        
        textFieldBackView.addSubview(lineTwo)
        lineTwo <- [
            Top().to(passwordTextField, .top),
            Left(FrameAndUiControllersSize.leftPadding),
            Right(),
            Height(1)
        ]
        
        textFieldBackView.addSubview(lineThree)
        lineThree <- [
            Top().to(confirmedPasswordTextField, .top),
            Left(FrameAndUiControllersSize.leftPadding),
            Right(),
            Height(1)
        ]
    }
    
    func addingLoginAndRegisterButton(){
        view.addSubview(loginAndRegisterButton)
        loginAndRegisterButton <- [
            Top(20).to(textFieldBackView, .bottom),
            CenterX(),
            Left(FrameAndUiControllersSize.leftPadding),
            Right(FrameAndUiControllersSize.rightPadding),
            Height(FrameAndUiControllersSize.buttonHeight)
        ]
    }

}
