//
//  AuthService.swift
//  PurdueShare
//
//  Created by Shivan Desai on 3/12/18.
//  Copyright © 2018 Shiva Productions. All rights reserved.
//

import UIKit
import Foundation
import FacebookCore
import FacebookLogin
import FirebaseCore
import FirebaseAuth
import SwiftKeychainWrapper




class AuthService: NSObject {
    // Static variable used to call AuthService functions
    static let instance = AuthService()
    //var vc: UIViewController?
    let loginManager = LoginManager()
    let defaults = UserDefaults.standard
    
    
    func completeSignIn(_ uid: String, userData: [String:Any]) {
        
        DataService.instance.createOrUpdateUser(uid: uid, userData: userData)
        
        // Save uid to keychain
        let keyChainResult = KeychainWrapper.standard.set(uid, forKey: KEY_UID)
        print("Data saved to keychain: \(keyChainResult). KEY UID:\(String(describing: KeychainWrapper.standard.string(forKey: KEY_UID)))")
    }
    
    func firebaseAuth(userDict userData: [String:Any], credential: AuthCredential, completion: @escaping (Bool) -> ()) {
        //self.isAnon = false
        
        // Sign in user to application
        Auth.auth().signIn(with: credential) { (firebaseUser, error) in
            if error != nil {
                print("Firebase Auth Error. Unable to authenticate with Firebase: \(String(describing: error))")
                completion(false)
                return
            } else {
                guard let firebaseUser = firebaseUser else {
                    completion(false)
                    return
                }
                
                DataService.instance.REF_USERS.child(firebaseUser.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.exists() {
                        let userData:[String:Any] = ["firstName": userData["firstName"] as Any, "lastName": userData["lastName"] as Any, "fullName": userData["fullName"] as Any, "email": userData["email"] as Any, "provider": credential.provider as Any]
                        self.completeSignIn(firebaseUser.uid, userData: userData)
                    } else {
                        self.completeSignIn(firebaseUser.uid, userData: userData)
                    }
                    
                    completion(true)
                    return
                })
            }
        }
    }
    
    
    func facebookAuth(forVC vc: UIViewController) {
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: vc) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Permissions Granted: \(grantedPermissions). Permissions Declined: \(declinedPermissions). Access Token: \(accessToken)")
                let connection = GraphRequestConnection()
                connection.add(GraphRequest(graphPath: "/me", parameters:["fields": "first_name, last_name, name, email, picture.type(large)"])) { httpResponse, result in
                    switch result {
                    case .success(let response):
                        guard let userInfo = response.dictionaryValue else {
                            return
                        }
                        
                        print("Graph Request Succeeded: \(userInfo)")
                        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                        let profilePictureURL = ((userInfo["picture"] as? [String:Any])?["data"] as? [String:Any])?["url"] as? String
                        let userDict:[String:Any] = ["firstName": userInfo["first_name"] as Any, "lastName": userInfo["last_name"] as Any, "fullName": userInfo["name"] as Any, "email": userInfo["email"] as Any, "profilePictureURL": profilePictureURL as Any, "provider": credential.provider as Any]
                        self.firebaseAuth(userDict: userDict, credential: credential, completion: { (success) in
                            if success {
                                DispatchQueue.main.async() {
                                    vc.performSegue(withIdentifier: "afterLogin", sender: vc)
                                }
                            }
                        })
                    case .failed(let error):
                        print("Graph Request Failed: \(error)")
                    }
                }
                connection.start()
                print("Logged in!")
            }
        }
    }
    
}
