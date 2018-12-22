//
//  AuthService.swift
//  PurdueShare
//
//  Created by Shivan Desai on 3/12/18.
//  Copyright © 2018 Shiva Productions. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Foundation
import FacebookCore
import FacebookLogin
import FacebookShare
import FirebaseCore
import FirebaseAuth
import SwiftKeychainWrapper




class AuthService: NSObject {
    // Static variable used to call AuthService functions
    static let instance = AuthService()
    //var vc: UIViewController?
    let loginManager = LoginManager()
    let defaults = UserDefaults.standard
    
    var usDat = [String:Any]()
    
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
    
    
    
    
//    struct MyProfileRequest: GraphRequestProtocol {
////        var res = Response()
//        struct Response: GraphResponseProtocol {
//            init(rawResponse: Any?) {
//                guard let userName = rawResponse as? [String:Any] else {
//                    print("Counldn't get Name")
//                    return
//                }
//                print("rawrespons: \(userName["name"]!)")
//                fR = userName["name"]! as! String
//            }
//            var fR = ""
//        }
//
//        var graphPath = "/me"
//        //        var parameters: [String : Any]? = ["fields": "email"]
//        var parameters: [String : Any]? = ["fields": "name"]
//        var accessToken = AccessToken.current
//        var httpMethod: GraphRequestHTTPMethod = .GET
//        var apiVersion: GraphAPIVersion = .defaultVersion
//    }
//
//    struct MyProfileRequest1: GraphRequestProtocol {
//        struct Response: GraphResponseProtocol {
//            init(rawResponse: Any?) {
//                // Decode JSON from rawResponse into other properties here.
//                guard let userEmail = rawResponse as? [String:Any] else {
//                    print("Counldn't get Email")
//                    return
//                }
//                print("rawrespons: \(userEmail["email"]!)")
//                var finRes = userEmail["email"]!
////                usDat["email"] = finRes
//            }
//        }
//
////        var finRes:String = nil
//        var graphPath = "/me"
//        //        var parameters: [String : Any]? = ["fields": "email"]
//        var parameters: [String : Any]? = ["fields": "email"]
//        var accessToken = AccessToken.current
//        var httpMethod: GraphRequestHTTPMethod = .GET
//        var apiVersion: GraphAPIVersion = .defaultVersion
//    }
//
//    struct MyProfileRequest2: GraphRequestProtocol {
//        struct Response: GraphResponseProtocol {
//            init(rawResponse: Any?) {
//
//                // Decode JSON from rawResponse into other properties here.
//                guard let userPictureData = rawResponse as? [String:Any] else {
//                    print("Counldn't get Name")
//                    return
//                }
//                var pic = userPictureData["picture"] as? [String:Any]
//                var picData = pic?["data"] as? [String:Any]
//                print("rawrespons: \(String(describing: picData?["url"]))")
//                AuthService.instance.usDat["profilePic"] = picData?["url"]!
//            }
//        }
//
//        var graphPath = "/me"
//        //        var parameters: [String : Any]? = ["fields": "email"]
//        var parameters: [String : Any]? = ["fields": "picture"]
//        var accessToken = AccessToken.current
//        var httpMethod: GraphRequestHTTPMethod = .GET
//        var apiVersion: GraphAPIVersion = .defaultVersion
//    }
    
    func facebookAuth(forVC vc: UIViewController) {
        loginManager.logIn(readPermissions: [.publicProfile, .email, .userFriends], viewController: vc) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Permissions Granted: \(grantedPermissions). Permissions Declined: \(declinedPermissions). Access Token: \(accessToken)")
                var userDict = [String:Any]()
                let connection = GraphRequestConnection()
//                let x1 = MyProfileRequest()
                connection.add(GraphRequest(graphPath: "/me", parameters:["fields":"name"])) { httpResponse, result in
                    switch result {
                    case .success(let response):
                        //                            print(response)
                        guard let userInfo = response.dictionaryValue else {
                            return
                        }
                        
                        print("Graph Request Succeeded: \(response)")
                        userDict["fullName"] = userInfo["name"]! as Any
                        //                        let profilePictureURL = ((userInfo["picture"] as? [String:Any])?["data"] as? [String:Any])?["url"] as? String
                        //                        let userDict:[String:Any] = ["firstName": userInfo["first_name"] as Any, "lastName": userInfo["last_name"] as Any, "fullName": userInfo["name"] as Any, "email": userInfo["email"] as Any, "profilePictureURL": profilePictureURL as Any, "provider": credential.provider as Any]
//                                                self.firebaseAuth(userDict: userDict, credential: credential, completion: { (success) in
//                                                    if success {
//                                                        DispatchQueue.main.async() {
//                                                            vc.performSegue(withIdentifier: "afterLogin", sender: vc)
//                                                        }
//                                                    }
//                                                })
                        
                    case .failed(let error):
                        print("Graph Request Failed: \(error)")
                    }
                }
                connection.add(GraphRequest(graphPath: "/me", parameters:["fields":"email"])) { httpResponse, result in
                    switch result {
                    case .success(let response):
                        guard let userInfo = response.dictionaryValue else {
                            return
                        }
                        userDict["email"] = userInfo["email"]! as Any
                    case .failed(let error):
                        print("Graph Request Failed: \(error)")
                    }
                }
                connection.add(GraphRequest(graphPath: "/me", parameters:["fields":"picture"])) { httpResponse, result in
                    switch result {
                    case .success(let response):
                        guard let userInfo = response.dictionaryValue else {
                            return
                        }
                        let profilePictureURL = ((userInfo["picture"] as? [String:Any])?["data"] as? [String:Any])?["url"] as? String
                        userDict["profilePictureURL"] = profilePictureURL! as Any
                        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                        userDict["provider"] = credential.provider as Any
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
