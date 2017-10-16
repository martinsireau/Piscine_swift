//
//  ViewController.swift
//  rush00
//
//  Created by Jordan BOYER on 10/7/17.
//  Copyright © 2017 msireau/joboyer. All rights reserved.
//

import Foundation
import UIKit

class API42Controller {
    
    var token : String?
    var Topics : [Topic] = []
    var Messages : [Message] = []
    var Reply : [Replies] = []
    var delegate : API42Delegate?
    var userId : String?
    
    init(token: String,del: API42Delegate) {
        self.token = token
        self.delegate = del
    }
    
    func queryTopics(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let url = NSURL(string: "https://api.intra.42.fr/v2/topics?per_page=100")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(self.token!)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if let err = error {
                print (err)
            } else if let d = data {
                do {
                    if let jsonData = try JSONSerialization.jsonObject(with: d, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                        //                        print(jsonData)
                        for Item in jsonData as! [Dictionary<String, Any>] {
                            if let aut = Item["author"] as? [String: AnyObject] {
                                let date = (Item["updated_at"] as! String).components(separatedBy: "T")[0]
                                let time = (Item["updated_at"] as! String).components(separatedBy: "T")[1].components(separatedBy: ".")[0]
                                self.Topics.append(Topic(n: Item["name"] as! String, u: aut["login"] as! String, d: date + " " + time, id: String(describing: Item["id"]!)))
                            }
                        }
                        self.delegate?.treatTopics(arr: self.Topics)
                    }
                } catch (let err) {
                    print (err)
                }
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        task.resume()
    }

    func queryMessages(id:String){
        self.Messages.removeAll()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let url = NSURL(string: "https://api.intra.42.fr/v2/topics/\(id)/messages")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(self.token!)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if let err = error {
                print (err)
            } else if let d = data {
                do {
                    if let jsonData = try JSONSerialization.jsonObject(with: d, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                        for Item in jsonData as! [Dictionary<String, Any>] {
                            if let aut = Item["author"] as? [String: AnyObject] {
                                let date = (Item["created_at"] as! String).components(separatedBy: "T")[0]
                                let time = (Item["created_at"] as! String).components(separatedBy: "T")[1].components(separatedBy: ".")[0]
                                self.Messages.append(Message(u: aut["login"] as! String, d: date + " " + time, t: Item["content"] as! String, id: String(describing: Item["id"]!), uid: String(describing: aut["id"])))
                            }
                        }
                        self.delegate?.treatMessages(arr: self.Messages)
                    }
                } catch (let err) {
                    print (err)
                }
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        task.resume()
    }
    
    func queryReplies(topicId:String, messageId:String){
        self.Messages.removeAll()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let url = NSURL(string: "https://api.intra.42.fr/v2/topics/\(topicId)/messages/\(messageId)/messages")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(self.token!)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if let err = error {
                print (err)
            } else if let d = data {
                do {
                    if let jsonData = try JSONSerialization.jsonObject(with: d, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                        for Item in jsonData as! [Dictionary<String, Any>] {
                            if let aut = Item["author"] as? [String: AnyObject] {
                                let date = (Item["created_at"] as! String).components(separatedBy: "T")[0]
                                let time = (Item["created_at"] as! String).components(separatedBy: "T")[1].components(separatedBy: ".")[0]
                                self.Reply.append(Replies(u: aut["login"] as! String, d: date + " " + time, t: Item["content"] as! String, id: String(describing: Item["id"]!), uid: String(describing: aut["id"])))
                            }
                        }
                        self.delegate?.treatReplies(arr: self.Reply)
                    }
                } catch (let err) {
                    print (err)
                }
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        task.resume()
    }

    func addMessage(topicId: String, message: String){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        print(self.token!)
        let url = NSURL(string: "https://api.intra.42.fr/v2/topics/\(topicId)/messages")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("Bearer \(self.token!)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json :[String:Any] = ["message":["author_id":self.userId, "content":message]]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        //        request.httpBody = "{'message':{'author_id':\(self.userId!),'content':\(message),'messageable_id':'0','messageable_type':'Topic'}}".data(using: String.Encoding.utf8)
        
        print("AddMessage args")
        print("topidId \(topicId)")
        print("message \(message)")
        print ("uiserUd \(self.userId!)")
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if let err = error {
                print (err)
            } else if let d = data {
                do {
                    if let jsonData = try JSONSerialization.jsonObject(with: d, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        print(jsonData)
                        if let c = jsonData["id"]{
                            print("message submitted!")
                            print(c)
                        }
                        self.delegate?.treatMessages(arr: self.Messages)
                        self.queryMessages(id: topicId)
                    }
                } catch (let err) {
                    print (err)
                }
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        task.resume()
    }

    func deleteMessage(messageId: String){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let url = NSURL(string: "https://api.intra.42.fr/v2/messages/\(messageId)")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(self.token!)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print("messageId \(messageId)")
        print ("uiserUd \(self.userId!)")
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if let err = error {
                print (err)
            } else {
                print("message deleted")
            }
            self.delegate?.treatDelete(arr: self.Messages)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        task.resume()
    }
    
    func addTopic(name: String){
        print("addToping")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let url = NSURL(string: "https://api.intra.42.fr/v2/topics")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("Bearer \(self.token!)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json :[String:Any] = ["topic":[
            "kind": "normal",
            "cursus_ids": ["1"],
            "language_id": "1",
            "messages_attributes":[[
                "author_id": self.userId,
                "content": "jojo"
                ]],
            //            "survey_attributes":[[
            //                "name":name,
            //                "survey_answers_attributes":[
            //                    "name": name
            //                ]
            //            ]],
            "name": name,
            "tag_ids": ["8"]
            ]]
//        print(json)
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
//        print(jsonData)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if let err = error {
                print (err)
            } else if let d = data {
                do {
                    if let jsonData = try JSONSerialization.jsonObject(with: d, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        print("jojo")
                        print(jsonData)
                    }
                } catch (let err) {
                    print (err)
                }
            }
            self.delegate?.treatTopics(arr: self.Topics)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        task.resume()
    }
    
    func deleteTopic(topicId: String){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let url = NSURL(string: "https://api.intra.42.fr/v2/topics/\(topicId)")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(self.token!)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
//        print("messageId \(topicId)")
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if let err = error {
                print (err)
            } else {
                print("topic deleted")
            }
            self.delegate?.treatDelete(arr: self.Messages)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        task.resume()

    }
    
    func updateMessage(messageID: String, content: String){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let url = NSURL(string: "https://api.intra.42.fr/v2/messages/\(messageID)")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(self.token!)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json :[String:Any] = ["message":["message_id": messageID, "content":content]]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if let err = error {
                print (err)
            } else if let d = data {
                do {
                    if let jsonData = try JSONSerialization.jsonObject(with: d, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        print(jsonData)
                        if let c = jsonData["id"]{
                            print("message submitted!")
                            print(c)
                        }
//                        self.delegate?.treatMessages(arr: self.Messages)
                    }
                } catch (let err) {
                    print (err)
                }
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        task.resume()
    }
 
}
