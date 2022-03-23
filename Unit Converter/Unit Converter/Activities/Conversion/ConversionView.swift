//
//  ConversionView.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/12/20.
//

import SwiftUI
import os

/// Allows user to enter a value and unit to convert to another unit.
///
/// Defaults to converting Length from `feet` to `meters`.
struct ConversionView: View {
   @EnvironmentObject var dataController: DataController
   @State private var inputValue: String = ""
   @State private var fromUnit: Dimension = UnitLength.feet
   @State private var toUnit: Dimension = UnitLength.meters
   @State private var format: OutputFormat = SettingsDefaults().outputFormat
   @State private var fractionPrecision: Double = SettingsDefaults().fractionPrecision
   @State private var significantDigits: Double = SettingsDefaults().significantDigits
   @State private var useScientificNotation: Bool = SettingsDefaults().useScientificNotation

   /// The result of conversion in the form of a Measurement
   private var resultMeasurement: Measurement<Dimension> {
      let oldValue = Measurement(value: Double(inputValue) ?? 0, unit: fromUnit)
      return oldValue.converted(to: toUnit)
   }

   /// Compute the conversion of `inputValue` from `fromUnit` to `toUnit`
   private var resultValue: String {
      let oldValue = Measurement(value: Double(inputValue) ?? 0, unit: fromUnit)
      let newValue = oldValue.converted(to: toUnit)

      let numberFormatter = NumberFormatter()
      numberFormatter.roundingMode = .halfUp

      switch format {
         case .decimalPlaces:
            numberFormatter.maximumFractionDigits = Int(fractionPrecision)
         case .significantDigits:
            numberFormatter.usesSignificantDigits = true
            numberFormatter.maximumSignificantDigits = Int(significantDigits)
      }

      if useScientificNotation { numberFormatter.numberStyle = .scientific }

      let formatter = MeasurementFormatter()
      formatter.numberFormatter = numberFormatter
      formatter.unitOptions = .providedUnit
      formatter.unitStyle = .long

      return formatter.string(from: newValue)

   }

   /// Stringified ConversionType for Navigation Title
   private var navtitle: String { self.conversionType.string }

   /// Types are length, temperature, volume, weight/mass, pressure
   ///     This makes the default length.
   var conversionType: ConversionType = .length

   // MARK: - Initializers
   /// Initializer for existing (previous) conversion, presumably for showing from history
   /// - Parameters:
   ///   - item: a `Conversion` (possibly from HistoryView)
   ///   - type: length, temperature, weight/mass, pressure, or volume
   init(item: Conversion, type: ConversionType) {
      self.conversionType = type
      _inputValue = State(wrappedValue: item.conversionInputValueString)
      _fromUnit = State(wrappedValue: item.conversionInputUnit)
      _toUnit = State(wrappedValue: item.conversionResultUnit)
   }

   /// Initializer for new conversion
   /// - Parameter type: length, temperature, weight/mass, pressure, or volume
   init(type: ConversionType) {
      self.conversionType = type
      _fromUnit = State(wrappedValue: defaultFromUnit)
      _toUnit = State(wrappedValue: defaultToUnit)
   }

   // MARK: - Views
   var body: some View {
      Form {
         // Section for original value and units
         convertFromSection

         // Section for new value and units
         convertToSection

         // Section for choosing using decimal places or significant digits
         formatResultSection

         // Section for toggling scientific notation
         notationSection

      }
      .onTapGesture(perform: {
         self.hideKeyboard()
      })
      .toolbar {
         ToolbarItemGroup(placement: .navigationBarTrailing) {
            saveButton
            keyboardButton
         }
      }
      .navigationTitle(navtitle)
      .navigationBarTitleDisplayMode(.automatic)

   }

   // Section 1 - User input value and unit
   private var convertFromSection: some View {
      Section(header: Text("Convert").textCase(.uppercase) ) {
         HStack {
            TextField("Value", text: $inputValue)
               .keyboardType(.decimalPad)
            Picker("\(fromUnit.symbol)", selection: $fromUnit) {
               ForEach(pickerUnits, id: \.self) { unit in
                  Text("\(unit.symbol)")
               }
            }
            .id(fromUnit)
            .labelsHidden()
            .pickerStyle(MenuPickerStyle())
            .accessibilityLabel("\(fromUnit.symbol)")
         }.padding()
      }
   }

   // Section 2 - Converted value and unit
   private var convertToSection: some View {
      Section(header: Text("To").textCase(.uppercase) ) {
         HStack {
            Text(resultValue)
            Spacer()
            Picker("\(toUnit.symbol.description)", selection: $toUnit) {
               ForEach(pickerUnits, id: \.self) { unit in
                  Text("\(unit.symbol)")
               }
            }
            .id(toUnit)
            .labelsHidden()
            .pickerStyle(MenuPickerStyle())

         }
         .padding()
         .accessibilityElement(children: .ignore)
         .accessibilityLabel("\(resultMeasurement.description)")
      }
   }

   // Section 3 - User selects format of result shown in Section 2
   private var formatResultSection: some View {
      // Candidate for refactoring since portions of this are repeated in SettingsView
      Section(header: Text("Format Result")) {

         Picker("Result Format", selection: $format) {
            Text("Decimal Places").tag(OutputFormat.decimalPlaces)
            Text("Significant Digits").tag(OutputFormat.significantDigits)
         }
         .onChange(of: format) { _ in
            self.hideKeyboard()
         }
         .pickerStyle(SegmentedPickerStyle())

         FormatView(format: $format,
                    significantDigits: $significantDigits,
                    fractionPrecision: $fractionPrecision)
      }

   }

   // Section 4 - User can toggle on/off Scientific Notation
   private var notationSection: some View {
      // Candidate for refactoring since this is repeated in ConversionView
      Section(header: Text("Notation")) {
         Toggle("Scientific Notation", isOn: $useScientificNotation).accentColor(.red)
      }
   }

   /// Button for dismissing the keyboard
   ///
   /// Keyboard is also dismissed by user touching outside of TextField
   private var keyboardButton: some View {
      Button(action: self.hideKeyboard) {
         Image(systemName: "keyboard")
      }
      .accessibilityLabel("Hide keyboard.")
   }

   /// Button to save to History
   private var saveButton: some View {
      Button(action: self.save) {
         Text("Save")
      }
      .accessibilityLabel("Save to History.")
   }
   // MARK: - Other properties

   /// The unit  being converting `from` in this type of conversion
   var defaultFromUnit: Dimension {
      switch conversionType {
         case .length: return UnitLength.feet
         case .volume: return UnitVolume.gallons
         case .temperature: return UnitTemperature.fahrenheit
         case .mass: return UnitMass.pounds
         case .pressure: return UnitPressure.inchesOfMercury
         case .energy: return UnitEnergy.joules
         case .power: return UnitPower.horsepower
         case .angle: return UnitAngle.degrees
         case .speed: return UnitSpeed.kilometersPerHour
         case .electricCharge: return UnitElectricCharge.coulombs
      }
   }

   /// The unit  being converted `to` in this type of conversion
   var defaultToUnit: Dimension {
      switch conversionType {
         case .length: return UnitLength.meters
         case .volume: return UnitVolume.liters
         case .temperature: return UnitTemperature.celsius
         case .mass: return UnitMass.kilograms
         case .pressure: return UnitPressure.millibars
         case .energy: return UnitEnergy.kilowattHours
         case .power: return UnitPower.kilowatts
         case .angle: return UnitAngle.radians
         case .speed: return UnitSpeed.milesPerHour
         case .electricCharge: return UnitElectricCharge.milliampereHours
      }
   }

   /// The array of units to be supplied to the Picker
   var pickerUnits: [Dimension] {
      switch conversionType {
         case .length: return LengthUnits.all
         case .volume: return VolumeUnits.all
         case .temperature: return TemperatureUnits.all
         case .mass: return MassUnits.all
         case .pressure: return PressureUnits.all
         case .energy: return EnergyUnits.all
         case .power: return PowerUnits.all
         case .angle: return AngleUnits.all
         case .speed: return SpeedUnits.all
         case .electricCharge: return ElectricChargeUnits.all
      }
   }

   // MARK: - Other Methods

   /// Saves the conversion to the history
   private func save() {
      // user didn't enter value into TextField, nothing to save
      if inputValue.isEmpty { return }

      let viewContext = dataController.container.viewContext
      let conversion = Conversion(context: viewContext)
      conversion.date = Date()
      conversion.type = self.conversionType.int16Value
      conversion.inputValue = Double(self.inputValue) ?? 0.0
      conversion.inputUnit = self.fromUnit.symbol
      conversion.resultValue = Double(self.resultValue) ?? 0.0
      conversion.resultUnit = self.toUnit.symbol
      conversion.notes = "self.notes"

      do {
         try viewContext.save()
      } catch let error {
         os_log("Can't save item data: %@", log: log_general,
                type: .error, error.localizedDescription)
      }
      dataController.save()
   }
}

#if canImport(UIKit)
extension View {
   func hideKeyboard() {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
   }
}
#endif

struct ConversionView_Previews: PreviewProvider {
   static var previews: some View {
      Group {
         ConversionView(type: .length)
         ConversionView(type: .volume)
      }
   }
}
