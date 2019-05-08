//
//  Post.swift
//  Assignment
//
//  Created by Ellen Wang on 2019/2/17.
//  Copyright © 2019 ellen. All rights reserved.
//

import Foundation


struct Post {
    
    var id: String?
    
    let user: User
    let imageUrl: String
    let caption: String
    let creationDate: Date
    let hashtag: Array<String>
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
        self.hashtag = dictionary["hashtag"] as? Array<String> ?? [""]
    }
}
