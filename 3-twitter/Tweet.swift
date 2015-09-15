//
//  Tweet.swift
//  3-twitter
//
//  Created by Victor Zhang on 9/13/15.
//  Copyright (c) 2015 Victor Zhang. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var id_str: String?
    
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        id_str = dictionary["id_str"] as? String
        
        //Formatters are really expensive... can make a lazy property. Only gets triggered when you really need it.
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        //formatter.dateStyle = .MediumStyle

        createdAt = formatter.dateFromString(createdAtString!)

        
    }
    
    class func tweetsWithArray (array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
