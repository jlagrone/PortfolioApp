//
//  UnitProtocol.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/15/20.
//

import Foundation
import CoreData

/// Abstraction for reusing the *?Units* conversions
protocol UnitProtocol {

    /// String name of an SF Symbol
    static var imageName: String { get }

    /// An array of all units
    static var all: [Dimension] { get }

    /// A unit-specific function for a sample conversion for use in SwiftUI previews
    /// - Returns: a Conversion from one unit to another
    static func sampleConversion(context: NSManagedObjectContext?) -> Conversion
}

extension UnitProtocol {

    /// United States, Belize, and Myanmar (Burma) are still not on metric
    static var usesImperial: Bool {
        return ["US", "BZ", "MM"].contains(Locale.current.regionCode)
    }

    static func dimension(of symbol: String) -> Dimension? {
        for unit in all where unit.symbol == symbol {
            return unit
        }
        return nil
    }
}

struct UnitProtocolHelper {
    static func dimension(of symbol: String) -> Dimension? {
        if let dimension = LengthUnits.dimension(of: symbol) {
            return dimension
        }

        if let dimension = MassUnits.dimension(of: symbol) {
            return dimension
        }

        if let dimension = PressureUnits.dimension(of: symbol) {
            return dimension
        }

        if let dimension = TemperatureUnits.dimension(of: symbol) {
            return dimension
        }

        if let dimension = VolumeUnits.dimension(of: symbol) {
            return dimension
        }

        if let dimension = EnergyUnits.dimension(of: symbol) {
            return dimension
        }

        if let dimension = PowerUnits.dimension(of: symbol) {
            return dimension
        }

        if let dimension = AngleUnits.dimension(of: symbol) {
            return dimension
        }

        return nil
    }
}
