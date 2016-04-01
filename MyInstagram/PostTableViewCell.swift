//
//  PostTableViewCell.swift
//  MyInstagram
//
//  Created by Weifan Lin on 4/1/16.
//  Copyright © 2016 Weifan Lin. All rights reserved.
//

import UIKit
import ParseUI

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!


    @IBOutlet weak var photoView: PFImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    var post: PFObject! {
        didSet {
            let user = post["author"] as? PFUser
            self.usernameLabel.text = user?.username
            usernameLabel.sizeToFit()
            
            self.photoView.file = post["media"] as? PFFile
            self.photoView.loadInBackground()
            
            self.captionLabel.text = post["caption"] as? String
            captionLabel.sizeToFit()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }

}
