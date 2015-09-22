//
//  TweetCell.swift
//  3-twitter
//
//  Created by Victor Zhang on 9/14/15.
//  Copyright (c) 2015 Victor Zhang. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var tweet: Tweet! {
        didSet {
            nameLabel?.text = tweet.user?.name
            if let s = tweet.user?.screenname {
                handleLabel?.text = "@\(s)"
            }
            dateLabel.text = tweet.createdAtString
            tweetLabel.text = tweet.text
            if let pp = tweet.user?.profileImageUrl {
                let url = NSURL(string: pp)
                profileImageView.setImageWithURL(url)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        //tweetLabel.preferredMaxLayoutWidth = tweetLabel.frame.size.width
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
