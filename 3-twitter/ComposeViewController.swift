//
//  ComposeViewController.swift
//  3-twitter
//
//  Created by Victor Zhang on 9/15/15.
//  Copyright (c) 2015 Victor Zhang. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var handleLabel: UILabel!

    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tweetTextView.delegate = self
        // Do any additional setup after loading the view.
        
        var user: User?
        //REGULAR COMPOSE
        if tweet == nil {
            user = User.currentUser
        }
        else {
            //HANDLE REPLY CASE
            self.title = "Reply"
            user = tweet?.user
        }
        
        if let pp = user?.profileImageUrl {
            let url = NSURL(string: pp)
            profileImageView.setImageWithURL(url)
        }
        
        nameLabel.text = user?.name
        if let screenname = user?.screenname {
            handleLabel.text = "@\(screenname)"
            if tweet != nil {
                tweetTextView.text = "@\(screenname) "
            }
        }
    }

    @IBAction func cancelPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)

    }
    
    @IBAction func tweetPressed(sender: AnyObject) {
        let tweet_text = self.tweetTextView.text
        let dict: [String:AnyObject]?
        if self.tweet == nil {
            dict = ["status": tweet_text]
            TwitterClient.sharedInstance.tweetWithParams(dict, completion: { (error) -> () in
                if error == nil {
                    println("compose success!")
                    
                }
                else {
                    
                }
            })
        }
        else {
            if let tweet = self.tweet {
                if let id_str = tweet.id_str {
                    dict = ["status": tweet_text, "in_reply_to_status_id": id_str]
                    TwitterClient.sharedInstance.tweetWithParams(dict, completion: { (error) -> () in
                        if error == nil {
                            println("reply success!")
                            
                        }
                        else {
                            
                        }
                    })
                }
            }
        }
        

        dismissViewControllerAnimated(true, completion: nil)

    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        if self.tweetTextView.text == "Write your tweet!" {
            self.tweetTextView.text = ""
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
