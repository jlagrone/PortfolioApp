//
//  ConversionItem.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/12/20.
//

import Foundation
import CoreData

/// Designate number of decimal places or significant digits
enum OutputFormat: Int, CaseIterable, Identifiable {
    case decimalPlaces = 0
    case significantDigits

    static var strings: [String] {
        ["Decimal digits", "Significant Digits"]
    }

    static var range = 0..<Int(strings.count)

    var id: Int { self.rawValue }
}

struct ConversionItem {

    var conversionType: ConversionType

    var originalValueString: String = ""
    var originalValue: Double { Double(originalValueString) ?? 0.0 }
    var fromUnit: Dimension = UnitLength.feet
    var toUnit: Dimension = UnitLength.meters
    var fractionPrecision: Double = SettingsDefaults().fractionPrecision
    var significantDigits: Double = SettingsDefaults().significantDigits
    var imageName: String = ""
    var notes: String = ""

    var format: OutputFormat = SettingsDefaults().outputFormat
    var useScientificNotation: Bool = SettingsDefaults().useScientificNotation

    var pickerUnits: [Dimension]

    var newValueString: String {
        let oldValue = Measurement(value: Double(originalValueString) ?? 0, unit: fromUnit)
        let newValue = oldValue.converted(to: toUnit)
        let numberformatter = NumberFormatter()
        numberformatter.roundingMode = .halfUp

        switch format {
            case .decimalPlaces:
                numberformatter.maximumFractionDigits = Int(fractionPrecision)
            case .significantDigits:
                numberformatter.usesSignificantDigits = true
                numberformatter.maximumSignificantDigits = Int(significantDigits)
        }

        if useScientificNotation { numberformatter.numberStyle = .scientific }

        /* Bug reported: FB9708766
        let formatter = MeasurementFormatter()
        formatter.numberFormatter = numberformatter
        formatter.unitOptions = .providedUnit
        formatter.unitStyle = .long
         */
        let valueString = numberformatter.string(from: newValue.value as NSNumber) ?? ""
        return "\(valueString)"
    }
    var newValue: Double { Double(newValueString) ?? 0.0 }

    static func imageName(for type: ConversionType) -> String {
        switch type {
            case .length: return LengthUnits.imageName
            case .volume: return VolumeUnits.imageName
            case .temperature: return TemperatureUnits.imageName
            case .weight: return MassUnits.imageName
            case .pressure: return PressureUnits.imageName
        }
    }

    init(conversionType: ConversionType, fromUnit: String? = nil, toUnit: String? = nil) {

        self.conversionType = conversionType

        /** most of this is a hack/work around the bug with Dimension/Unit
             FB9708766 filed
         */
        switch conversionType {  // it would be nice to refactor this to a method, but Xcode complains

            case .length:

                if let fromUnit = fromUnit {
                    self.fromUnit = UnitLength(symbol: fromUnit)
                } else {
                    self.fromUnit = UnitLength.feet
                }

                if let toUnit = toUnit {
                    self.toUnit = UnitLength(symbol: toUnit)
                } else {
                    self.toUnit = UnitLength.meters
                }

                self.pickerUnits = LengthUnits.all
                self.imageName = LengthUnits.imageName

            case .volume:

                if let fromUnit = fromUnit {
                    self.fromUnit = UnitVolume(symbol: fromUnit)
                } else {
                    self.fromUnit = UnitVolume.gallons
                }

                if let toUnit = toUnit {
                    self.toUnit = UnitVolume(symbol: toUnit)
                } else {
                    self.toUnit = UnitVolume.liters
                }

                self.pickerUnits = VolumeUnits.all
                self.imageName = VolumeUnits.imageName

            case .temperature:

                if let fromUnit = fromUnit {
                    self.fromUnit = UnitTemperature(symbol: fromUnit)
                } else {
                    self.fromUnit = UnitTemperature.fahrenheit
                }

                if let toUnit = toUnit {
                    self.toUnit = UnitTemperature(symbol: toUnit)
                } else {
                    self.toUnit = UnitTemperature.celsius
                }
                self.pickerUnits = TemperatureUnits.all
                self.imageName = TemperatureUnits.imageName

            case .weight:

                if let fromUnit = fromUnit {
                    self.fromUnit = UnitMass(symbol: fromUnit)
                } else {
                    self.fromUnit = UnitMass.pounds
                }

                if let toUnit = toUnit {
                    self.toUnit = UnitMass(symbol: toUnit)
                } else {
                    self.toUnit = UnitMass.kilograms
                }
                self.pickerUnits = MassUnits.all
                self.imageName = MassUnits.imageName

            case .pressure:

                if let fromUnit = fromUnit {
                    self.fromUnit = UnitPressure(symbol: fromUnit)
                } else {
                    self.fromUnit = UnitPressure.inchesOfMercury
                }

                if let toUnit = toUnit {
                    self.toUnit = UnitPressure(symbol: toUnit)
                } else {
                    self.toUnit = UnitPressure.millibars
                }
                self.pickerUnits = PressureUnits.all
                self.imageName = PressureUnits.imageName
        }

    }

    init(value: String, fromUnit: String? = nil, toUnit: String? = nil, conversionType: ConversionType) {
        self.init(conversionType: conversionType, fromUnit: fromUnit, toUnit: toUnit)
        originalValueString = value
    }

    init(conversion: Conversion) {
        let inputValueString = String(format: "%f", conversion.inputValue)
//        let resultValueString = String(format: "%f", conversion.resultValue)
        self.init(value: inputValueString,
                  fromUnit: conversion.inputUnit,
                  toUnit: conversion.resultUnit,
                  conversionType: conversion.conversionType)
    }

    /// Create a Conversion object for CoreData
    /// - Parameter viewContext: <#viewContext description#>
    /// - Returns: <#description#>
    func makeCoreData(for viewContext: NSManagedObjectContext) -> Conversion {
        let conversion = Conversion(context: viewContext)
        conversion.date = Date()
        conversion.type = self.conversionType.int16Value
        conversion.inputValue = self.originalValue
        conversion.inputUnit = self.fromUnit.symbol
        conversion.resultValue = self.newValue
        conversion.resultUnit = self.toUnit.symbol
        conversion.notes = self.notes
        return conversion
    }

//    func make(from item: Conversion) -> ConversionItem {
//        guard let type =  ConversionType(rawValue: Int(item.type)) else {
//            fatalError("Can't get conversion type from CoreData object.")
////            return
//        }
//        var conversionItem = ConversionItem(conversionType: type)
//        conversionItem.originalValueString = String(item.inputValue)
////        conversionItem.newValue = item.resultValue
//        conversionItem.fromUnits = item.inputUnit as! Dimension
//        conversionItem.toUnits = item.resultUnit as! Dimension
//        conversionItem.notes = item.notes ?? ""
//        return
//    }
}
