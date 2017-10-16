//
//  ViewController.swift
//  rush00
//
//  Created by Jordan BOYER on 10/7/17.
//  Copyright © 2017 msireau/joboyer. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate {
    
    var token : String?
    var clientToken : String?
    var userToken : String?
    
    var code : String?
    
    
    @IBOutlet weak var myWebView: UIWebView!
    
    func getToken() {
        let UID : String = "99fca815f8b25bb1ddf346ad2dba265eb9238ae4990ea8cc68b3431fb44b3757"
        let secret : String = "465465440ccd9a10304afffcba0518f4d4043824a23effc87814dc625311fe5a"
        
        let url = NSURL(string: "https://api.intra.42.fr/oauth/token")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials&client_id=\(UID)&client_secret=\(secret)".data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if let err = error {
                print (err)
            } else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        if let t = dic["access_token"] as? String {
                            self.token = t
                            print(self.token ?? "lol")
                        }
                    }
                } catch (let err) {
                    print (err)
                }
            }
        }
        task.resume()
    }
    
    func getUserToken(code: String) {
        let UID : String = "99fca815f8b25bb1ddf346ad2dba265eb9238ae4990ea8cc68b3431fb44b3757"
        let secret : String = "465465440ccd9a10304afffcba0518f4d4043824a23effc87814dc625311fe5a"
        
        let url = NSURL(string: "https://api.intra.42.fr/oauth/token")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("Bearer \(self.token!)", forHTTPHeaderField: "Authorization")
        request.httpBody = "grant_type=authorization_code&client_id=\(UID)&client_secret=\(secret)&code=\(code)&redirect_uri=https://www.42.fr&scope=public%20forum&state=coucou&state=abcdefghijklmnopqrstuvwxyz".data(using: String.Encoding.utf8)
//        request.httpBody = "grant_type=authorization_code&client_id=\(UID)&client_secret=\(secret)&code=\(code)&redirect_uri=https://www.42.fr&state=abcdefghijklmnopqrstuvwxyz".data(using: String.Encoding.utf8)
//request.httpBody = "grant_type=authorization_code&client_id=\(Constants.CLIENT_ID)&client_secret=\(Constants.CLIENT_SECRET)&code=\(code)&redirect_uri=\(Constants.URI)&scope=public%20forum&state=coucou".data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if let err = error {
                print (err)
            } else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary {
                        if let t = dic["access_token"] as? String {
                            self.clientToken = t
                            self.userToken = t
                            print(t)
                            let tv = TableViewController()
                            tv.token = self.userToken
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "whenLogged", sender: self)
                            }
                            
                        }
                    }
                } catch (let err) {
                    print (err)
                }
            }
        }
        task.resume()
        
    }
    
    
    func webViewUse() {
        let urlValue = "https://api.intra.42.fr/oauth/authorize?client_id=99fca815f8b25bb1ddf346ad2dba265eb9238ae4990ea8cc68b3431fb44b3757&state=abcdefghijklmnopqrstuvwxyz&redirect_uri=https%3A%2F%2Fwww.42.fr&scope=public+forum&response_type=code"
        //        let urlValue = "https://api.intra.42.fr/oauth/authorize?client_id=cfb5712085f1281b38f8028f962698be2cff6abd9fe5417bdb5e003fd5fae717&state=abcdefghijklmnopqrstuvwxyz&redirect_uri=https://www.42.fr&scope=public+forum&response_type=code"
        
        if let url = URL (string: urlValue){
            let requestObj = URLRequest(url: url)
            _ = self.myWebView.loadRequest(requestObj)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "whenLogged" {
            if let tv = segue.destination as? TableViewController {
                tv.token = self.clientToken
//                tv.userId = Int(self.userID!)
            }
        }
    }

    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let myUrl = request.url?.absoluteString
        let host = NSURLComponents(string: myUrl!)?.host
        let d = NSURLComponents(string: myUrl!)
        if host == "www.42.fr" {
            if let c =  d?.query {
                code = c.components(separatedBy: "&")[0]
                code = code?.components(separatedBy: "=")[1]
                
                getUserToken(code: code!)
                webView.stopLoading()
            }
        }
//        if (navigationType == UIWebViewNavigationType.linkClicked) {
//            print("link clicked = \(request.mainDocumentURL?.absoluteString)")
//        }
        return true
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myWebView.delegate = self
        self.getToken()
        self.webViewUse()
    }
    
}

