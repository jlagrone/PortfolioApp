//
//  UnitProtocol.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/15/20.
//

import Foundation

protocol UnitProtocol {

    static var imageName: String { get }

}

extension UnitProtocol {

    static var usesImperial: Bool {
        return ["US", "BZ", "MM"].contains(Locale.current.regionCode)
    }

//    static var imageName: String { "" }
}
