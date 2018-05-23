//
//  User.swift
//  PurdueShare
//
//  Created by Shivan Desai on 3/12/18.
//  Copyright © 2018 Shiva Productions. All rights reserved.
//

import Foundation
import Firebase

class User {
    private var _firstName: String!
    private var _lastName: String!
    private var _fullName: String!
    private var _email: String!
    private var _userID: String!
    private var _userDict: [String:Any]!
    private var _xCoordinate: String!
    private var _yCoordinate: String!
    
    var firstName: String {
        return _firstName
    }
    
    var lastName: String {
        return _lastName
    }
    
    var fullName: String {
        return _fullName
    }
    
    var email: String {
        return _email
    }
    
    var userID: String {
        return _userID
    }
    
    var userDict: [String:Any] {
        return _userDict
    }
    
    var xCoordinate: String {
        return _xCoordinate
    }
    
    var yCoordinate: String {
        return _yCoordinate
    }
    
    init(userDict: [String:Any], userID: String) {
        self._userDict = userDict
        self._userID = userID
        
        if let firstName = userDict["firstName"] as? String {
            self._firstName = firstName
        }
        
        if let lastName = userDict["lastName"] as? String {
            self._lastName = lastName
        }
        
        if let fullName = userDict["fullName"] as? String {
            self._fullName = fullName
        }
        
        if let email = userDict["email"] as? String {
            self._email = email
        }
        
        if let xCoordinate = userDict["xCoord"] as? String {
            self._xCoordinate = xCoordinate
        }
        
        if let yCoordinate = userDict["yCoord"] as? String {
            self._yCoordinate = yCoordinate
        }
    }
}
