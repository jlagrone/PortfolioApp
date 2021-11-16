//
//  MassUnits.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/14/20.
//

import Foundation
import CoreData

/// Defines attributes for Mass (Weight) conversions
struct MassUnits: UnitProtocol {

    static var imageName: String { "scalemass" }

    static let metric: [UnitMass] = [.kilograms, .grams, .decigrams, .centigrams, .milligrams,
                                     .micrograms, .nanograms, .picograms, .metricTons]

    static let imperial: [UnitMass] = [.ounces, .pounds, .stones, .slugs, .shortTons]

    static let other: [UnitMass] = [.carats, .ouncesTroy]

    static var all: [Dimension] {
        if usesImperial {
            return imperial + metric + other
        } else {
            return metric + imperial + other
        }

    }

   static let sampleMeasurement = Measurement(value: Double.pi, unit: UnitMass.grams)

   static func sampleConversion(context: NSManagedObjectContext? = nil) -> Conversion {
      let resultUnit = UnitMass.milligrams
      let result = sampleMeasurement.converted(to: resultUnit)
      return Conversion(type: ConversionType.mass,
                        date: Date(),
                        inputUnit: sampleMeasurement.unit.symbol,
                        inputValue: sampleMeasurement.value,
                        resultUnit: result.unit.symbol,
                        resultValue: result.value,
                        context: context)
   }
}
