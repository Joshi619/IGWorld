//
//  ArrayDict+Extension.swift
//  IGWorld
//
//  Created by ADITYA on 27/09/24.
//

import Foundation

extension Dictionary {
    //    Since Dictionary conforms to CollectionType, and its Element typealias is a (key, value) tuple, that means you ought to be able to do something like this:
    //
    //    result = dict.map { (key, value) in (key, value.uppercaseString) }
    //
    //    However, that won't actually assign to a Dictionary-typed variable. THE MAP METHOD IS DEFINED TO ALWAYS RETURN AN ARRAY (THE [T]), even for other types like dictionaries. If you write a constructor that'll turn an array of two-tuples into a Dictionary and all will be right with the world:
    //  Now you can do this:
    //    result = Dictionary(dict.map { (key, value) in (key, value.uppercaseString) })
    //
    init(_ pairs: [Element]) {
        self.init()
        for (k, v) in pairs {
            self[k] = v
        }
    }

    //    You may even want to write a Dictionary-specific version of map just to avoid explicitly calling the constructor. Here I've also included an implementation of filter:
    //    let testarr = ["foo" : 1, "bar" : 2]
    //    let result = testarr.mapPairs { (key, value) in (key, value * 2) }
    //    result["bar"]
    func mapPairs<OutKey: Hashable, OutValue>(transform: (Element) throws -> (OutKey, OutValue)) rethrows -> [OutKey: OutValue] {
        return Dictionary<OutKey, OutValue>(try map(transform))
    }
}

extension Array where Element: Hashable {
    func uniqued() -> Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
