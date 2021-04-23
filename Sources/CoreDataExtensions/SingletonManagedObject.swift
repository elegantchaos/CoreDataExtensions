// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 23/04/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import CoreData
import Logger

let singletonManagedObjectChannel = Channel("com.elegantchaos.coredatautilities.SingletonManagedObject")

/// Core data class which should only ever have one instance in a context.
public protocol SingletonManagedObject: NSManagedObject {
    static func possibleInstance(in context: NSManagedObjectContext) -> Self?
    static func instance(in context: NSManagedObjectContext) -> Self
}

public extension SingletonManagedObject {
    static func possibleInstance(in context: NSManagedObjectContext) -> Self? {
        let request: NSFetchRequest<Self> = fetcher(in: context)
        do {
            let objects = try context.fetch(request)
            if let stored = objects.first {
                for spare in objects.dropFirst() {
                    singletonManagedObjectChannel.debug("Deleted duplicate model \(spare)")
                    context.delete(spare)
                }
                return stored
            }
        } catch {
            singletonManagedObjectChannel.debug(error)
        }
        return nil

    }

    static func instance(in context: NSManagedObjectContext) -> Self {
        possibleInstance(in: context) ?? Self(context: context)
    }
}
