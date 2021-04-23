// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 23/04/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

func forEach<O,T>(applicationOf getter: (O, UnsafeMutablePointer<UInt32>) -> UnsafeMutablePointer<T>?, to: O, perform: (T) -> ()) {
    var count: UInt32 = 0
    if let result = getter(to, &count) {
        for n in 0 ..< Int(count) {
            perform(result[n])
        }
    }
}

extension NSObject {
    static func forEach<T>(applicationOf getter: (AnyClass?, UnsafeMutablePointer<UInt32>) -> UnsafeMutablePointer<T>?, perform: (T) -> ()) {
        var count: UInt32 = 0
        if let result = getter(self, &count) {
            for n in 0 ..< Int(count) {
                perform(result[n])
            }
        }
    }
}

extension objc_property_t {
    var name: String {
        String(utf8String: property_getName(self))!
    }
}
