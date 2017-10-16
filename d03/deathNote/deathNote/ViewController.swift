//
//  ViewController.swift
//  deathNote
//
//  Created by Martin SIREAU on 10/4/17.
//  Copyright © 2017 Martin SIREAU. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
   
    @IBOutlet weak var myTableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        myTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.dataSource = self
        self.title = "Death Note"
        myTableView.rowHeight  = UITableViewAutomaticDimension
        myTableView.estimatedRowHeight = 140
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Singleton.shared.name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MyTableViewCell = self.myTableView.dequeueReusableCell(withIdentifier: "myCell") as! MyTableViewCell
        cell.namelbl.text = Singleton.shared.name[indexPath.row]
        cell.deathLbl.text = Singleton.shared.death[indexPath.row]
        cell.dateLbl.text = Singleton.shared.date[indexPath.row]
        return cell
    }
    


}

