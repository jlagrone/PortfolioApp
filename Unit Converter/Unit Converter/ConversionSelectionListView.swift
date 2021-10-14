//
//  ContentView.swift
//  Shared
//
//  Created by James LaGrone on 10/9/20.
//

import SwiftUI
import Foundation




struct ConversionSelectionListView: View {

    let accentColor = Color.red

    @State var showingSettings: Bool = false

    @State var item: ConversionItem? = nil

    var body: some View {
        ZStack {
            NavigationView {
                List(ConversionType.allCases, id: \.self) { type in
                    NavigationLink(destination: ConversionView(conversionType: type)) {
                        Label(type.string, systemImage: ConversionItem.imageName(for: type))
                            .foregroundColor(accentColor)
                    }
                }
                .navigationTitle("Unit Converter")
                .navigationBarItems(trailing: Button(action: { showingSettings.toggle()

                }) {
                    Image(systemName: "gearshape")
                })
            }
            .accentColor(accentColor)
            .foregroundColor(accentColor)
        }
        .sheet(isPresented: $showingSettings, content: {
            SettingsView()
        })
    }


}

struct ConversionSelectionListView_Previews: PreviewProvider {

    static var previews: some View {
        ConversionSelectionListView(item: ConversionItem(conversionType: .volume))
    }
}

