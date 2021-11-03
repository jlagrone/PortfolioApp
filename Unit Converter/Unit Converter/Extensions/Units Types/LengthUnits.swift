//
//  LengthUnits.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/12/20.
//

import Foundation
import CoreData

/// Defines attributes for Length conversions
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

   static let sampleMeasurement = Measurement(value: Double.pi, unit: UnitLength.meters)

   static func sampleConversion(context: NSManagedObjectContext? = nil) -> Conversion {
      let resultUnit = UnitLength.millimeters
      let result = sampleMeasurement.converted(to: resultUnit)
      return Conversion(type: ConversionType.length,
                        date: Date(),
                        inputUnit: sampleMeasurement.unit.symbol,
                        inputValue: sampleMeasurement.value,
                        resultUnit: result.unit.symbol,
                        resultValue: result.value,
                        context: context)
   }
}
