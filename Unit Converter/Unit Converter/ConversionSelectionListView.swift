//
//  ContentView.swift
//  Shared
//
//  Created by James LaGrone on 10/9/20.
//

import SwiftUI
import Foundation




struct ConversionSelectionListView: View {
    @EnvironmentObject var dataController: DataController

    static let tag: String? = "ConversionSelectionListView"

    let accentColor = Color.accentColor

    @State var showingSettings: Bool = false

    var body: some View {
        ZStack {
            NavigationView {
                List(ConversionType.allCases, id: \.self) { type in
                    NavigationLink(destination: ConversionView(type: type)) {
                        Label(type.string, systemImage: imageName(for: type))
                            .foregroundColor(accentColor)
                    }
                }
                .navigationTitle("Unit Converter")
                .navigationBarItems(
                    leading:  Button(action: addSampleData ) { Image(systemName: "plus")},
                    trailing: Button(action: { showingSettings.toggle()
                }) { Image(systemName: "gearshape") })
            }
            .accentColor(accentColor)
            .foregroundColor(accentColor)
        }
        .sheet(isPresented: $showingSettings, content: {
            SettingsView()
        })
    }

    private func addSampleData() {
            dataController.deleteAll()
            try? dataController.createSampleData()
    }

    func imageName(for type: ConversionType) -> String {
        switch type {
            case .length: return LengthUnits.imageName
            case .volume: return VolumeUnits.imageName
            case .temperature: return TemperatureUnits.imageName
            case .weight: return MassUnits.imageName
            case .pressure: return PressureUnits.imageName
        }
    }


}

struct ConversionSelectionListView_Previews: PreviewProvider {

    static var previews: some View {
        ConversionSelectionListView()
    }
}

