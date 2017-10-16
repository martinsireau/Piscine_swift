//
//  AddAPersonViewController.swift
//  deathNote
//
//  Created by Martin SIREAU on 10/4/17.
//  Copyright © 2017 Martin SIREAU. All rights reserved.
//

import UIKit

class AddAPersonViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var myPickerDate: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add a Person"
        
        myTextField.delegate = self
        descriptionTextView.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        
        self.descriptionTextView.layer.borderWidth = 1.0;
        self.descriptionTextView.layer.borderColor = UIColor.black.cgColor;
        
        myPickerDate.minimumDate = Date()
        myPickerDate.locale = Locale.init(identifier: "FR_fr")
        descriptionTextView.textColor = UIColor.black
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    func convertDate() -> String{
        let date = myPickerDate.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM y HH:mm:ss"
        let dateString = dateFormatter.string(from:date as Date)
        return dateString
    }
    
    func doneTapped(){
        if let name = myTextField.text, name != ""{
            Singleton.shared.name.append(name)
            Singleton.shared.death.append(descriptionTextView.text)
            Singleton.shared.date.append(convertDate())
        }
        
        print("Name = \(myTextField.text ?? "NO NAME SET")")
        print("Description = \(descriptionTextView.text!)")
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
