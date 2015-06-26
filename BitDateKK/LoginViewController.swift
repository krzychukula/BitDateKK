//
//  LoginViewController.swift
//  BitDateKK
//
//  Created by Krzysztof Kula on 26/06/15.
//  Copyright (c) 2015 Krzysztof Kula. All rights reserved.
//

import UIKit

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
            }else if user!.isNew {
                println("user signed up and logged in through facebook")
            }else{
                println("user logged in through facebook")
            }
        })
        
    }


}
