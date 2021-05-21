// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 23/04/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import CoreData

/// Core data class that has an id property which can be used to fetch it.
@available(macOS 10.15, iOS 13.0, *) public protocol IdentifiedManagedObject where Self: NSManagedObject, Self: Identifiable {
    var id: Self.ID { get set }
    static func predicateArgument(for id: Self.ID) -> CVarArg
    static func withID(_ id: Self.ID, in context: NSManagedObjectContext) -> Self
    static func withID(_ id: Self.ID, in context: NSManagedObjectContext, createIfMissing: Bool) -> Self?
}

@available(macOS 10.15, iOS 13.0, *) public extension IdentifiedManagedObject {
    /// Return an entity of our type with the given id, creating it if necessary.
    /// - Parameters:
    ///   - id: the entity id
    ///   - context: the context the entity belongs to
    /// - Returns: the entity
    static func withID(_ id: Self.ID, in context: NSManagedObjectContext) -> Self {
        return withID(id, in: context, createIfMissing: true)!
    }

    /// Return an entity of our type with the given id, optionally creating it.
    /// - Parameters:
    ///   - id: the entity id
    ///   - context: the context the entity belongs to
    ///   - createIfMissing: should we make a new one if necessary?
    /// - Returns: the entity, or nil if it wasn't there
    static func withID(_ id: Self.ID, in context: NSManagedObjectContext, createIfMissing: Bool = false) -> Self? {
        let request: NSFetchRequest<Self> = fetcher(in: context)
        request.predicate = NSPredicate(format: "id = %@", predicateArgument(for: id))
        if let results = try? context.fetch(request), let object = results.first {
            return object
        }

        if createIfMissing {
            let description = entityDescription(in: context)
            if let object = NSManagedObject(entity: description, insertInto: context) as? Self {
                object.id = id
                return object
            }
        }

        return nil
    }
    
    static func predicateArgument(for id: Self.ID) -> CVarArg where ID: CVarArg {
        id
    }
    
    static func predicateArgument(for id: UUID) -> CVarArg {
        id as CVarArg
    }
}
