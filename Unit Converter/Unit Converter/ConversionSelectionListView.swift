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
                        Label(type.string, systemImage: type.imageName)
                            .foregroundColor(accentColor)
                    }
                }
                .navigationTitle("Unit Converter")
                .navigationBarItems(
                    trailing: settingsButton)
            }
            .accentColor(accentColor)
            .foregroundColor(accentColor)
        }
        .sheet(isPresented: $showingSettings, content: {
            SettingsView()
        })
    }

    private var settingsButton: some View {
        Button {
            showingSettings.toggle()
        } label: {
            Image(systemName: "gearshape")
        }
        .accessibilityLabel(Text("Open Settings"))
    }
}

struct ConversionSelectionListView_Previews: PreviewProvider {

    static var previews: some View {
        ConversionSelectionListView()
    }
}
