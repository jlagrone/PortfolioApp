//
//  TemperatureUnits.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/14/20.
//

import Foundation
import CoreData

/// Defines attributes for Temperature conversions
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

   static let sampleMeasurement = Measurement(value: 32.0, unit: UnitTemperature.fahrenheit)

   static func sampleConversion(context: NSManagedObjectContext) -> Conversion {
      let resultUnit = UnitTemperature.celsius
      let result = sampleMeasurement.converted(to: resultUnit)
      return Conversion(type: ConversionType.temperature,
                        date: Date(),
                        inputUnit: sampleMeasurement.unit.symbol,
                        inputValue: sampleMeasurement.value,
                        resultUnit: result.unit.symbol,
                        resultValue: result.value,
                        context: context)
   }
}
