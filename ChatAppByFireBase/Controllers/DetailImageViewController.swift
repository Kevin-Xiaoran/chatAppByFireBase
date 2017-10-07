//
//  DetailImageViewController.swift
//  ChatAppByFireBase
//
//  Created by Mr.小然 on 2017/10/6.
//  Copyright © 2017年 kairan zhai. All rights reserved.
//

import UIKit
import EasyPeasy

class DetailImageViewController: UIViewController {
    
    var timeStamp: String?
    var imageUrlString: String?
    
    let detailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpDetailImageViewController()
    }
    
    func setUpDetailImageViewController(){
        if let timeStamp = timeStamp, let imageUrl = imageUrlString{
            let date = NSDate(timeIntervalSince1970: Double(timeStamp)!)
            let dateFormmater = DateFormatter()
            dateFormmater.dateFormat = "YYYY/MM hh:mm"
            self.title = dateFormmater.string(from: date as Date)
            
            let imageURL = URL(string: imageUrl)
            view.addSubview(detailImageView)
            detailImageView.kf.setImage(with: imageURL)
            detailImageView <- [
                Top(150),
                CenterX(),
                CenterY(),
                Height(230),
                Width(view.frame.size.width)
            ]
        }
    }
}
