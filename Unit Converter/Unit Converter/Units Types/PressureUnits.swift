//
//  PressureUnits.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/14/20.
//

import Foundation
import CoreData
import SwiftUI

/// Defines attributes for Pressure conversions
struct PressureUnits: UnitProtocol {

    static var imageName: String { "barometer" }
    static let metric: [UnitPressure] = [.newtonsPerMetersSquared, .gigapascals,
                                         .megapascals, .kilopascals,
                                         .hectopascals, .bars, .millibars,
                                         .millimetersOfMercury]

    static let imperial: [UnitPressure] = [.inchesOfMercury, .poundsForcePerSquareInch]

    static let other: [UnitPressure] = []

    static var all: [Dimension] {
        if usesImperial {
            return imperial + metric + other
        } else {
            return metric + imperial + other
        }
    }

   static let sampleMeasurement = Measurement(value: Double.pi, unit: UnitPressure.bars)

   static func sampleConversion(context: NSManagedObjectContext? = nil) -> Conversion {
      let resultUnit = UnitPressure.millibars
      let result = sampleMeasurement.converted(to: resultUnit)
      return Conversion(type: ConversionType.pressure,
                        date: Date(),
                        inputUnit: sampleMeasurement.unit.symbol,
                        inputValue: sampleMeasurement.value,
                        resultUnit: result.unit.symbol,
                        resultValue: result.value,
                        context: context)
   }
}
