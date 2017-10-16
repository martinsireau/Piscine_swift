//
//  SecondViewController.swift
//  rush01
//
//  Created by Marc FAMILARI on 10/14/17.
//  Copyright © 2017 Marc FAMILARI. All rights reserved.
//

import UIKit
import MapKit

class SecondViewController: UIViewController {
    
    
    var destCoor: CLPlacemark? {
        didSet {
            if self.startCoor != nil, self.destCoor != nil {
                if let navVC = self.tabBarController?.viewControllers?[0] as? UINavigationController{
                    if let firstVC  = navVC.visibleViewController as? FirstViewController{
                        firstVC.traceRoute(sourceLoc: self.startCoor!, destLoc: self.destCoor!)
                        tabBarController?.selectedIndex = 0
                    }
                }
            }
        }
    }
    
    var startCoor: CLPlacemark? {
        didSet {
            if self.destCoor != nil, self.startCoor != nil {
                if let navVC = self.tabBarController?.viewControllers?[0] as? UINavigationController{
                    if let firstVC  = navVC.visibleViewController as? FirstViewController{
                        firstVC.traceRoute(sourceLoc: self.startCoor!, destLoc: self.destCoor!)
                        tabBarController?.selectedIndex = 0
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func traceRoute(_ sender: Any) {
        self.startCoor = nil
        self.destCoor = nil
        
        if let address1 = startTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            if let address2 = destinationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines){
                if address1 != "", address2 != "" {
                    getLocationFromAdress(adress: address1, isDest: false)
                    getLocationFromAdress(adress: address2, isDest: true)
                }
                else { self.displayAlert() }
            }
        }
    }
    
    
    
    func getLocationFromAdress(adress: String, isDest: Bool){
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(adress) { (placemarks, error) in
            guard let placemark = placemarks?.first
                else {
                    self.displayWrongLocationAlert()
                    return
            }
            if isDest { self.destCoor = placemark }
            else { self.startCoor = placemark }
        }
    }
    
    
    
    
    //MARK: - UIAlert
    
    func displayWrongLocationAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Something is wrong", message: "You have to write an address we can understand", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: {(action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func displayAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Something is missing", message: "You have to write down 2 addreses", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: {(action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
