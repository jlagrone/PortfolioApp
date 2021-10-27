//
//  PressureUnits.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/14/20.
//

import Foundation

struct PressureUnits: UnitProtocol {

    static var imageName: String { "barometer" }
    static let metric: [UnitPressure] = [.newtonsPerMetersSquared, .gigapascals,
                                         .megapascals, .kilopascals,
                                         .hectopascals, .bars, .millibars,
                                         .millimetersOfMercury]

    static let imperial: [UnitPressure] = [.inchesOfMercury, .poundsForcePerSquareInch]

    static let other: [UnitPressure] = []

    static var all: [UnitPressure] {
        if usesImperial {
            return imperial + metric + other
        } else {
            return metric + imperial + other
        }
    }

}
