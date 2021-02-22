import UIKit

var str = "Hello, playground"

struct User {
    
    let uid: String   //B
    var userId: String?  //B
    var pushId: String?   //B
//    var stripeId: String
    let username: String   //shown as user
    var name: String    // first name last name shown as driver
    var dob: String    // D
    var expire: String   //D  ID expire date
    var tax: String    //D     tax number
    var profileImageUrl: String    //U
    var image1: String  //D ID front
    var image2: String   //D ID back
    var image3: String   //D Real pic
    var gender: String   //D
    var email: String  //B
    let creationDate: Date  //B
    var phone: String   //B
    var userType: String    //B   u  d
    var type: String  //B  to see if the driver is proved
    var admin: String   //B
    var lat: Double
    var long: Double
    var biz: String
    var distance: Decimal
    var paymentID: String
    var bizImage1: String  //U inc paper
    var bizImage2: String   //U id front
    var bizImage3: String   //u id back
    var bizImage4: String   //U biz card
    var bizName: String
    var bizType: String   //U pre setup category will provide
    var bizLoc: String
    var bizNo: String
    var bizPpl: String
    var lastChat: Int   //B
    var firstTimeDiscount: String
    var promotionTXTID: String
    var todayPay: Double
    var totalPay: Double
    var balance: Double
    var reference: String
    var referenceCode: String
    var referenceCount: Int
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.userId = dictionary["id"] as? String
//        self.stripeId = dictionary["stripeId"] as? String ?? ""
        self.biz = dictionary["biz"] as? String ?? ""
        self.pushId = dictionary["pushId"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profile_image"]  as? String ?? ""
        self.image1 = dictionary["id_expire"]  as? String ?? ""
        self.image2 = dictionary["id_front"]  as? String ?? ""
        self.image3 = dictionary["driver_photo"]  as? String ?? ""
        self.gender = dictionary["gender"] as? String ?? ""
        self.phone = dictionary["phone_number"] as? String ?? ""
        self.userType = dictionary["UserType"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
        self.type = dictionary["type"] as? String ?? ""
        self.lat = dictionary["latitude"] as? Double ?? 0
        self.long = dictionary["longitude"] as? Double ?? 0
        self.admin = dictionary["admin"] as? String ?? ""
        self.distance = dictionary["distance"] as? Decimal ?? 0.0
        self.dob = dictionary["dob"] as? String ?? ""
        self.expire = dictionary["expire"] as? String ?? ""
        self.tax = dictionary["tax"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.bizImage1 = dictionary["incorporate_file"]  as? String ?? ""
        self.bizImage2 = dictionary["id_front"]  as? String ?? ""
        self.bizImage3 = dictionary["id_back"]  as? String ?? ""
        self.bizImage4 = dictionary["biz_card"]  as? String ?? ""
        self.bizName = dictionary["bizName"]  as? String ?? ""
        self.bizType = dictionary["bizType"]  as? String ?? ""
        self.bizLoc = dictionary["bizLoc"]  as? String ?? ""
        self.bizNo = dictionary["bizNo"]  as? String ?? ""
        self.bizPpl = dictionary["bizPpl"]  as? String ?? ""
        self.paymentID = dictionary["payfirmaId"] as? String ?? ""
        self.lastChat = dictionary["LC"] as? Int ?? 0
        self.firstTimeDiscount = dictionary["T1"] as? String ?? ""
        self.promotionTXTID = dictionary["PromoID"] as? String ?? ""
        self.todayPay = dictionary["todayP"] as? Double ?? 0.0
        self.totalPay = dictionary["totalP"] as? Double ?? 0.0
        self.balance = dictionary["balance"] as? Double ?? 0.0
        self.reference = dictionary["reference"] as? String ?? ""
        self.referenceCode = dictionary["referenceCode"] as? String ?? ""
        self.referenceCount = dictionary["referenceCount"] as? Int ?? 0
    }
}

var user: User?
user = User(uid: "1", dictionary: [String: Any]())
print(user == nil)
