//
//  ConversionType.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/14/21.
//

import Foundation

enum ConversionType: CaseIterable {
    case length
    case volume
    case temperature
    case weight
    case pressure

    var string: String {
        switch self {
            case .weight:  return "Weight (Mass)"
            case .length:  return "Length (Distance)"
            default:       return "\(self)".capitalized
        }
    }
}
