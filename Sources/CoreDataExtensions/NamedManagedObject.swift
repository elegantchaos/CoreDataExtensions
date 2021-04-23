// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 23/04/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import CoreData

/// Core data class that has a name property which can be used to fetch it.
public protocol NamedManagedObject: NSManagedObject {
    var name: String { get set }
    static func named(_ named: String, in context: NSManagedObjectContext) -> Self
    static func named(_ named: String, in context: NSManagedObjectContext, createIfMissing: Bool) -> Self?
}

public extension NamedManagedObject {
    
    /**
     Return the entity of our type with a given name, or make it if it doesn't exist.
    */
    
    static func named(_ named: String, in context: NSManagedObjectContext) -> Self {
        return self.named(named, in: context, createIfMissing: true)!
    }
    
    /**
     Return the entity of our type with a given name.
     If it doesn't exist, we optionally create it, or return nil.
    */
    
    static func named(_ named: String, in context: NSManagedObjectContext, createIfMissing: Bool) -> Self? {

        let request: NSFetchRequest<Self> = fetcher(in: context)
        request.predicate = NSPredicate(format: "name = %@", named)
        if let results = try? context.fetch(request), let object = results.first {
            return object
        }
        
        if createIfMissing {
            let description = entityDescription(in: context)
            if let object = NSManagedObject(entity: description, insertInto: context) as? Self {
                object.name = named
                return object
            }
        }
        
        return nil

    }

}
