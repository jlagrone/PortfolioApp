//
//  VolumeUnits.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/14/20.
//

import Foundation
import CoreData

/// Defines attributes for Volume conversions
struct VolumeUnits: UnitProtocol {
   static var imageName: String { "testtube.2" }

   static let metric: [UnitVolume] =
   [.megaliters, .kiloliters, .liters, .deciliters,
    .centiliters, .milliliters, .cubicKilometers,
    .cubicMeters, .cubicDecimeters, .cubicMillimeters,
    .metricCups]

   static let imperial: [UnitVolume] =
   [.teaspoons, .tablespoons, .fluidOunces, .cups, .pints,
    .quarts, .gallons, .imperialTeaspoons,
    .imperialTablespoons, .imperialFluidOunces,
    .imperialPints, .imperialQuarts, .imperialGallons,
    .bushels, .cubicInches, .cubicFeet, .cubicYards,
    .cubicMiles, .acreFeet]

   static var all: [Dimension] {
      if usesImperial {
         return imperial + metric
      } else {
         return metric + imperial
      }

   }

   static let sampleMeasurement = Measurement(value: Double.pi, unit: UnitVolume.liters)

   static func sampleConversion(context: NSManagedObjectContext) -> Conversion {
      let resultUnit = UnitVolume.milliliters
      let result = sampleMeasurement.converted(to: resultUnit)
      return Conversion(type: ConversionType.volume,
                        date: Date(),
                        inputUnit: sampleMeasurement.unit.symbol,
                        inputValue: sampleMeasurement.value,
                        resultUnit: result.unit.symbol,
                        resultValue: result.value,
                        context: context)
   }
}
