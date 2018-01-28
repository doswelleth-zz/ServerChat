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
    
    func chatPartnerID() -> String {
        return (fromUserID == Auth.auth().currentUser?.uid ? toUserID : fromUserID)!
    }
    
}
