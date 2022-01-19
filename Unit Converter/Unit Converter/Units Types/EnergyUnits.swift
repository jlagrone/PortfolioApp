//
//  EnergyUnits.swift
//  Unit Converter
//
//  Created by James LaGrone on 1/18/22.
//

import Foundation
import CoreData

struct EnergyUnits: UnitProtocol {

    static var imageName: String { "bolt" }

    static var all: [Dimension] {
        [UnitEnergy.kilojoules,
         UnitEnergy.joules,
         UnitEnergy.kilocalories,
         UnitEnergy.calories,
         UnitEnergy.kilowattHours]
    }

    static let sampleMeasurement = Measurement(value: 1000.0,
                                               unit: UnitEnergy.joules)

    static func sampleConversion(context: NSManagedObjectContext) -> Conversion {
        let resultUnit = UnitEnergy.kilowattHours
        let result = sampleMeasurement.converted(to: resultUnit)
        return Conversion(type: .energy,
                          date: Date(),
                          inputUnit: sampleMeasurement.unit.symbol,
                          inputValue: sampleMeasurement.value,
                          resultUnit: result.unit.symbol,
                          resultValue: result.value,
                          context: context)
    }
}
