//
//  FirebaseUtils.swift
//  Assignment
//
//  Created by Ellen Wang on 2019/2/18.
//  Copyright © 2019 ellen. All rights reserved.
//

import Foundation
import Firebase

extension Firestore {
    
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
        
        Firestore.firestore().collection("users").document(uid).getDocument(){ (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                guard let userDictionary = snapshot!.data() as? [String: Any] else { return }
                let user = User(uid: uid, dictionary: userDictionary)
                completion(user)
                
            }
        }
    }
}
