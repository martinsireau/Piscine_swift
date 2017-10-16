//
//  AddTopicViewController.swift
//  rush
//
//  Created by Martin SIREAU on 10/8/17.
//  Copyright © 2017 msireau/joboyer. All rights reserved.
//

import UIKit

class AddTopicViewController: UIViewController, API42Delegate {
    
    var API42 : API42Controller?
    var userId: Int?
    var token: String?
    
    func treatReplies(arr: [Replies]) {}
    
    func treatTopics(arr: [Topic]) {
    
    }
    
    func treatMessages(arr: [Message]) {}
    
    func treatDelete(arr: [Message]) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        API42 = API42Controller(token: self.token!, del: self)
    }
    
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func AddTopic(_ sender: Any) {
        print(textView.text)
        if (textView.text != "") {
            API42?.addTopic(name : textView.text)
        }
        navigationController?.popViewController(animated: true)
    }
    
}
