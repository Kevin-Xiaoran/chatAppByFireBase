//
//  ViewController.swift
//  RatingStarDemo
//
//  Created by Mr.小然 on 2018/8/24.
//  Copyright © 2018年 kairan zhai. All rights reserved.
//

import UIKit
import Cosmos

class OrderReviewViewController: UIViewController {

    @IBOutlet weak var starRatingView: CosmosView!
    
    var ratingScore: Double = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        starRatingView.didFinishTouchingCosmos = didFinishTouchingCosmos(_:)
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showDetailRatingView", sender: nil)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        // Close current window
    }
    
    private func didFinishTouchingCosmos(_ rating: Double) {
        self.ratingScore = rating
        print(self.ratingScore)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueName = segue.identifier {
            switch segueName {
            case "showDetailRatingView":
                let ratingDetailViewController = segue.destination as! RatingDetailViewController
                ratingDetailViewController.fodServiceScore = self.ratingScore
                ratingDetailViewController.restaurantServiceScore = self.ratingScore
            default:
                break
            }
        }
    }
}

