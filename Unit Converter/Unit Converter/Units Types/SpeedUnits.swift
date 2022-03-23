//
//  SpeedUnits.swift
//  Unit Converter
//
//  Created by James LaGrone on 3/23/22.
//

import Foundation
import CoreData

struct SpeedUnits: UnitProtocol {
   static var imageName: String { "speedometer" }

   static var all: [Dimension] {
      [UnitSpeed.metersPerSecond,
       UnitSpeed.kilometersPerHour,
       UnitSpeed.milesPerHour,
       UnitSpeed.knots
       ]
   }

   static let sampleMeasurement = Measurement(value: 88, unit: UnitSpeed.kilometersPerHour)

   static func sampleConversion(context: NSManagedObjectContext?) -> Conversion {
      let resultUnit = UnitSpeed.milesPerHour
      let result = sampleMeasurement.converted(to: resultUnit)
      return Conversion(type: .speed,
                        date: Date(),
                        inputUnit: sampleMeasurement.unit.symbol,
                        inputValue: sampleMeasurement.value,
                        resultUnit: result.unit.symbol,
                        resultValue: result.value,
                        context: context)
   }
}
