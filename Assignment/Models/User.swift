//
//  User.swift
//  Assignment
//
//  Created by Ellen Wang on 2019/2/16.
//  Copyright © 2019 ellen. All rights reserved.
//

struct User {
    let uid: String
    let username: String
    let bio: String
    let profileImageUrl: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"]  as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
    }
}
