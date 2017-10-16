//
//  MessengerVC.swift
//  d07
//
//  Created by Martin SIREAU on 10/12/17.
//  Copyright © 2017 Martin SIREAU. All rights reserved.
//

import UIKit

import JSQMessagesViewController
import RecastAI
import ForecastIO

struct User {
    let id: String
    let name: String
}

class ViewControllerScnd: JSQMessagesViewController {
    let user1 = User(id: "1", name: "Me")
    let user2 = User(id: "2", name: "Bot")
    let bot = RecastAIClient(token : "86e58d61cf0d5e00923fc2dfd506d48b", language: "fr")
    let darkSkyClient = DarkSkyClient(apiKey: "a265eff50f4af5817a0cac58a3afa3a7")
    
    var currentUser: User {
        return user1
    }
    
    // all messages of users1, users2
    var messages = [JSQMessage]()
    
    func recastResponse(response: ConverseResponse){
        print("REPONSE = \(response)")
        if let myRes = response.entities?["location"] as? [[String : Any]]{
            let lat = myRes[0]["lat"] as! Double!
            let lng = myRes[0]["lng"] as! Double!
            
            self.darkSkyClient.getForecast(latitude: lat!, longitude: lng!, completion: { result in
                switch result {
                case .success(let value, _):
                    let formatted = myRes[0]["formatted"] as! String!
                    DispatchQueue.main.async {
                        let mess = JSQMessage(senderId: "2", displayName: "Bot", text: "\(formatted!) is \((value.hourly!.summary)!)")
                        self.messages.append(mess!)
                        self.finishSendingMessage()
                        //                        self.myLabel.text = "\(formatted!) is \((value.hourly!.summary)!)"
                    }
                case .failure(let error):
                    print(error)
                }
            })
        } else {
            if (response.intents?.count != 0) {
                if let myRes = response.intents as? [[String : Any]] {
                    if let mySlug = myRes[0]["slug"] as? String{
                        print(mySlug)
                        DispatchQueue.main.async {
                            let mess = JSQMessage(senderId: "2", displayName: "Bot", text: mySlug)
                            self.messages.append(mess!)
                            self.finishSendingMessage()
//                            self.myLabel.text = mySlug
                        }
                    }
                    
                }
            } else {
                DispatchQueue.main.async {
                let mess = JSQMessage(senderId: "2", displayName: "Bot", text: "sorry, an error occured.")
                    self.messages.append(mess!)
                    self.finishSendingMessage()
//                self.myLabel.text = "Error"
                }
                print("Error")
            }
        }
    }
    
    func recastError(error: Error) {
        let mess = JSQMessage(senderId: "2", displayName: "Bot", text: "sorry, an error occured.")
        self.messages.append(mess!)
        self.finishSendingMessage()
//        self.myLabel.text = "Error"
        print(error)
    }
}

extension ViewControllerScnd {
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)
        
        messages.append(message!)
        self.makeRecastRequest(request: text!)
        
        finishSendingMessage()
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.row]
        let messageUsername = message.senderDisplayName
        
        return NSAttributedString(string: messageUsername!)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 15
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        
        let message = messages[indexPath.row]
        
        if currentUser.id == message.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: .green)
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: .blue)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        print("LOL")
    }
}

extension ViewControllerScnd {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tell JSQMessagesViewController
        // who is the current user
        self.senderId = currentUser.id
        self.senderDisplayName = currentUser.name
        
        
        self.messages = getMessages()
    }
    
    func makeRecastRequest(request: String) {
        if request != ""{
            self.bot.textConverse(request, successHandler: recastResponse, failureHandle: recastError)
        } else {
            let mess = JSQMessage(senderId: "2", displayName: "Bot", text: "sorry, an error occured.")
            self.messages.append(mess!)
//            self.myLabel.text = "Request can't be empty"
        }
    }
}

extension ViewControllerScnd {
    func getMessages() -> [JSQMessage] {
        var messages = [JSQMessage]()
        
        let message1 = JSQMessage(senderId: "1", displayName: "Steve", text: "Hey Tim how are you?")
        let message2 = JSQMessage(senderId: "2", displayName: "Tim", text: "Fine thanks, and you?")
        
        messages.append(message1!)
        messages.append(message2!)
        
        return messages
    }
}
