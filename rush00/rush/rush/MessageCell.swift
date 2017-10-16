//
//  MessageCell.swift
//  rush
//
//  Created by Jordan BOYER on 10/7/17.
//  Copyright © 2017 msireau/joboyer. All rights reserved.
//

import Foundation
import UIKit

class messageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var bodyLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var message : Message? {
        didSet {
            if let t = message {
                print(t)
                nameLabel.text = t.user
                bodyLabel.text = t.text
                dateLabel.text = t.date
            }
        }
    }
}
