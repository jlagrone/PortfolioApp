//
//  Settings.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/16/20.
//

import Foundation

// Prefix for all UserDefaults' keys
fileprivate let prefix = "com.manna-software.unitconverter-"

/// Control all access to the UserDefaults here.
final class SettingsDefaults: ObservableObject {

    // KEYS
    private let outputFormatKey: String = prefix + "OutputFormat"
    private let scientificNotationKey: String = prefix + "Notation"
    private let significantDigitsKey: String = prefix + "SignificantDigits"
    private let fractionPrecisionKey: String = prefix + "FractionPrecision"

    // Defaults under control by user
    @Published var useScientificNotation: Bool {
        didSet {
            UserDefaults.standard.setValue(useScientificNotation, forKey: scientificNotationKey)
            print("setting \(#function): \(useScientificNotation)")
        }
    }

    @Published var outputFormat: OutputFormat {
        didSet { UserDefaults.standard.setValue(outputFormat.rawValue, forKey: outputFormatKey)
            print("setting \(#function): \(outputFormat)")
        }
    }

    @Published var significantDigits: Double {
        didSet { UserDefaults.standard.setValue(significantDigits, forKey: significantDigitsKey)
            print("setting \(#function): \(significantDigits)") }
    }

    @Published var fractionPrecision: Double {
        didSet { UserDefaults.standard.setValue(fractionPrecision, forKey: fractionPrecisionKey)
            print("setting \(#function): \(fractionPrecision)") }
    }


    init() {
        UserDefaults.standard.register(defaults: [
            outputFormatKey : OutputFormat.decimalPlaces.rawValue,
            scientificNotationKey : false,
            significantDigitsKey : 3.0,
            fractionPrecisionKey : 3.0,
        ])

        self.useScientificNotation = UserDefaults.standard.bool(forKey: scientificNotationKey)

        let outputFormatRawValue = UserDefaults.standard.integer(forKey: outputFormatKey)
        self.outputFormat = OutputFormat(rawValue: outputFormatRawValue) ?? .decimalPlaces

        self.fractionPrecision = UserDefaults.standard.double(forKey: fractionPrecisionKey)
        self.significantDigits = UserDefaults.standard.double(forKey: significantDigitsKey)
    }

}
