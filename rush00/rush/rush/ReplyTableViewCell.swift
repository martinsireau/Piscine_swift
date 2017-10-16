//
//  ReplyTableViewCell.swift
//  rush
//
//  Created by Martin SIREAU on 10/8/17.
//  Copyright © 2017 msireau/joboyer. All rights reserved.
//

import UIKit

class ReplyTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var bodyLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var reply : Replies? {
        didSet {
            if let t = reply {
                print(t)
                nameLabel.text = t.user
                bodyLabel.text = t.text
                dateLabel.text = t.date
            }
        }
    }
}
