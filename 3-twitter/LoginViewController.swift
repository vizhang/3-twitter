//
//  ViewController.swift
//  3-twitter
//
//  Created by Victor Zhang on 9/9/15.
//  Copyright (c) 2015 Victor Zhang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func loginPressed(sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if user != nil {
                //perform segue
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }
            else {
                //Handle error from authentication
                
            }
        }
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "loginSegue" {
            if let hamburgerViewController = segue.destinationViewController as? HamburgerViewController {
                
                //force it to go into hamburgers
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let menuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
                
                menuViewController.hamburgerViewController = hamburgerViewController
                hamburgerViewController.menuViewController = menuViewController
            }
        }
    }
    
    

}

