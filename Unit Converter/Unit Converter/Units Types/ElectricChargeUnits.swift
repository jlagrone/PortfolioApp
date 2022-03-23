//
//  ElectricChargeUnits.swift
//  Unit Converter
//
//  Created by James LaGrone on 3/23/22.
//

import Foundation
import CoreData

struct ElectricChargeUnits: UnitProtocol {
   #warning("This needs different image")
   static var imageName: String {"battery.50"}

   static var all: [Dimension] {
      [UnitElectricCharge.coulombs,
       UnitElectricCharge.megaampereHours,
       UnitElectricCharge.kiloampereHours,
       UnitElectricCharge.ampereHours,
       UnitElectricCharge.milliampereHours,
       UnitElectricCharge.microampereHours
      ]
   }

   static let sampleMeasurement = Measurement(value: 100, unit: UnitElectricCharge.coulombs)

   static func sampleConversion(context: NSManagedObjectContext?) -> Conversion {
      let resultUnit = UnitElectricCharge.milliampereHours
      let result = sampleMeasurement.converted(to: resultUnit)
      return Conversion(type: .electricCharge,
                        date: Date(),
                        inputUnit: sampleMeasurement.unit.symbol,
                        inputValue: sampleMeasurement.value,
                        resultUnit: result.unit.symbol,
                        resultValue: result.value,
                        context: context)

   }
}
