//
//  ViewController.swift
//  Ex02
//
//  Created by Martin SIREAU on 10/2/17.
//  Copyright © 2017 Martin SIREAU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var resultLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func numbers(_ sender: UIButton) {
        if let numberTxt = sender.titleLabel?.text {
            print(numberTxt);
            resultLbl.text = numberTxt
        }
    }

    @IBAction func operand(_ sender: UIButton) {
        if let operandTxt = sender.titleLabel?.text {
            print(operandTxt);
        }
    }
}
