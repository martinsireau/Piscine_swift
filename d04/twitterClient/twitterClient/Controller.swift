//
//  Controller.swift
//  twitterClient
//
//  Created by Martin SIREAU on 10/6/17.
//  Copyright © 2017 Martin SIREAU. All rights reserved.
//

import Foundation

class APIController {
    
    weak var delegate : APITwitterDelegate?
    
    let token : String = ""
    
    init(twiterDelegate: APITwitterDelegate?, token:     String) {
        self.delegate = twiterDelegate
    }
    
    static var allTweets : [Tweet] = []
    
    func twitterRequest(content: String){
        let q = content.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let url = URL(string: "https://api.twitter.com/1.1/search/tweets.json?q=\(q)&count=100&lang=fr&result_type=recent")
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer " + Singleton.accessToken, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            (data, response, error) in
            print(response ?? "RESPONSE IS NIL")
            if let err = error {
                print(err)
            } else if let d = data {
                do{
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: []) as? NSDictionary{
                        self.processResult(dic: dic)
                    }
                }
                catch (let err){
                    self.delegate?.errorBack(error: err as NSError)
                    print(err)
                }
            }
        }
        task.resume()
    }
    
    func processResult(dic: NSDictionary){
        var tweets: [Tweet] = []
        var nameT = String()
        var textT = String()
        var dateT = String()
        
        if let tweetsD: [NSDictionary] = dic["statuses"] as? [NSDictionary] {
            for tweet in tweetsD {
                if let date : String = tweet["created_at"] as? String{
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "E MMM dd HH:mm:ss Z yyyy"
                    if let date = dateFormatter.date(from: date) {
                        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                        let newDate = dateFormatter.string(from: date)
                        dateT = newDate
                    }
                }
                if let text : String = tweet["text"] as? String{
                    textT = text
                }
                if let user : [String : Any] = tweet["user"] as? [String : Any] {
                    if let name : String = user["name"] as? String{
                        nameT = name
                    }
                }
                tweets.append(Tweet(name: nameT, text: textT, date: dateT))
            }
        }
//        Singleton.allTweets = tweets
//        print(Singleton.allTweets[0].name)
        self.delegate?.processTweet(tweets: tweets)
//        DispatchQueue.main.async {
//            self.myTableView.reloadData()
//        }
    }

}
