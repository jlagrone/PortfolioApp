//
//  TemperatureUnits.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/14/20.
//

import Foundation

struct TemperatureUnits: UnitProtocol {

    static var imageName: String { "thermometer" }

    static let metric: [UnitTemperature] = [.fahrenheit]

    static let imperial: [UnitTemperature] = [.celsius, .kelvin]

    static let other: [UnitTemperature] = []

    static var all: [UnitTemperature] {
        if usesImperial {
            return imperial + metric + other
        } else {
            return metric + imperial + other
        }
    }

}
