//
//  DataService.swift
//  PurdueShare
//
//  Created by Shivan Desai on 3/12/18.
//  Copyright © 2018 Shiva Productions. All rights reserved.
//


import Foundation
import FirebaseDatabase
import SwiftKeychainWrapper

let KEY_UID = "uid"

class DataService {
    static let instance = DataService()
    private var _REF_USERS = Database.database().reference().child("Users")
    private var _REF_POSTS = Database.database().reference().child("posts")
    
    private init(){}
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_CURRENT_USER: DatabaseReference? {
        guard let uid = KeychainWrapper.standard.string(forKey: KEY_UID) else { return nil }
        let user = Database.database().reference().child("Users").child(uid)
        return user
    }
    
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    
    
    // Adds/updates user's entry in the Firebase database
    func createOrUpdateUser(uid: String, userData: [String:Any]) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func deleteUser(uid: String) {
        REF_USERS.child(uid).removeValue()
    }
    
    func createPost(forKey postKey: String, postData: [String:Any]) {
        REF_POSTS.updateChildValues([postKey: postData])
    }
    
    func createOffer(offerData: [String:Any], postKey: String) {
        REF_POSTS.child(postKey).child("Offers").childByAutoId().updateChildValues(offerData)
    }
    
    func createComment(commentData: [String:Any], postKey: String, offerKey: String) {
        REF_POSTS.child(postKey).child("Offer").child(offerKey).child("Comments").childByAutoId().updateChildValues(commentData)
    }
    
    func getUser(userID: String,  handler: @escaping (_ user: User) -> ()) {
        DataService.instance.REF_USERS.child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let userDict = snapshot.value as? [String:Any] else {
                print("ERROR GETTING USER DICT")
                return
            }
            
            let user = User(userDict: userDict, userID: snapshot.key)
            handler(user)
            return
        }) { (error) in
            print("ERROR \(error.localizedDescription)")
            return
        }
    }
    
 /*   func updateDebate(debateData: [String:Any], debateKey: String) {
        REF_DEBATES.child(debateKey).updateChildValues(debateData)
    }
    
    func updateArgument(argumentData: [String:Any], debateKey: String, argumentKey: String) {
        REF_DEBATES.child(debateKey).child("Arguments").child(argumentKey).updateChildValues(argumentData)
    }
    
    func updateComment(commentData: [String:Any], debateKey:String, argumentKey: String, commentKey: String) {
        REF_DEBATES.child(debateKey).child("Arguments").child(argumentKey).child("Comments").child(commentKey).updateChildValues(commentData)
    }
 */
    
    func deletePost(postKey: String) {
        REF_POSTS.child(postKey).removeValue()
    }
    
    func deleteOffer(postKey: String, offerKey: String) {
        REF_POSTS.child(postKey).child("Offers").child(offerKey).removeValue()
    }
    
    func deleteComment(postKey:String, offerKey: String, commentKey: String) {
        REF_POSTS.child(postKey).child("Offers").child(offerKey).child("Comments").child(commentKey).removeValue()
    }
    
    
}
