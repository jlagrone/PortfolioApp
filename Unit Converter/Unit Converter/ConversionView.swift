//
//  ConversionView.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/12/20.
//

import SwiftUI

struct ConversionView: View {
    @EnvironmentObject var dataController: DataController
    @State var item: ConversionItem = ConversionItem(conversionType: .length)

    var navtitle: String {
        "\(item.conversionType)".capitalized
    }
    var conversionType: ConversionType

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

            #if os(macOS)
            Spacer()
            #endif
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                saveButton
                keyBoardButton
            }
        }
        .navigationTitle(navtitle)
        .navigationBarTitleDisplayMode(.automatic)
        .onAppear(perform: {
            self.item = ConversionItem(conversionType: self.conversionType)
        })

    }

    private var convertFromSection: some View {
        Section(header: Text("Convert").textCase(.uppercase) ) {
            HStack {
                #if os(iOS)
                TextField("Value", text: $item.originalValueString)
                    .keyboardType(.decimalPad)
                #else
                TextField("Value", text: $item.value)
                #endif
                Picker("\(item.fromUnits.symbol)", selection: $item.fromUnits){
                    ForEach(item.pickerUnits, id: \.self) { unit in
                        Text("\(unit.symbol)")
                    }
                }
                .labelsHidden()
                .pickerStyle(MenuPickerStyle())
            }.padding()
        }
        .onTapGesture(perform: {
            self.hideKeyboard()
        })
    }

    private var convertToSection: some View {
        Section(header: Text("To").textCase(.uppercase) ) {
            HStack{
                Text(item.newValueString)
                Spacer()
                Picker("\(item.toUnits.symbol.description)", selection: $item.toUnits){
                    ForEach(item.pickerUnits, id: \.self) { unit in
                        Text("\(unit.symbol)")
                    }
                }
                .labelsHidden()
                .pickerStyle(MenuPickerStyle())

            }.padding()
        }
        .onTapGesture(perform: {
            self.hideKeyboard()
        })
    }

    private var formatResultSection: some View {
        Section(header: Text("Format Result")) {

            Picker("Result Format", selection: $item.format) {
                Text("Decimal Places").tag(OutputFormat.decimalPlaces)
                Text("Significant Digits").tag(OutputFormat.significantDigits)
            }
            .onChange(of: item.format) { value in
                self.hideKeyboard()
            }
            .pickerStyle(SegmentedPickerStyle())

            FormatView(format: $item.format,
                       significantDigits: $item.significantDigits,
                       fractionPrecision: $item.fractionPrecision)
        }

    }

    private var notationSection: some View {
        Section(header: Text("Notation")) {
            Toggle("Scientific Notation", isOn: $item.useScientificNotation).accentColor(.red)
        }
    }

    private var keyBoardButton: some View {
        Button(action: self.hideKeyboard) {
            Image(systemName: "keyboard")
        }
    }

    private var saveButton: some View {
        Button("Save", action: self.save)
    }


    private func save() {
        print("save")
        let viewContext = dataController.container.viewContext
        let conversion = Conversion(context: viewContext)
        conversion.type = item.conversionType.int16Value
        conversion.inputValue = item.originalValue
        conversion.resultValue = item.newValue
        conversion.inputUnit = item.fromUnits
        conversion.resultUnit = item.toUnits
        conversion.notes = item.notes
        do {
            try viewContext.save()
        } catch {
            #warning("This catch needs something less destructive")
            fatalError("Can't save item data")
        }
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
            ConversionView(conversionType:  .length)
            ConversionView(conversionType:  .volume)
        }
    }
}
