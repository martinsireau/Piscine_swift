//
//  ScndViewController.swift
//  d09
//
//  Created by Martin SIREAU on 10/14/17.
//  Copyright © 2017 Martin SIREAU. All rights reserved.
//

import UIKit
import msireau2017

class ScndViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var arr = [Article]()
    @IBOutlet weak var myTableVC: UITableView!
    @IBOutlet weak var myNvigationItam: UINavigationItem!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var articleManager : ArticleManager?

    override func viewWillAppear(_ animated: Bool) {
        if let allArticles = articleManager?.getArticles(withLang: Locale.preferredLanguages[0]){
            arr = allArticles
        }
        myTableVC.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        articleManager = ArticleManager(managedObjectContext: self.context)

        if let allArticles = articleManager?.getArticles(withLang: Locale.preferredLanguages[0]){
            arr = allArticles
        }
        myTableVC.rowHeight  = UITableViewAutomaticDimension
        myTableVC.estimatedRowHeight = 140

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ArticleTableViewCell = self.myTableVC.dequeueReusableCell(withIdentifier: "myCell") as! ArticleTableViewCell
        
        cell.myTitle.text = arr[indexPath.row].title
        cell.contentLabel.text = arr[indexPath.row].content
        
        if let myCreationDate = arr[indexPath.row].creationDate {
            cell.creationLabel.text = ("Creation : \(String(describing: myCreationDate.toString()))")
        }
        
        if let myModifDate = arr[indexPath.row].modificationDate {
            let modifTxt = arr[indexPath.row].modificationDate
            let crea = arr[indexPath.row].creationDate
            if crea?.toString() != modifTxt?.toString() {
                cell.modificationLabel.text = ("Modification : \(String(describing: myModifDate.toString()))")
            }
        }
        
        if let myImageData = arr[indexPath.row].image{
            cell.myImageView.image = UIImage(data: myImageData as Data)
        }
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateArticleViewController") as! CreateArticleViewController

        myVC.theArticle = arr[indexPath.row]
        myVC.isJustCreate = false
//        myVC.myTextField.text = arr[indexPath.row].modificationDate
        self.navigationController?.pushViewController(myVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            articleManager?.removeArticle(article: arr[indexPath.row])
            if let allArticles = articleManager?.getArticles(withLang: Locale.preferredLanguages[0]){
                arr = allArticles
            }
            articleManager?.save()
            myTableVC.reloadData()
        }
    }
    
}

extension NSDate {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM y HH:mm:ss"
        return dateFormatter.string(from: self as Date)
    }
}
