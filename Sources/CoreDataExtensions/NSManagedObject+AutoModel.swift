// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 23/04/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import CoreData


public extension NSManagedObject {
    static func autoDescription() -> NSEntityDescription {
        let entity = NSEntityDescription()
        let fullName = Self.className()
        let shortName = String(fullName.split(separator: ".").last!)
        
        entity.name = shortName
        entity.managedObjectClassName = fullName
        
        forEach(applicationOf: class_copyPropertyList) { property in
            let name = property.name
            var isDynamic = false
            var type: String? = nil
            CoreDataExtensions.forEach(applicationOf: property_copyAttributeList, to: property) { attribute in
                switch attribute.name[0] {
                    case CChar("D"):
                        isDynamic = true
                        
                    case CChar("T"):
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
                
            default:
                fatalError("unhandled type \(type)")
        }
        description.attributeType = .stringAttributeType
        description.isOptional = false
        return description
    }
}
