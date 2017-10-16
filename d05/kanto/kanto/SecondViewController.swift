//
//  SecondViewController.swift
//  kanto
//
//  Created by Martin SIREAU on 10/9/17.
//  Copyright © 2017 Martin SIREAU. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var myTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Singleton.shared.selectedPlace = Singleton.shared.allPlaces[indexPath.row]
        self.tabBarController?.selectedIndex = 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Singleton.shared.allPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTV.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = Singleton.shared.allPlaces[indexPath.row].name
        return cell!
    }
}
