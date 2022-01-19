//
//  AngleUnits.swift
//  Unit Converter
//
//  Created by James LaGrone on 1/19/22.
//

import Foundation
import CoreData

struct AngleUnits: UnitProtocol {
    #warning("This needs something different")
    static var imageName: String { "location" }

    static var all: [Dimension] {
        [UnitAngle.degrees,
         UnitAngle.radians,
         UnitAngle.gradians,
         UnitAngle.revolutions,
         UnitAngle.arcMinutes,
         UnitAngle.arcSeconds
        ]
    }

    static let sampleMeasurement = Measurement(value: 90, unit: UnitAngle.degrees)

    static func sampleConversion(context: NSManagedObjectContext? = nil) -> Conversion {
        let resultUnit = UnitAngle.radians
        let result = sampleMeasurement.converted(to: resultUnit)
        return Conversion(type: .angle,
                          date: Date(),
                          inputUnit: sampleMeasurement.unit.symbol,
                          inputValue: sampleMeasurement.value,
                          resultUnit: result.unit.symbol,
                          resultValue: result.value,
                          context: context)
    }
}
