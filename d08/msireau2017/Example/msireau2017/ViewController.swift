//
//  ViewController.swift
//  msireau2017
//
//  Created by martinsireau on 10/12/2017.
//  Copyright (c) 2017 martinsireau. All rights reserved.
//

import UIKit
import msireau2017

@available(iOS 10.0, *)
class ViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let articleManager = ArticleManager(managedObjectContext: self.context)
        
        let article1 = articleManager.newArticle()
        article1.title = "Kebab Full Moon"
        article1.content = "Le Meilleur Kebab de paname"
        article1.creationDate = NSDate()
        article1.modificationDate = NSDate()
        article1.langage = "fr"
        
        articleManager.save()
        
        let article2 = articleManager.newArticle()
        article2.title = "istanbul kebab"
        article2.content = "The worst kebab on earth"
        article2.creationDate = NSDate()
        article2.modificationDate = NSDate()
        article2.langage = "en"
        
        articleManager.save()
        
        print("\nAll article:\n")
        print(articleManager.getAllArticles())
        
        print("\ncontainsString : Meilleur :\n")
        print(articleManager.getArticles(containString: "Meilleur"))
        
        print("\nWithLang: english:\n")
        print(articleManager.getArticles(withLang: "en"))
        
        print("\nRemoveArticle : 2\n")
        print(articleManager.removeArticle(article: article2))
        
        print("\nGetAllArticles:\n")
        print(articleManager.getAllArticles())
    }
}
