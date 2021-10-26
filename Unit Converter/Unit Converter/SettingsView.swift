//
//  SettingsView.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/15/20.
//

import SwiftUI

struct SettingsView: View {

    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var userSettings = SettingsDefaults()

    private var sampleNumber = 123456.7890123
    
    private var sampleValue: String {

        let fractionPrecision = userSettings.fractionPrecision
        let significantDigits = userSettings.significantDigits
        let format = userSettings.outputFormat

        let numberformatter = NumberFormatter()
        numberformatter.roundingMode = .halfUp

        switch format {
            case .decimalPlaces:
                numberformatter.maximumFractionDigits = Int(fractionPrecision)
            case .significantDigits:
                numberformatter.usesSignificantDigits = true
                numberformatter.maximumSignificantDigits = Int(significantDigits)
        }

        if userSettings.useScientificNotation { numberformatter.numberStyle = .scientific }

        let valueString = numberformatter.string(from: sampleNumber as NSNumber) ?? ""

        return "\(valueString)"
    }

    var formatResultView: some View {
        Group {
            Picker("Result Format", selection: $userSettings.outputFormat) {
                Text("Decimal Places").tag(OutputFormat.decimalPlaces)
                Text("Significant Digits").tag(OutputFormat.significantDigits)
            }
            .pickerStyle(SegmentedPickerStyle())

            FormatView(format: $userSettings.outputFormat,
                       significantDigits: $userSettings.significantDigits,
                       fractionPrecision: $userSettings.fractionPrecision)
        }
    }

    var body: some View {
        NavigationView {
            Form {

                Section(header: Text("Sample Value")) {
                    Text(sampleValue)
                        .accessibilityLabel("\(Double(sampleValue)!, specifier: "%f")")
                }

                /// Decimal or Significant Digits
                Section(header: Text("Format Result")) {
                    formatResultView
                }

                Section(header: Text("Notation")) {
                    Toggle("Scientific Notation", isOn: $userSettings.useScientificNotation)
                        .accessibilityLabel("\(userSettings.useScientificNotation ? "On" : "Off")")
                }
            }
            .navigationBarTitle("Settings")
            .accessibilityHint("Set preferences for using Significant Digits or Scientific Notation")
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            } ) {
                Text("Done")
            } )
        }.accentColor(.red)
        Spacer()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
