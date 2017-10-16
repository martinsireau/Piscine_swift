//
//  ViewController.swift
//  twitterClient
//
//  Created by Martin SIREAU on 10/6/17.
//  Copyright © 2017 Martin SIREAU. All rights reserved.
//

import UIKit

protocol APITwitterDelegate : class {
    func processTweet(tweets: [Tweet])
    func errorBack(error: NSError)
}

class ViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate, APITwitterDelegate {
    
    func errorBack(error: NSError) {
        print("An error has occured : \(error)")
        let alert = UIAlertController(title: "Error", message: "No match for this request", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func processTweet(tweets: [Tweet]) {
//        Singleton.allTweets = tweets
        self.Tweets = tweets
        DispatchQueue.main.async {
            self.myTableView.reloadData()
        }
    }

    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myTextField: UITextField!
    
    var Tweets : [Tweet] = []
    var TwitterCtrl : APIController?
    var content = "ecole 42"
    let url = URL(string: "https://api.twitter.com/oauth2/token")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("Basic " + Singleton.BEARER, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            (data, response, error) in
            print(response ?? "RESPONSE IS NIL")
            if let err = error {
                print(err)
            } else if let d = data {
                do{
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: []) as? NSDictionary{
                        self.retrieveToken(myDic :dic)
                        self.TwitterCtrl = APIController(twiterDelegate: self, token: Singleton.accessToken)
                        self.TwitterCtrl?.twitterRequest(content: self.content)
                    }
                }
                catch (let err){
                    print(err)
                }
            }
        }
        task.resume()
        
        myTableView.estimatedRowHeight = 85
        myTableView.rowHeight  = UITableViewAutomaticDimension
    }
    
    func retrieveToken(myDic: NSDictionary){
        Singleton.accessToken = myDic.value(forKey: "access_token") as! String
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goFetchTweet"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MyTableViewCell = self.myTableView.dequeueReusableCell(withIdentifier: "myCell") as! MyTableViewCell
        cell.userName.text = self.Tweets[indexPath.row].name
        cell.date.text = self.Tweets[indexPath.row].date
        cell.tweet.text = self.Tweets[indexPath.row].text

        return cell
    }
    
    func tableView(tableView: UITableView,heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return UITableViewAutomaticDimension
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        content = myTextField.text!
        myTextField.resignFirstResponder()
        self.TwitterCtrl?.twitterRequest(content: self.content)
        myTableView.reloadData()
        return true
    }
    
}
