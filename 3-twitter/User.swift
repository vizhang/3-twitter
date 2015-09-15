//
//  User.swift
//  3-twitter
//
//  Created by Victor Zhang on 9/13/15.
//  Copyright (c) 2015 Victor Zhang. All rights reserved.
//

import UIKit

//Global object
var _currentUser: User? //hack because we dont have class or type variables
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var tagline: String?
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
    }
    
    //Objects in core data, user in nsuserdefaults which can restore from core-data
    class var currentUser : User? {
        get {
        if _currentUser == nil {
            var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
            if data != nil {
                var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! NSDictionary
                _currentUser = User(dictionary: dictionary)
        
            }
            else {
        
            }
        }
            else {
        
        }
        
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            if _currentUser != nil {
                //changes to serialized json string
                var data = NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            }
            else {
                //still write to it but nil (potentially clear it out)
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            //synchronized flush
            NSUserDefaults.standardUserDefaults().synchronize()

            
        }
    }
    
    func logout() {
        //Clear current user
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken() //removes permissions
        
        //NSUserNotification Center is like post office
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil) //tells anyone who is interested this happened
        
    }
}
