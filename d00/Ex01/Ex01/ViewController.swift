//
//  ViewController.swift
//  Ex01
//
//  Created by Martin SIREAU on 10/2/17.
//  Copyright © 2017 Martin SIREAU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickMe(_ sender: Any) {
        myLabel.text = "Hello World!"
    }

}
