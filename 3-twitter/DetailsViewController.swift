//
//  DetailsViewController.swift
//  3-twitter
//
//  Created by Victor Zhang on 9/15/15.
//  Copyright (c) 2015 Victor Zhang. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var tweet: Tweet?
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let tweet = tweet {
            dateLabel.text = tweet.createdAtString
            textLabel.text = tweet.text
            nameLabel.text = tweet.user?.name
            handleLabel.text = tweet.user?.screenname
            if let pp = tweet.user?.profileImageUrl {
                let url = NSURL(string: pp)
                profileImageView.setImageWithURL(url)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func replyPressed(sender: AnyObject) {
        println("replyPressed")
    }
    @IBAction func retweetPressed(sender: AnyObject) {
        println("retweetPressed")
        if let id_str = self.tweet?.id_str {
            let dict: [String: String] = ["id": id_str]

            TwitterClient.sharedInstance.retweetWithParams(dict , completion: { (error) -> () in
                if error == nil {
                    println("retweet OK!")
                }
                else {
                    println("\(error)")
                }
            })
        }


    }
    @IBAction func starPressed(sender: AnyObject) {
        println("starPressed")
        if let id_str = self.tweet?.id_str {
            let dict: [String: String] = ["id": id_str]
            
            TwitterClient.sharedInstance.starWithParams(dict , completion: { (error) -> () in
                if error == nil {
                    println("star OK!")
                }
                else {
                    println("\(error)")
                }
            })
        }

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "deetTOcompose"
        {
            println("seguing deetTOcompose")
            let navigationController = segue.destinationViewController as! UINavigationController
            let composeVC = navigationController.topViewController as! ComposeViewController
            composeVC.tweet = self.tweet
        }
    }
    

}
