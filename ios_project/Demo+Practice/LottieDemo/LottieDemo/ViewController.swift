//
//  ViewController.swift
//  LottieDemo
//
//  Created by Mr.小然 on 2019-02-27.
//  Copyright © 2019 Mr.小然. All rights reserved.
//

import UIKit
import Lottie

class ViewController: UIViewController {

    @IBOutlet weak var lottieView: LOTAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func playButton(_ sender: Any) {
        lottieView.play()
    }
}

