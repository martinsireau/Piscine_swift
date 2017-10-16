//
//  Article+CoreDataProperties.swift
//  Pods
//
//  Created by Martin SIREAU on 10/13/17.
//
//

import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var creationDate: NSDate?
    @NSManaged public var modificationDate: NSDate?
    @NSManaged public var langage: String?
    @NSManaged public var image: NSData?

}
