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

    var int16Value: Int16 {
        return Int16(self.rawValue)
    }

    var name: String {
        ("\(self)" as String).capitalized
    }
}

extension ConversionType {
    static func < (lhs: ConversionType, rhs: ConversionType) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
