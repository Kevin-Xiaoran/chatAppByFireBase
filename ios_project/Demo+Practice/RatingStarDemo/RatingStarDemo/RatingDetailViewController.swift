//
//  RatingDetailViewController.swift
//  RatingStarDemo
//
//  Created by Mr.小然 on 2018/8/24.
//  Copyright © 2018年 kairan zhai. All rights reserved.
//

import UIKit
import Cosmos

class RatingDetailViewController: UIViewController {

    @IBOutlet weak var fodServiceRatingView: CosmosView!
    @IBOutlet weak var restaurantRatingView: CosmosView!
    @IBOutlet weak var customerMessageTextField: UITextField!
    
    var fodServiceScore:Double = 0.0
    var restaurantServiceScore:Double = 0.0
    var customerMessage:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initalizedCurrentView()
    }
    
    func initalizedCurrentView(){
        fodServiceRatingView.rating = fodServiceScore
        restaurantRatingView.rating = restaurantServiceScore
        
        // Create a bottom layer for textField
        let bottomBorder = CALayer()
        // Set borderWidth here is to display borderColor on layer. It wont change frame for layer
        bottomBorder.borderWidth = 1
        bottomBorder.borderColor = UIColor.black.cgColor
        bottomBorder.frame = CGRect(x: 0, y: customerMessageTextField.frame.size.height - 2, width: customerMessageTextField.frame.size.width, height: 1)
        customerMessageTextField.layer.addSublayer(bottomBorder)
        customerMessageTextField.layer.masksToBounds = true
    }
    
    func dismissViewAndSubmitValue(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismissViewAndSubmitValue()
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        dismissViewAndSubmitValue()
    }
}
