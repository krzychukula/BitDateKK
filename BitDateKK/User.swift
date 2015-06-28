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

func pfUserToUser(user: PFUser) -> User {
    return User(id: user.objectId!, name: user.objectForKey("firstName") as! String, pfUser: user)
}

func currentUser() -> User? {
    if let user = PFUser.currentUser() {
        return pfUserToUser(user)
    }
    return nil
}

func fetchUnviewedUsers(callback: ([User]) -> () ) {
    
    let currentUserId = PFUser.currentUser()!.objectId!
    
    var query = PFQuery(className: "Action")
    query.whereKey("byUser", equalTo: currentUserId)
    query.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
        let seenIDS = map(results!, { $0.objectForKey("toUser")! })
        
        var query = PFUser.query()
        query!.whereKey("objectId", notEqualTo: PFUser.currentUser()!.objectId!)
        query!.whereKey("objectId", notContainedIn: seenIDS)
        query!.findObjectsInBackgroundWithBlock({
            objects, error in
            
            if let pfUsers = objects as? [PFUser] {
                let users = map(pfUsers, {pfUserToUser($0)})
                callback(users)
            }
        })
        
    })
    
    return
    
    
}

func saveSkip(user: User){
    saveAction(user, "skipped")
}

func saveLiked(user: User){
    
    var query = PFQuery(className: "Action")
    query.whereKey("byUser", equalTo: user.id)
    query.whereKey("toUser", equalTo: PFUser.currentUser()!.objectId!)
    query.whereKey("type", equalTo: "liked")
    query.getFirstObjectInBackgroundWithBlock({
        object, error in
        
        var matched = false
        if let object = object {
            matched = true
            object.setObject("matched", forKey: "type")
            object.saveInBackgroundWithBlock(nil)
        }
        
        saveAction(user, matched ? "matched" : "liked")
    })
    

    
}

private func saveAction(user: User, type: String){
    let skip = PFObject(className: "Action")
    skip.setObject(PFUser.currentUser()!.objectId!, forKey: "byUser")
    skip.setObject(user.id, forKey: "toUser")
    skip.setObject(type, forKey: "type")
    skip.saveInBackgroundWithBlock(nil)
}


