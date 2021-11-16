//
//  UnitProtocol.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/15/20.
//

import Foundation

/// Abstraction for reusing the *?Units* conversions
protocol UnitProtocol {

   static var imageName: String { get }
   static var all: [Dimension] { get }
}

extension UnitProtocol {

    /// United States, Belize, and Myanmar (Burma) are still not on metric
    static var usesImperial: Bool {
        return ["US", "BZ", "MM"].contains(Locale.current.regionCode)
    }

   static func dimension(of symbol: String) -> Dimension? {
      for unit in all where unit.symbol == symbol {
         return unit
      }
      return nil
   }
}

struct UnitProtocolHelper {
   static func dimension(of symbol: String) -> Dimension? {
      if let dimension = LengthUnits.dimension(of: symbol) {
         return dimension
      }

      if let dimension = MassUnits.dimension(of: symbol) {
         return dimension
      }

      if let dimension = PressureUnits.dimension(of: symbol) {
         return dimension
      }

      if let dimension = TemperatureUnits.dimension(of: symbol) {
         return dimension
      }

      if let dimension = VolumeUnits.dimension(of: symbol) {
         return dimension
      }

      return nil
   }
}
