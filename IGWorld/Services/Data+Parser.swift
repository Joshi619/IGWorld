//
//  Data+Parser.swift
//  IGWorld
//
//  Created by ADITYA on 27/09/24.
//

import Foundation

class Parser {
    static func commonDataParser<T>(_ data: Data) -> T?  where T : Decodable {
        do {
            let contactModelElement = try JSONDecoder().decode(T.self, from: data)

            return contactModelElement
        } catch {
            debugPrint(error)
        }
        return nil
    }
}
