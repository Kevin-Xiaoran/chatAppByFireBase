//
//  Message.swift
//  ChatAppByFireBase
//
//  Created by Mr.小然 on 2017/10/3.
//  Copyright © 2017年 kairan zhai. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {

    var fromId: String?
    var message: String?
    var timeStamp: String?
    var toId: String?
    
    //if user A send message to user B
    //In user A view, the receiver should be user B
    //However, in user B view, the actual receiver is user A
    func getRealReceiverId() -> String?{
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId! : fromId!
    }
}
