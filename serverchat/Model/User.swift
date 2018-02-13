//
//  User.swift
//  serverchat
//
//  Created by David Oliver Doswell on 1/22/18.
//  Copyright © 2018 David Oliver Doswell. All rights reserved.
//

import Foundation

@objcMembers
public class User: NSObject {
    var id : String?
    var name: String?
    var email: String?
    var serverImageURL: String?
    var isBlocked: String?
}
