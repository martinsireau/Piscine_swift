//
//  Article+CoreDataClass.swift
//  Pods
//
//  Created by Martin SIREAU on 10/13/17.
//
//

import Foundation
import CoreData

@objc(Article)
public class Article: NSManagedObject {

    public override var description: String {
        return ("title: \(String(describing: self.title)), content: \(String(describing: self.content)), creationDate: \(String(describing: self.creationDate)), modificationDate = \(String(describing: self.modificationDate)), language = \(String(describing: self.langage)), picture = \(String(describing: self.image))")
    }
    
}
