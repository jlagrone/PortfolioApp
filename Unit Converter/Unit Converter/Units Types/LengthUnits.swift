//
//  LengthUnits.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/12/20.
//

import Foundation


struct LengthUnits: UnitProtocol {

    static var imageName: String { "ruler" }

    static let metric: [UnitLength] = [.megameters, .kilometers, .hectometers, .decameters, .meters,
                                 .decimeters, .centimeters, .millimeters, .micrometers, .nanometers,
                                 .picometers]
    static let imperial: [UnitLength] = [.inches, .feet, .yards, .miles, .nauticalMiles, .fathoms, .furlongs]

    static let other: [UnitLength] = [.scandinavianMiles, .lightyears, .astronomicalUnits, .parsecs]

    static var all: [UnitLength] {
        if usesImperial {
            return imperial + metric + other
        } else {
            return metric + imperial + other
        }
    }

}

