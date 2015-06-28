//
//  User.swift
//  BitDateKK
//
//  Created by Krzysztof Kula on 26/06/15.
//  Copyright (c) 2015 Krzysztof Kula. All rights reserved.
//

import Foundation
import Parse

struct User {
    let id: String
    let name: String
    private let pfUser: PFUser
    
    func getPhoto(callback: (UIImage) -> () ) {
        let imageFile = pfUser.objectForKey("picture") as! PFFile
        imageFile.getDataInBackgroundWithBlock({
            data, error in
            
            if let data = data {
                callback(UIImage(data: data)!)
            }
        })
        
    }
}

private func pfUserToUser(user: PFUser) -> User {
    return User(id: user.objectId!, name: user.objectForKey("firstName") as! String, pfUser: user)
}

func currentUser() -> User? {
    if let user = PFUser.currentUser() {
        return pfUserToUser(user)
    }
    return nil
}

func fetchUnviewedUsers(callback: ([User]) -> () ) {
    var query = PFUser.query()
    query!.whereKey("objectId", notEqualTo: PFUser.currentUser()!.objectId!)
    query!.findObjectsInBackgroundWithBlock({
        objects, error in
        
        if let pfUsers = objects as? [PFUser] {
            let users = map(pfUsers, { pfUserToUser($0) })
            callback(users)
        }
        
    })
}