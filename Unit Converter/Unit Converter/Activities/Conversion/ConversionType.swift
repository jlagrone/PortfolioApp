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
enum ConversionType: Int, CaseIterable, Identifiable {

    case length
    case temperature
    case volume
    case mass
    case pressure
    case energy
    case power
    case angle

   /// The `String` value associated with the conversion type
    var string: String {
        var string = ""
        switch self {
            case .mass: string = "Weight (Mass)"
            case .length: string = "Length (Distance)"
            case .temperature: string = "Temperature"
            case .volume: string = "Volume"
            case .pressure: string = "Pressure"
            case .energy: string = "Energy"
            case .power: string = "Power"
            case .angle: string = "Angle"
        }
        return NSLocalizedString(string, comment: "ConversionType to string")

    }

    /// Converted rawValue Core Data interoperability
    var int16Value: Int16 {
        return Int16(self.rawValue)
    }

   var id: Int {
      self.rawValue
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
            case .energy: return EnergyUnits.imageName
            case .power: return PowerUnits.imageName
            case .angle: return AngleUnits.imageName
        }
    }
}

extension ConversionType: Comparable {
    static func < (lhs: ConversionType, rhs: ConversionType) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
