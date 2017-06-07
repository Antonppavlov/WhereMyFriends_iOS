//
//  User.swift
//  WhereMyFriends
//
//  Created by Anton Pavlov on 25.05.17.
//  Copyright © 2017 Anton Pavlov. All rights reserved.
//

import Foundation
import Firebase

class Persone {
    
    let name: String!
    let phone: String!
    let photo: String!
    let dateString: String!
    let latitude: Double!
    let longitude: Double!
    let ref: DatabaseReference?
    
    init(snapshot: DataSnapshot) {
        let value = snapshot.value as? NSDictionary
        print(snapshot)
        self.name = value?["name"] as? String
        self.phone = value?["phone"] as? String
         self.photo = value?["photo"] as? String
        self.dateString = value?["dateString"] as? String
        self.latitude = value?["latitude"] as? Double
        self.longitude = value?["longitude"] as? Double

        ref = snapshot.ref
        
    }
}
