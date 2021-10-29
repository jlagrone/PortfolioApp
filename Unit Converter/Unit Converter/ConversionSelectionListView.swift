//
//  ContentView.swift
//  Shared
//
//  Created by James LaGrone on 10/9/20.
//

import SwiftUI
import Foundation

/// The list of conversion types available. Shown from tab in ContentView
struct ConversionSelectionListView: View {
    @EnvironmentObject var dataController: DataController

   /// A static string constant for use in identifying the Tab selected in ContentView
    static let tag: String? = "ConversionSelectionListView"

    private let accentColor = Color.accentColor

   // Bool for showing the Settings view from tool bar button
    @State private var showingSettings: Bool = false

    var body: some View {
        ZStack {
            NavigationView {
                List(ConversionType.allCases, id: \.self) { type in
                    NavigationLink(destination: ConversionView(type: type)) {
                        Label(type.string, systemImage: type.imageName)
                            .foregroundColor(accentColor)
                            .accessibilityHint("Tap to convert \(type.string)")
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

   // The Settings Button for the tool bar
    private var settingsButton: some View {
        Button {
            showingSettings.toggle()
        } label: {
            Image(systemName: "gearshape")
        }
        .accessibilityLabel("Open Settings")
    }
}

struct ConversionSelectionListView_Previews: PreviewProvider {

    static var previews: some View {
        ConversionSelectionListView()
    }
}
