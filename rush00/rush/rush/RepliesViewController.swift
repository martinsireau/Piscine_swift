//
//  RepliesViewController.swift
//  rush
//
//  Created by Martin SIREAU on 10/8/17.
//  Copyright © 2017 msireau/joboyer. All rights reserved.
//

import UIKit

class RepliesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, API42Delegate {

    var id : String?
    var API42 : API42Controller?
    var replies : [Replies] = []
    var token : String?
    var userId : Int?
    var repliesId : String?
    var messageUserId : Int?
    
    @IBOutlet weak var tableView: UITableView!
    
    func treatDelete(arr: [Message]) {}
    
    func treatTopics(arr: [Topic]) {}
    
    func treatMessages(arr: [Message]) {}
    
    func treatReplies(arr: [Replies]) {
        self.replies.removeAll()
        print(arr)
        
        if (arr.isEmpty){
            let alert = UIAlertController(title: "Info", message: "No Replies For this message", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            navigationController?.popViewController(animated: true)
        }
        self.replies = arr
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        API42 = API42Controller(token: Singleton.shared.token!, del: self)
        API42?.userId = String(describing: Singleton.shared.userId)
        API42?.queryReplies(topicId: Singleton.shared.topicId!, messageId: Singleton.shared.repliesId!)
        
        tableView.estimatedRowHeight = 85
        tableView.rowHeight  = UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.replies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "replyCell", for: indexPath) as! ReplyTableViewCell
        
        cell.nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        cell.reply = self.replies[indexPath.row]
        cell.isUserInteractionEnabled = true
        
        return cell
    }

}
