// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 23/04/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import CoreData
import Foundation

public extension NSManagedObject {
    static func autoDescription() -> NSEntityDescription {
        let entity = NSEntityDescription()
        let fullName = Self.self.description() // includes the module name
        let shortName = String(describing: Self.self)
        
        entity.name = shortName
        entity.managedObjectClassName = fullName
        
        forEach(applicationOf: class_copyPropertyList) { property in
            let name = property.name
            var isDynamic = false
            var type: String? = nil
            CoreDataExtensions.forEach(applicationOf: property_copyAttributeList, to: property) { attribute in
                let char = Int(attribute.name[0])
                let scalar = Unicode.Scalar(char)!
                switch Character(scalar) {
                    case "D":
                        isDynamic = true
                        
                    case "T":
                        type = String(utf8String: attribute.value)
                        
                    default:
                        break
                }
            }
            
            if isDynamic, let type = type {
                let attribute = attribute(name: name, type: type)
                entity.properties.append(attribute)
            }
        }
        
        print(entity)
        return entity
    }
    
    static func attribute(name: String, type: String) -> NSAttributeDescription {
        let description = NSAttributeDescription()
        description.name = name
        switch type {
            case "B":
                description.attributeType = .booleanAttributeType
                
            case "s":
                description.attributeType = .integer16AttributeType
                
            case "q":
                description.attributeType = .integer64AttributeType
                
            case "@\"NSString\"":
                description.attributeType = .stringAttributeType
                
            case "@\"NSDate\"":
                description.attributeType = .dateAttributeType

            case "@\"NSUUID\"":
                description.attributeType = .UUIDAttributeType

            default:
                fatalError("unhandled type \(type)")
        }
        description.isOptional = true // Cloudkit requires this to be true, but we will arrange for there to always be a value
        return description
    }
}
