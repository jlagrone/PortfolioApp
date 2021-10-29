//
//  ContentView.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/13/21.
//

import SwiftUI

/// The main view with Tab Bar (2 tabs)
struct ContentView: View {

   /// The most recently chosen tab is kept in SceneStorage.
    @SceneStorage("selectedView") var selectedView: String?

    var body: some View {
        TabView(selection: $selectedView) {

            ConversionSelectionListView()
                .tag(ConversionSelectionListView.tag)
                .tabItem {
                    Image(systemName: "arrow.2.squarepath")
                    Text("Convert")
                }

            HistoryView()
                .tag(HistoryView.tag)
                .tabItem {
                    Image(systemName: "clock")
                    Text("History")
                }
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
