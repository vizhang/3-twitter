//
//  TwitterClient.swift
//  3-twitter
//
//  Created by Victor Zhang on 9/11/15.
//  Copyright (c) 2015 Victor Zhang. All rights reserved.
//

import UIKit


let twitterConsumerKey = "FFeox6xZq9MBozsLu0Y8LY1ka"
let twitterConsumerSecret = "ma6oLEK8MoRy1U2j7SjW0fqZ1yAMx4O9jMayRirZvWp9F9oQX3"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")


class TwitterClient: BDBOAuth1RequestOperationManager {
   
    //Holds closure until I'm ready to use it?
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    //Ask Tim about what computed properties vs stored properties are
    class var sharedInstance:TwitterClient {
        //Nested struct hack? What?
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
            
        }
        
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        
        //GET to Homepages
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation:AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("GET 200 from /home_timelines.json")
            println("@@@@@")
            println("\(response)")
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            
            completion(tweets: tweets, error: nil)
            
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("Error from GET /home_timelines.json")
            completion(tweets: nil, error: error)

        })
    }
    
    func tweetWithParams(params: NSDictionary?, completion: (error: NSError?) -> ()) {
        
        //POST to status/update
        POST("1.1/statuses/update.json", parameters: params, success: { (operation:AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("GET 200 from /statuses/update")
            println("\(response)")
            //var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            
            completion(error: nil)
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error from POST /update/status")
                completion(error: error)
                
        })
    }
    
    func retweetWithParams(params: NSDictionary?, completion: (error: NSError?) -> ()) {
        
        let id_str = params!["id"] as! String
        println("\(id_str)")
        
        //POST to status/update
        let post_url = "1.1/statuses/retweet/" + "\(id_str)" + ".json"
        println(post_url)
        POST(post_url, parameters: params, success: { (operation:AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("GET 200 from /statuses/retweet")
            println("\(response)")

            completion(error: nil)
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error from POST /status/retweet")
                completion(error: error)
                
        })
    }
    
    func starWithParams(params: NSDictionary?, completion: (error: NSError?) -> ()) {
        
            POST("1.1/favorites/create.json", parameters: params, success: { (operation:AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("GET 200 from /favorites/create")
            println("\(response)")
            
            completion(error: nil)
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error from POST /status/retweet")
                completion(error: error)
                
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        //Clean things up before we get going
        //Fetch request token and redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            // User is now allowed to go to mobile safari page
            // You have to have the token first
            println("Got the request token")
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            
            UIApplication.sharedApplication().openURL(authURL!)
            
            }) { (error: NSError!) -> Void in
                println("failed to get request token")
                self.loginCompletion?(user: nil, error: error)

        }
    }
    
    func openURL (url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            println("got access token")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            
            //Gives us everything the user has access to
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                println("GET 200")
                //println("user: \(response)")
                
                var user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                
                println("user name is: \(user.name)")
                self.loginCompletion?(user: user, error: nil)

                
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("GET /verify_credentials ERROR")
                    self.loginCompletion?(user: nil, error: error)

            })
            
            
            }) { (error: NSError!) -> Void in
                println("did not get access token")
                self.loginCompletion?(user: nil, error: error)

        }
    }
}
