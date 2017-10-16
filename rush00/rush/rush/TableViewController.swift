  //
//  TableViewController.swift
//  rush
//
//  Created by Jordan BOYER on 10/7/17.
//  Copyright © 2017 msireau/joboyer. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, API42Delegate {

    var API42 : API42Controller?
    var userId : Int?
    var topicID: String?
    var token : String?
    var Topics : [Topic] = []
    
    
    func treatTopics(arr: [Topic]){
        self.Topics = arr
        DispatchQueue.main.async {
            self.topicTableView.reloadData()
        }
    }
    
    func treatMessages(arr: [Message]) {
    }
    
    func treatDelete(arr: [Message]) {}
    
    func treatReplies(arr: [Replies]) {}
    
    override func viewDidAppear(_ animated: Bool) {
        API42 = API42Controller(token: self.token!, del: self)
        API42?.queryTopics()
    }
    
    @IBOutlet weak var topicTableView: UITableView! {
        didSet{
            topicTableView.delegate = self
            topicTableView.dataSource = self
        }
    }
    
    func getUserID() {
        print("get user id")
        print("userToken = \(self.token!)")
        let url = NSURL(string: "https://api.intra.42.fr/v2/me")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(self.token!)", forHTTPHeaderField: "Authorization")
        //        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        //        request.httpBody = "grant_type=authorization_code&client_id=\(UID)&client_secret=\(secret)&code=\(code)&redirect_uri=https://www.42.fr&state=abcdefghijklmnopqrstuvwxyz".data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if let err = error {
                print (err)
            } else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        //                        print(dic)
                        if let t = dic["id"] as? NSNumber {
                            self.userId = Int( t)
                            self.API42?.userId = String(describing: t)
                            print("userId \(t)")
                        }
                    }
                } catch (let err) {
                    print (err)
                }
            }
        }
        task.resume()
    }

    @IBAction func logoutButton(_ sender: Any) {
        print ("LOGOUT")
        //TODO -> ERASE USER INFO
        exit(0)
//        navigationController?.popToRootViewController(animated: true)
//        performSegue(withIdentifier: "logout", sender: Any?.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Topics"
        
        self.getUserID()
        
        API42 = API42Controller(token: self.token!, del: self)
        API42?.queryTopics()
        
        Singleton.shared.API42 = self.API42
        Singleton.shared.token = self.token
        Singleton.shared.topicId = self.topicID
        Singleton.shared.userId = self.userId
        
        topicTableView.estimatedRowHeight = 85
        topicTableView.rowHeight  = UITableViewAutomaticDimension
    }


    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.Topics.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = topicTableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)  as! TopicCell
        
        cell.topic = self.Topics[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        print(self.Topics[indexPath.row].id)
        print(String(describing: Singleton.shared.userId))
        if (self.Topics[indexPath.row].id == String(describing: Singleton.shared.userId)){
            return true
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // action one
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            print("Edit tapped")
        })
        editAction.backgroundColor = UIColor.blue
        
        // action two
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            self.API42?.deleteTopic(topicId: self.Topics[indexPath.row].id)
            self.API42 = API42Controller(token: self.token!, del: self)
            self.API42?.userId = String(describing: self.userId)
            self.API42?.queryTopics()
            print("Delete tapped")
        })
        deleteAction.backgroundColor = UIColor.red
        
        return [editAction, deleteAction]
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMessage" {
            if let vc = segue.destination as? MessageController {
                //                print("topicID : \(self.topicID)")
                vc.id = self.topicID
                //                vc.API42 = self.API42
                vc.token = self.token
                vc.userId = self.userId
            }
        } else if segue.identifier == "addtopic" {
            if let vc = segue.destination as? AddTopicViewController {
                vc.userId = self.userId
                vc.token = self.token
            }
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.topicID = self.Topics[indexPath.row].id
        if self.topicID != nil {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toMessage", sender: self)
            }
        }
        //        print(self.Topics[indexPath.row].id)
    }

}
