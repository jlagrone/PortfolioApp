//
//  ContentView.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/13/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {

            ConversionSelectionListView()
                .tabItem {
                    Image(systemName: "arrow.2.squarepath")
                    Text("Convert")
                }

            HistoryView()
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
