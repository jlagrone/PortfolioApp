//
//  VolumeUnits.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/14/20.
//

import Foundation

/// Defines attributes for Volume conversions
struct VolumeUnits: UnitProtocol {
    static var imageName: String { "testtube.2" }

    static let metric: [UnitVolume] = [.megaliters, .kiloliters, .liters, .deciliters, .centiliters,
                                       .milliliters, .cubicKilometers, .cubicMeters, .cubicDecimeters,
                                       .cubicMillimeters, .metricCups]

    static let imperial: [UnitVolume] = [.teaspoons, .tablespoons, .fluidOunces, .cups, .pints,
                                         .quarts, .gallons, .imperialTeaspoons, .imperialTablespoons,
                                         .imperialFluidOunces, .imperialPints, .imperialQuarts,
                                         .imperialGallons,
                                         .bushels, .cubicInches, .cubicFeet, .cubicYards, .cubicMiles,
                                         .acreFeet]
    static var all: [UnitVolume] {
        if usesImperial {
            return imperial + metric
        } else {
            return metric + imperial
        }

    }
}
