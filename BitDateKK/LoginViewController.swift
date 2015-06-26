//
//  LoginViewController.swift
//  BitDateKK
//
//  Created by Krzysztof Kula on 26/06/15.
//  Copyright (c) 2015 Krzysztof Kula. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressedFBLogin(sender: UIButton) {
        PFFacebookUtils.logInWithPermissions(["public_profile", "user_about_me", "user_birthday"], block: { (
            user, error) -> Void in
            
            if user == nil {
                println("user canceled facebook login")
                //TODO: alert about it
                return
            }else if user!.isNew {
                
                if let user = user {
                    println("user signed up and logged in through facebook")
                    
                    FBRequestConnection.startWithGraphPath("/me?fields=picture,first_name,birthday,gender", completionHandler: { connection, result, error in
                        
                    
                        if let r = result as? NSDictionary {
                            //var r = result as! NSDictionary
                            user["firstName"] = r["first_name"]
                            user["gender"] = r["gender"]
                            
                            user["picture"] = ((r["picture"] as! NSDictionary)["data"] as! NSDictionary)["url"]
                            
                            var dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "dd/MM/yyyy"
                            user["birthday"] = dateFormatter.dateFromString(r["birthday"] as! String)
                            user.saveInBackgroundWithBlock({
                                success, error in
                                println(success)
                                println(error)
                            })
                        }
                        
                    })
                }

                
            }else{
                println("user logged in through facebook")
                
            }
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CardsNavController") as! UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
            
        })
        
    }


}
