//
//  ViewController.swift
//  d07
//
//  Created by Martin SIREAU on 10/11/17.
//  Copyright © 2017 Martin SIREAU. All rights reserved.
//

import UIKit
import RecastAI
import ForecastIO

class ViewController: UIViewController {

    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet weak var myLabel: UILabel!
    
    let bot = RecastAIClient(token : "86e58d61cf0d5e00923fc2dfd506d48b", language: "fr")
    let darkSkyClient = DarkSkyClient(apiKey: "a265eff50f4af5817a0cac58a3afa3a7")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func myButton(_ sender: Any) {
        self.makeRecastRequest(request: myTextField.text!)
      
    }

    func makeRecastRequest(request: String) {
        if request != ""{
            self.bot.textConverse(request, successHandler: recastResponse, failureHandle: recastError)
        } else {
            self.myLabel.text = "Request can't be empty"
        }
    }
    
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
                        self.myLabel.text = "\(formatted!) is \((value.hourly!.summary)!)"
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
                            self.myLabel.text = mySlug
                        }
                    }

                }
            } else {
                self.myLabel.text = "Error"
                print("Error")
            }
        }
    }
    
    func recastError(error: Error) {
        self.myLabel.text = "Error"
        print(error)
    }
    
}

