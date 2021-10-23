//
//  ConversionType.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/14/21.
//

import Foundation
import SwiftUI

enum ConversionType: Int, CaseIterable, Comparable {

    case length
    case temperature
    case volume
    case mass
    case pressure

    var string: String {
        switch self {
            case .mass:
                return NSLocalizedString("Weight (Mass)",
                                         comment: "ConversionType to string")
            case .length:
                return NSLocalizedString("Length (Distance)",
                                         comment: "ConversionType to string")
            case .temperature:
                return NSLocalizedString("Temperature",
                                         comment: "ConversionType to string")
            case .volume:
                return NSLocalizedString("Volume",
                                         comment: "ConversionType to string")
            case .pressure:
                return NSLocalizedString("Pressure",
                                         comment: "ConversionType to string")
        }
    }

    /// For Core Data interoperability
    var int16Value: Int16 {
        return Int16(self.rawValue)
    }

    // This tightly couples this enum with associated structs.
    var imageName: String {
        switch self {
            case .length: return LengthUnits.imageName
            case .volume: return VolumeUnits.imageName
            case .temperature: return TemperatureUnits.imageName
            case .mass: return MassUnits.imageName
            case .pressure: return PressureUnits.imageName
        }
    }

}

extension ConversionType {
    static func < (lhs: ConversionType, rhs: ConversionType) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
