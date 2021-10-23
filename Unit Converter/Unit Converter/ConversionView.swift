//
//  ConversionView.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/12/20.
//

import SwiftUI

struct ConversionView: View {
    @EnvironmentObject var dataController: DataController
    @State private var inputValue: String = ""
    @State private var fromUnit: Dimension = UnitLength.feet
//    @State private var resultValue: String
    @State private var toUnit: Dimension = UnitLength.meters
    @State private var format: OutputFormat = SettingsDefaults().outputFormat
    @State private var fractionPrecision: Double = SettingsDefaults().fractionPrecision
    @State private var significantDigits: Double = SettingsDefaults().significantDigits
    @State private var useScientificNotation: Bool = SettingsDefaults().useScientificNotation


    /// Compute the conversion of `inputValue` from `fromUnit` to `toUnit`
    private var resultValue: String {
        let oldValue = Measurement(value: Double(inputValue) ?? 0, unit: fromUnit)
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

    /// Types are length, temperature, volume, weight/mass, pressure
    ///     This makes the default length.
    var conversionType: ConversionType = .length

    // MARK: - Initializers
    /// Initializer for existing (previous) conversion
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

    var navtitle: String { self.conversionType.string }

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
//            ToolbarItemGroup(placement: .navigationBarTrailing) {
                keyBoardButton
//            }
        }
        .navigationTitle(navtitle)
        .onDisappear(perform: save)
        .navigationBarTitleDisplayMode(.automatic)

    }

    private var convertFromSection: some View {
        Section(header: Text("Convert").textCase(.uppercase) ) {
            HStack {
                TextField("Value", text: $inputValue)
                    .keyboardType(.decimalPad)
                Picker("\(fromUnit.symbol)", selection: $fromUnit){
                    ForEach(pickerUnits, id: \.self) { unit in
                        Text("\(unit.symbol)")
                    }
                }
                .id(fromUnit)
                .labelsHidden()
                .pickerStyle(MenuPickerStyle())
            }.padding()
        }
    }

    private var convertToSection: some View {
        Section(header: Text("To").textCase(.uppercase) ) {
            HStack{
                Text(resultValue)
                Spacer()
                Picker("\(toUnit.symbol.description)", selection: $toUnit){
                    ForEach(pickerUnits, id: \.self) { unit in
                        Text("\(unit.symbol)")
                    }
                }
                .id(toUnit)
                .labelsHidden()
                .pickerStyle(MenuPickerStyle())

            }.padding()
        }
    }

    private var formatResultSection: some View {
        Section(header: Text("Format Result")) {

            Picker("Result Format", selection: $format) {
                Text("Decimal Places").tag(OutputFormat.decimalPlaces)
                Text("Significant Digits").tag(OutputFormat.significantDigits)
            }
            .onChange(of: format) { value in
                self.hideKeyboard()
            }
            .pickerStyle(SegmentedPickerStyle())

            FormatView(format: $format,
                       significantDigits: $significantDigits,
                       fractionPrecision: $fractionPrecision)
        }

    }

    private var notationSection: some View {
        Section(header: Text("Notation")) {
            Toggle("Scientific Notation", isOn: $useScientificNotation).accentColor(.red)
        }
    }

    private var keyBoardButton: some View {
        Button(action: self.hideKeyboard) {
            Image(systemName: "keyboard")
        }
    }

    // MARK: - Other properties

    private var defaultFromUnit: Dimension {
        switch conversionType {
            case .length: return UnitLength.feet
            case .volume: return UnitVolume.gallons
            case .temperature: return UnitTemperature.fahrenheit
            case .mass: return UnitMass.pounds
            case .pressure: return UnitPressure.inchesOfMercury
        }
    }

    private var defaultToUnit: Dimension {
        switch conversionType {
            case .length: return UnitLength.meters
            case .volume: return UnitVolume.liters
            case .temperature: return UnitTemperature.celsius
            case .mass: return UnitMass.kilograms
            case .pressure: return UnitPressure.millibars
        }
    }

    private var pickerUnits: [Dimension] {
        switch conversionType {
            case .length: return LengthUnits.all
            case .volume: return VolumeUnits.all
            case .temperature: return TemperatureUnits.all
            case .mass: return MassUnits.all
            case .pressure: return PressureUnits.all
        }
    }

    // MARK: - Other Methods

    /// Save this conversion to the history
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
            print("Can't save item data: ", error.localizedDescription)
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
            ConversionView(type:  .length)
            ConversionView(type:  .volume)
        }
    }
}
