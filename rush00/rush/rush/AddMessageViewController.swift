//
//  AddMessageViewController.swift
//  rush
//
//  Created by Martin SIREAU on 10/8/17.
//  Copyright © 2017 msireau/joboyer. All rights reserved.
//

import UIKit

class AddMessageViewController: UIViewController, API42Delegate {

    var API42 : API42Controller?
    var topicId : String?
    var userId: Int?
    
    func treatReplies(arr: [Replies]) {}
    
    func treatTopics(arr: [Topic]) {}
    
    func treatMessages(arr: [Message]) {}
    
    func treatDelete(arr: [Message]) {}
    
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func postMessage(_ sender: Any) {
        print(textView.text)
        API42 = Singleton.shared.API42
        print(Singleton.shared.topicId!)
        API42?.addMessage(topicId : Singleton.shared.topicId!, message : textView.text)
        navigationController?.popViewController(animated: true)
    }
}
