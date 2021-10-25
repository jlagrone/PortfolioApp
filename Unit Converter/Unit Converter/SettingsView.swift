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

    private var sampleValue: String {

        let fractionPrecision = userSettings.fractionPrecision
        let significantDigits = userSettings.significantDigits
        let format = userSettings.outputFormat

        let number = 123456.7890123

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

        let valueString = numberformatter.string(from: number as NSNumber) ?? ""

        return "\(valueString)"
    }

    var body: some View {
        NavigationView {
            Form {

                Section(header: Text("Sample Value")) {
                    Text(sampleValue)
                }

                /// Decimal or Significant Digits
                Section(header: Text("Format Result")) {

                    Picker("Result Format", selection: $userSettings.outputFormat) {
                        Text("Decimal Places").tag(OutputFormat.decimalPlaces)
                        Text("Significant Digits").tag(OutputFormat.significantDigits)
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    FormatView(format: $userSettings.outputFormat,
                               significantDigits: $userSettings.significantDigits,
                               fractionPrecision: $userSettings.fractionPrecision)
                }

                Section(header: Text("Notation")) {
                    Toggle("Scientific Notation", isOn: $userSettings.useScientificNotation)
                }
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing:             Button(action: {
                presentationMode.wrappedValue.dismiss()
            } ) {
                Image(systemName: "Control")
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
