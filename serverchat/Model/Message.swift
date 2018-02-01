//
//  Message.swift
//  serverchat
//
//  Created by David Oliver Doswell on 1/27/18.
//  Copyright © 2018 David Oliver Doswell. All rights reserved.
//

import UIKit
import Firebase

@objcMembers
public class Message : NSObject {
    var fromUserID: String?
    var text: String?
    var timestamp: NSNumber?
    var toUserID: String?
    var imageURL: String?
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    
    func chatPartnerID() -> String? {
        return (fromUserID == Auth.auth().currentUser?.uid ? toUserID : fromUserID)!
    }
    
    init(dictionary: [String:AnyObject]) {
        super.init()
        
        fromUserID = dictionary["fromUserID"] as? String
        text = dictionary["text"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        toUserID = dictionary["toUserID"] as? String
        imageURL = dictionary["imageURL"] as? String
        imageWidth = dictionary["imageWidth"] as? NSNumber
        imageHeight = dictionary["imageHeight"] as? NSNumber
    }
    
}
