//
//  Match.swift
//  BitDateKK
//
//  Created by Krzysztof Kula on 28/06/15.
//  Copyright (c) 2015 Krzysztof Kula. All rights reserved.
//

import Foundation
import Parse

struct Match {
    let id: String
    let user: User
}

func fetchMatches (callback: ([Match]) -> ()) {
    var query = PFQuery(className: "Action")
    query.whereKey("byUser", equalTo: PFUser.currentUser()!.objectId!)
    query.whereKey("type", equalTo: "matched")
    query.findObjectsInBackgroundWithBlock { (results, error) -> Void in

        if let matches = results as? [PFObject] {

            var matchedUsers: [(matchID: String, userID: String)] = []
            for match in matches {
                let user = (matchID: match.objectId!, userID: match.objectForKey("toUser") as! String)
                matchedUsers.append(user)
            }
            let userIDs = matchedUsers.map({$0.userID});
            

            var query = PFUser.query()
            query!.whereKey("objectId", containedIn: userIDs)
            query!.findObjectsInBackgroundWithBlock({
                objects, error in
                
                if let users = objects as? [PFUser] {
                    var users = reverse(users)
                    var m = Array<Match>()
                    for (index, user) in enumerate(users) {
                        m.append(Match(id: matchedUsers[index].matchID, user: pfUserToUser(user)))
                    }
                    
                    callback(m)
                }
            })


        }
    }
}