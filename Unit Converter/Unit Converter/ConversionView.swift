//
//  ConversionView.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/12/20.
//

import SwiftUI

struct ConversionView: View {

//    @Environment(\.presentationMode) var isShowing: Binding<PresentationMode>

    var navtitle: String {
        "\(item.conversionType)".capitalized
    }

    @State var item: ConversionItem = ConversionItem(conversionType: .length)
    var conversionType: ConversionType = .length

    var body: some View {
        Form {

            Section(header: Text("Convert").textCase(.uppercase) ) {
                HStack {
                    #if os(iOS)
                    TextField("Value", text: $item.value)
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

            Section(header: Text("To").textCase(.uppercase) ) {
                HStack{
                    Text(item.newValue)
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


            // Section for choosing formatting of results
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

            Section(header: Text("Notation")) {
                Toggle("Scientific Notation", isOn: $item.useScientificNotation).accentColor(.red)
            }

            #if os(macOS)
            Spacer()
            #endif
        }
        .navigationBarItems(trailing: Button(action: self.hideKeyboard) {
            Image(systemName: "keyboard")
        })
        .navigationTitle(navtitle)
        .navigationBarTitleDisplayMode(.automatic)
        .onAppear(perform: {
            self.item = ConversionItem(conversionType: self.conversionType)
        })


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
