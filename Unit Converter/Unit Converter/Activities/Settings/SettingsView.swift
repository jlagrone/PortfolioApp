//
//  SettingsView.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/15/20.
//

import SwiftUI

struct SettingsView: View {

   @Environment(\.presentationMode) var presentationMode
   @EnvironmentObject var userSettings: SettingsDefaults
   //    @ObservedObject var userSettings = SettingsDefaults()

   private var sampleNumber = 123456.7890123

   /// A string of the sampleNumber formatted to current Settings for decimal/significant digits,
   /// scientific notation for user to see a preview how their Settings affect the value.
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

   /// Picker and option for Decimal or Significant digits
   var formatResultView: some View {
      // Candidate for refactoring since this is repeated in ConversionView
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

   var homeViewPickerView: some View {
      VStack(alignment: .center) {
         Picker("Arrangement", selection: $userSettings.homeViewType) {
            Text("List").tag(HomeViewType.list)
            Text("Grid").tag(HomeViewType.grid)
         }
         .pickerStyle(SegmentedPickerStyle())

         Text("Conversion Options will be shown in a \(userSettings.homeViewType.string).")
            .font(.caption)
      }
   }

   var doneButton: some View {
      Button("Done") {
         presentationMode.wrappedValue.dismiss()
      }
   }

   var body: some View {
      NavigationView {
         Form {

            Section(header: Text("Sample Value")) {
               Text(sampleValue)
                  .accessibilityLabel("\(Double(sampleValue)!, specifier: "%f")")
            }

            // Decimal or Significant Digits
            Section(header: Text("Format Result")) {
               formatResultView
            }

            Section(header: Text("Notation")) {
               // Candidate for refactoring since this is repeated in ConversionView
               Toggle("Scientific Notation", isOn: $userSettings.useScientificNotation)
                  .accessibilityLabel("\(userSettings.useScientificNotation ? "On" : "Off")")
            }

            Section(header: Text("Home View")) {
               homeViewPickerView
            }
         }
         .navigationBarTitle("Settings")
         .accessibilityHint("Set preferences for using Significant Digits or Scientific Notation")
         .navigationBarItems(trailing: doneButton)
      }.accentColor(.red)
      Spacer()
   }
}

struct SettingsView_Previews: PreviewProvider {
   static var previews: some View {
      SettingsView()
   }
}
