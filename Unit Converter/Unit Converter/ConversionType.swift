//
//  ConversionType.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/14/21.
//

import Foundation

enum ConversionType: Int, CaseIterable, Comparable {

    case length
    case temperature
    case volume
    case weight
    case pressure

    var string: String {
        switch self {
            case .weight:  return "Weight (Mass)"
            case .length:  return "Length (Distance)"
            default:       return "\(self)".capitalized
        }
    }

    /// For Core Data interoperability
    var int16Value: Int16 {
        return Int16(self.rawValue)
    }

    var name: String {
        ("\(self)" as String).capitalized
    }

    // This tightly couples this enum with associated structs.
    var imageName: String {
        switch self {
            case .length: return LengthUnits.imageName
            case .volume: return VolumeUnits.imageName
            case .temperature: return TemperatureUnits.imageName
            case .weight: return MassUnits.imageName
            case .pressure: return PressureUnits.imageName
        }
    }

}

extension ConversionType {
    static func < (lhs: ConversionType, rhs: ConversionType) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
