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
    private var userIsInTheMiddleOfTyping = false
    private var currentSign = ""
    private var accumulator = 0
    private var pending = false
    private var numberAfterSign = false
    private var isOverflow = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func numbers(_ sender: UIButton) {
        let textCurrentlyInDisplay = resultLbl.text

        if let numberTxt = sender.titleLabel?.text {
            resultLbl.text = numberTxt
            if userIsInTheMiddleOfTyping {
                resultLbl.text = textCurrentlyInDisplay! + numberTxt
            } else {
                resultLbl.text = numberTxt
                userIsInTheMiddleOfTyping = true
            }
            numberAfterSign = true
        }
    }

    @IBAction func operand(_ sender: UIButton) {
        if let signTxt = sender.titleLabel?.text{
            if userIsInTheMiddleOfTyping {
                userIsInTheMiddleOfTyping = false
            }
      
            switch signTxt {
            case "AC":
                reset(toDisplay: "0")
            case "NEG":
                if let myNum = Int(resultLbl.text!){
                        resultLbl.text = String(-(myNum))
                }
                binaryOperation(sign: currentSign)
                if (isOverflow){
                    isOverflow = false
                    return
                }
                if let myNum = Int(resultLbl.text!), accumulator == 0{
                    accumulator = myNum
                    resultLbl.text = String(accumulator)
                    return
                }
                resultLbl.text = String(accumulator)
            case "=":
                numberAfterSign = true
                binaryOperation(sign: currentSign)
                pending = false
            default:
                binaryOperation(sign: currentSign)
                currentSign = signTxt
            }
        }
    }
    
    
    func binaryOperation(sign : String) {
        if let nbDisplay = Int(resultLbl.text!), pending, numberAfterSign{
            switch sign {
            case "+":
                let value = Int.addWithOverflow(accumulator, nbDisplay)
                if (value.overflow){
                    reset(toDisplay: "Overflow")
                    return
                } else {
                    accumulator += nbDisplay
                }
            case "-":
                let value = Int.subtractWithOverflow(accumulator, nbDisplay)
                if (value.overflow){
                    reset(toDisplay: "Overflow")
                    return
                } else {
                    accumulator -= nbDisplay
                }
            case "*":
                let value = Int.multiplyWithOverflow(accumulator, nbDisplay)
                if (value.overflow){
                    reset(toDisplay: "Overflow")
                    return
                } else {
                    accumulator *= nbDisplay
                }

            case "/":
                if (nbDisplay != 0){
                    let value = Int.divideWithOverflow(accumulator, nbDisplay)
                    if (value.overflow){
                        reset(toDisplay: "Overflow")
                        return
                    } else {
                        accumulator /= nbDisplay
                    }

                } else {
                    reset(toDisplay: "Error")
                    return
                }
            default:
                break
            }
            resultLbl.text = String(accumulator)
        } else {
            if let nbDisplay = Int(resultLbl.text!){
                accumulator = nbDisplay
            } else {
                reset(toDisplay: "Overflow")
            }
            pending = true
        }
        numberAfterSign = false
    }
    
    func reset(toDisplay: String) {
        if (toDisplay == "Overflow"){
            isOverflow = true
        }
        resultLbl.text = toDisplay
        accumulator = 0
        currentSign = ""
        pending = false
        
    }
}
