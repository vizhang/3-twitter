//
//  HamburgerViewController.swift
//  3-twitter
//
//  Created by Victor Zhang on 9/21/15.
//  Copyright (c) 2015 Victor Zhang. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    
    var originalLeftMargin : CGFloat!
    var contentViewController: UIViewController! {
        didSet (oldContentViewController) {
            view.layoutIfNeeded() //when invoked this calls viewDidLoad before below line
            
            //handle killing old views
            if oldContentViewController != nil {
                oldContentViewController.willMoveToParentViewController(nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMoveToParentViewController(nil)
            }
            
            contentViewController.willMoveToParentViewController(self) //calls willappear
            contentView.addSubview(contentViewController.view)
            contentViewController.view.frame = contentView.bounds
            contentViewController.didMoveToParentViewController(self) //do this for content and menu
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.leftMarginConstraint.constant = 0
                self.view.layoutIfNeeded() //what happens when this isn't here...
            })
            
        }
    }
    
    
    var menuViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded() //when invoked this calls viewDidLoad before below line
            
            
            menuView.addSubview(menuViewController.view)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            originalLeftMargin = leftMarginConstraint.constant
        } else if sender.state == UIGestureRecognizerState.Changed {
            
                leftMarginConstraint.constant = originalLeftMargin + translation.x
            
        }
        else if sender.state == UIGestureRecognizerState.Ended {
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                if velocity.x > 0 {
                    self.leftMarginConstraint.constant = self.view.frame.width - 50
                } else {
                    self.leftMarginConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
  

            
        }
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
