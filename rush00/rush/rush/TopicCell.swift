//
//  TopicCell.swift
//  rush
//
//  Created by Martin SIREAU on 10/7/17.
//  Copyright © 2017 msireau/joboyer. All rights reserved.
//

import UIKit

class TopicCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var topic : Topic? {
        didSet {
            if let t = topic {
                print(t)
                nameLabel.text = t.name
                bodyLabel.text = t.user
                dateLabel.text = t.date
            }
        }
    }
}
