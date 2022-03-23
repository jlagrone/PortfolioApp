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
   @EnvironmentObject var userSettings: SettingsDefaults

   // Bool for showing the Settings view from tool bar button
   @State private var showingSettings: Bool = false
   @State private var showingHistory: Bool = false

   var body: some View {

      NavigationView {
         ConversionSelectionView()
            .tag(ConversionSelectionView.tag)
            .tabItem {
               Image(systemName: "arrow.2.squarepath")
               Text("Convert")
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Unit Converter")
            .navigationBarItems(leading: historyButton, trailing: settingsButton)
      }
      .accentColor(Color.accentColor)
      .foregroundColor(Color.accentColor)
   }

   var historyButton: some View {
      Button(action: toggleShowHistory) {
         Image(systemName: "clock")
      }
      .accessibilityLabel("Show History")
      .sheet(isPresented: $showingHistory, onDismiss: onDismissSettings) {
         HistoryView()
      }
   }

   var settingsButton: some View {
      Button(action: toggleShowSettings) {
         Image(systemName: "gearshape")
      }
      .accessibilityLabel("Open Settings")
      .sheet(isPresented: $showingSettings, onDismiss: onDismissSettings) {
         SettingsView()
      }
   }

   func toggleShowHistory() {
      showingHistory.toggle()
   }

   func toggleShowSettings() {
      showingSettings.toggle()
   }

   func onDismissSettings() {
      print("Dismissing")
      userSettings.refresh.toggle()
   }

}

struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
      ContentView()
         .environmentObject(SettingsDefaults())
   }
}
