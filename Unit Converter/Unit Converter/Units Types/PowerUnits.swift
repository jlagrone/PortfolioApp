//
//  PowerUnits.swift
//  Unit Converter
//
//  Created by James LaGrone on 1/19/22.
//

import Foundation
import CoreData

struct PowerUnits: UnitProtocol {
    static var imageName: String { "powerplug" }

    static var all: [Dimension] {
        [UnitPower.horsepower,
         UnitPower.watts,
         UnitPower.kilowatts,
         UnitPower.megawatts,
         UnitPower.gigawatts,
         UnitPower.terawatts,
         UnitPower.milliwatts,
         UnitPower.microwatts,
         UnitPower.nanowatts,
         UnitPower.picowatts,
         UnitPower.femtowatts ]
    }

    static let sampleMeasurement = Measurement(value: 120,
                                               unit: UnitPower.horsepower)

    static func sampleConversion(context: NSManagedObjectContext) -> Conversion {
        let resultUnit = UnitPower.megawatts
        let result = sampleMeasurement.converted(to: resultUnit)
        return Conversion(type: .power,
                          date: Date(),
                          inputUnit: sampleMeasurement.unit.symbol,
                          inputValue: sampleMeasurement.value,
                          resultUnit: result.unit.symbol,
                          resultValue: result.value,
                          context: context)
    }
}
