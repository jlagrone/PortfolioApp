//
//  ConversionItem.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/12/20.
//

import Foundation

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
    var fromUnits: Dimension = UnitLength.feet
    var toUnits: Dimension = UnitLength.meters
    var fractionPrecision: Double = SettingsDefaults().fractionPrecision
    var significantDigits: Double = SettingsDefaults().significantDigits
    var imageName: String = ""
    var notes: String = ""

    var format: OutputFormat = SettingsDefaults().outputFormat
    var useScientificNotation: Bool = SettingsDefaults().useScientificNotation

    var pickerUnits: [Dimension]

    var newValueString: String {
        let oldValue = Measurement(value: Double(originalValueString) ?? 0, unit: fromUnits)
        let newValue = oldValue.converted(to: toUnits)
        let formatter = MeasurementFormatter()
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

        formatter.numberFormatter = numberformatter
        formatter.unitOptions = .providedUnit
        formatter.unitStyle = .long
        return "\(formatter.string(from: newValue))"
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

    init(conversionType: ConversionType) {
        print(#function, "Type: \(conversionType)")
        self.conversionType = conversionType

        switch conversionType {
            case .length:
                self.fromUnits = UnitLength.feet
                self.toUnits = UnitLength.meters
                self.pickerUnits = LengthUnits.all
                self.imageName = LengthUnits.imageName

            case .volume:
                self.fromUnits = UnitVolume.gallons
                self.toUnits = UnitVolume.liters
                self.pickerUnits = VolumeUnits.all
                self.imageName = VolumeUnits.imageName

            case .temperature:
                self.fromUnits = UnitTemperature.fahrenheit
                self.toUnits = UnitTemperature.celsius
                self.pickerUnits = TemperatureUnits.all
                self.imageName = TemperatureUnits.imageName

            case .weight:
                self.fromUnits = UnitMass.pounds
                self.toUnits = UnitMass.kilograms
                self.pickerUnits = MassUnits.all
                self.imageName = MassUnits.imageName

            case .pressure:
                self.fromUnits = UnitPressure.inchesOfMercury
                self.toUnits = UnitPressure.millibars
                self.pickerUnits = PressureUnits.all
                self.imageName = PressureUnits.imageName
        }


    }

}
