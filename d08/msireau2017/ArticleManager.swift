//
//  ArticleManager.swift
//  Pods
//
//  Created by Martin SIREAU on 10/13/17.
//
//

import Foundation
import CoreData

public class ArticleManager: NSObject {
    
    public var managedObjectContext: NSManagedObjectContext?
    
    public init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        
        let myBundle = Bundle(for: Article.self)
        
        //This resource is the same name as your xcdatamodeld contained in your project
        guard let modelURL = myBundle.url(forResource: "article", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        queue.async {
            guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
                fatalError("Unable to resolve document directory")
            }
            let storeURL = docURL.appendingPathComponent("msireau2017.sqlite")
            do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
                //The callback block is expected to complete the User Interface and therefore should be presented back on the main queue so that the user interface does not need to be concerned with which queue this call is coming from.
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }
    
    public func newArticle() -> Article {
        return NSEntityDescription.insertNewObject(forEntityName: "Article", into: self.managedObjectContext!) as! Article
    }
    
    public func getAllArticles() -> [Article] {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        
        do {
            if let fetchedArticles = try self.managedObjectContext?.fetch(fetch) as? [Article] {
                return fetchedArticles
            }
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        return []
    }
    
    public func getArticles(withLang lang : String) -> [Article] {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        fetch.predicate = NSPredicate(format: "langage == %@", lang)
        
        do {
            if let fetchedArticles = try self.managedObjectContext?.fetch(fetch) as? [Article] {
                return fetchedArticles
            }
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        return []
    }
    
    public func getArticles(containString str : String) -> [Article] {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        let predicate1 = NSPredicate(format: "title CONTAINS %@", str)
        let predicate2 = NSPredicate(format: "content CONTAINS %@", str)
        
        let predicateCompound = NSCompoundPredicate.init(type: .or, subpredicates: [predicate1,predicate2])
        
        fetch.predicate = predicateCompound
        
        do {
            if let fetchedArticles = try self.managedObjectContext?.fetch(fetch) as? [Article] {
                return fetchedArticles
            }
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        return []
    }
    
    public func removeArticle(article : Article) {
        self.managedObjectContext?.delete(article)
    }
    
    public func save() {
        if (managedObjectContext?.hasChanges)! {
            do {
                try self.managedObjectContext?.save()
            }
            catch{
                fatalError("Failure to save content \(error)");
            }
        }
    }
}
