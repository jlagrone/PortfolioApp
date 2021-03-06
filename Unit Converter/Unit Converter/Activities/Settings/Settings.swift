//
//  Settings.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/16/20.
//

import Foundation
import os

// swiftlint:disable private_over_fileprivate
// Prefix for all UserDefaults' keys
fileprivate let prefix = "com.manna-software.unitconverter-"

/// Control all access to the UserDefaults here.
final class SettingsDefaults: ObservableObject {

   // KEYS
   private let outputFormatKey: String = prefix + "OutputFormat"
   private let scientificNotationKey: String = prefix + "Notation"
   private let significantDigitsKey: String = prefix + "SignificantDigits"
   private let fractionPrecisionKey: String = prefix + "FractionPrecision"
   private let homeViewKey: String = prefix + "HomeView"

   @Published var refresh: Bool {
      didSet {
         os_log("Refresh", log: log_settings, type: .info)
      }
   }

   // Defaults under control by user
   @Published var useScientificNotation: Bool {
      didSet {
         UserDefaults.standard.setValue(useScientificNotation, forKey: scientificNotationKey)
         os_log("Use Scientific Notation set to '%@'", log: log_settings, type: .info, String(useScientificNotation))
      }
   }

   /// Use decimal places or significant digits
   @Published var outputFormat: OutputFormat {
      didSet {
         UserDefaults.standard.setValue(outputFormat.rawValue, forKey: outputFormatKey)
         os_log("Output Format set to '%@'", log: log_settings, type: .info, outputFormat.string)
      }
   }

   /// Number of significant digits
   @Published var significantDigits: Double {
      didSet {
         UserDefaults.standard.setValue(significantDigits, forKey: significantDigitsKey)
         os_log("Significant Digits set to '%.0f'", log: log_settings, type: .info, significantDigits)
      }
   }

   /// Number of digits after decimal place
   @Published var fractionPrecision: Double {
      didSet {
         UserDefaults.standard.setValue(fractionPrecision, forKey: fractionPrecisionKey)
         os_log("Fraction Precision set to '%.0f'", log: log_settings, type: .info, fractionPrecision)
      }
   }

   @Published var homeViewType: HomeViewType {
      didSet {
         UserDefaults.standard.setValue(homeViewType.rawValue, forKey: homeViewKey)
         os_log("Home View Type set to '%@'", log: log_settings, type: .info, homeViewType.string)
      }
   }

   init() {
      UserDefaults.standard.register(defaults: [
         outputFormatKey: OutputFormat.decimalPlaces.rawValue,
         scientificNotationKey: false,
         significantDigitsKey: 3.0,
         fractionPrecisionKey: 3.0,
         homeViewKey: HomeViewType.grid.rawValue
      ])

      self.useScientificNotation = UserDefaults.standard.bool(forKey: scientificNotationKey)

      let outputFormatRawValue = UserDefaults.standard.integer(forKey: outputFormatKey)
      self.outputFormat = OutputFormat(rawValue: outputFormatRawValue) ?? .decimalPlaces

      self.fractionPrecision = UserDefaults.standard.double(forKey: fractionPrecisionKey)
      self.significantDigits = UserDefaults.standard.double(forKey: significantDigitsKey)

      let homeViewtypeRawValue = UserDefaults.standard.string(forKey: homeViewKey)
      self.homeViewType = HomeViewType(rawValue: homeViewtypeRawValue ?? "List") ?? .list

      self.refresh = false
   }

   convenience init(with homeView: HomeViewType) {
      self.init()
      self.homeViewType = homeView
   }

}

enum OutputFormat: Int, CaseIterable, Identifiable {
   case decimalPlaces = 0
   case significantDigits

   static var strings: [String] {
      ["Decimal digits", "Significant Digits"]
   }

   static var range = 0..<Int(strings.count)

   var string: String {
      Self.strings[self.rawValue]
   }
   var id: Int { self.rawValue }
}

enum HomeViewType: String, CaseIterable, Identifiable {
   case list, grid

   var string: String {
      String(describing: self.rawValue).capitalized
   }

   var id: Int {self.hashValue}
}
