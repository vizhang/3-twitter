//
//  MenuViewController.swift
//  3-twitter
//
//  Created by Victor Zhang on 9/20/15.
//  Copyright (c) 2015 Victor Zhang. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    private var profileViewController : UIViewController!
    private var mentionsViewController: UIViewController!
    private var tweetsViewController: UIViewController!

    var viewControllers: [UIViewController] = []
    var hamburgerViewController : HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        let sbd = UIStoryboard(name: "Main", bundle: nil)
        
        tweetsViewController = sbd.instantiateViewControllerWithIdentifier("TweetsNavController") as! UIViewController
        profileViewController = sbd.instantiateViewControllerWithIdentifier("ProfileViewController") as! UIViewController
        mentionsViewController = sbd.instantiateViewControllerWithIdentifier("MentionsViewController") as! UIViewController
     
        viewControllers.append(tweetsViewController)
        viewControllers.append(profileViewController)
        viewControllers.append(mentionsViewController)
        
        //BOOTUP SEQUENCE
        hamburgerViewController.contentViewController = tweetsViewController

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as!MenuCell
        if indexPath.row == 0 {
            cell.textLabel?.text = "Profile"
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "Timeline"
        } else {
            cell.textLabel?.text = "Mentions"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //set the content view of the hamburger content view controller.
        // somehow give access to hamburger
        print("viewControllers is this long: \(viewControllers.count)")
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]        
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
