//
//  MessageController.swift
//  rush
//
//  Created by Jordan BOYER on 10/7/17.
//  Copyright © 2017 msireau/joboyer. All rights reserved.
//

import UIKit

class MessageController: UIViewController, UITableViewDataSource, UITableViewDelegate, API42Delegate {

    var id : String?
    var API42 : API42Controller?
    var messages : [Message] = []
    var token : String?
    var userId : Int?
    var messageId : String?
    var messageUserId : Int?
    @IBOutlet weak var tableView: UITableView!
    
    func treatDelete(arr: [Message]) {
        self.messages.removeAll()
//        print(arr)
        self.messages = arr
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
//        API42 = API42Controller(token: self.token!, del: self)
//        API42?.userId = String(describing: self.userId)
//        API42?.queryMessages(id: self.id!)
    }
    
    func treatTopics(arr: [Topic]) {}
    
    func treatMessages(arr: [Message]) {
        if arr.isEmpty{
            print("EMPTY")
            return
        }
        self.messages.removeAll()
//        print(arr)
        self.messages = arr
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func treatReplies(arr: [Replies]) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Singleton.shared.userId)
        
        API42 = API42Controller(token: self.token!, del: self)
        API42?.userId = String(describing: self.userId ?? 0)
        API42?.queryMessages(id: self.id!)
        
        Singleton.shared.API42 = self.API42
        Singleton.shared.token = self.token
        Singleton.shared.topicId = self.id
//        Singleton.shared.userId = self.userId
        
        tableView.estimatedRowHeight = 85
        tableView.rowHeight  = UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! messageTableViewCell
        
        cell.nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        cell.message = self.messages[indexPath.row]
        cell.isUserInteractionEnabled = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Singleton.shared.repliesId = self.messages[indexPath.row].id
        if self.messageId != nil {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toReplies", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReplies" {
            if let vc = segue.destination as? RepliesViewController {
                
                vc.id = self.messageId
                vc.token = self.token
                vc.userId = self.userId
            }
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        print(Singleton.shared.userId)
        if (self.messages[indexPath.row].userId == String(describing: Singleton.shared.userId)){
            return true
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // action one
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
//            self.API42?.updateMessage(messageID: self.messageId!, content: self.messages[indexPath.row].text)
//            self.API42 = API42Controller(token: self.token!, del: self)
//            self.API42?.userId = String(describing: self.userId)
//            self.API42?.queryMessages(id: self.id!)
            print("Edit tapped")
        })
        editAction.backgroundColor = UIColor.blue
        
        // action two
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            self.API42?.deleteMessage(messageId: self.messages[indexPath.row].id)
            self.API42 = API42Controller(token: self.token!, del: self)
            self.API42?.userId = String(describing: self.userId)
            self.API42?.queryMessages(id: self.id!)
            print("Delete tapped")
        })
        deleteAction.backgroundColor = UIColor.red
        
        return [editAction, deleteAction]
    }
    
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }

}
