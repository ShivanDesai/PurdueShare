//
//  LoginViewController.swift
//  PurdueShare
//
//  Created by Shivan Desai on 3/9/18.
//  Copyright © 2018 Shiva Productions. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Foundation
import FacebookCore
import FacebookLogin
import FirebaseCore
import FirebaseAuth

class LoginViewController: UIViewController {

    let loginManager = LoginManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   //     let loginButton = FBSDKLoginButton()
   //     loginButton.center = view.center
   //     view.addSubview(loginButton)
   //     loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
   //     loginButton.delegate = self
   // }
    
    
    @IBAction func fbLoginClicked(_ sender: Any) {
        AuthService.instance.facebookAuth(forVC: self)
    }
    
 /*   func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of Facebook.")
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print(error)
            return
        }
        print("Successfully logged in using Facebook")
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                return
            }
            // User is signed in
            // ...
            let userInfo = Auth.auth().currentUser?.providerData[0]
            print("Email: \(String(describing: userInfo?.displayName))")
        }
        performSegue(withIdentifier: "afterLogin", sender: self)
    }
   */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
