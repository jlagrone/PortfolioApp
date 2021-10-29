//
//  ConversionType.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/14/21.
//

import Foundation
import SwiftUI

/// Enum representing the types of conversions available in the app with associated String values
///
/// - Precondition: The computed property `imageName` requires the presence of LengthUnits, VolumeUnits,
/// TemperatureUnits, MassUnits, and PressureUnits for their associated SF Symbols name
enum ConversionType: Int, CaseIterable {

    case length
    case temperature
    case volume
    case mass
    case pressure

   /// The `String` value associated with the conversion type
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

    /// Converted rawValue Core Data interoperability
    var int16Value: Int16 {
        return Int16(self.rawValue)
    }

   /// The SF Symbols of the conversion type
   /// - Precondition: `LengthUnits`, `VolumeUnits`,
   /// `TemperatureUnits`, `MassUnits`, and `PressureUnits` are present for their associated SF Symbols name
    var imageName: String {
       // This tightly couples this enum with associated structs.
        switch self {
            case .length: return LengthUnits.imageName
            case .volume: return VolumeUnits.imageName
            case .temperature: return TemperatureUnits.imageName
            case .mass: return MassUnits.imageName
            case .pressure: return PressureUnits.imageName
        }
    }
}

extension ConversionType: Comparable {
    static func < (lhs: ConversionType, rhs: ConversionType) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
