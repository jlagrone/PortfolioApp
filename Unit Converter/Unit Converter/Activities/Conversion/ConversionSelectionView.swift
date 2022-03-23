//
//  ConversionSelectionView.swift
//  Shared
//
//  Created by James LaGrone on 10/9/20.
//

import SwiftUI
import Foundation

/// The list of conversion types available. Shown from tab in ContentView
struct ConversionSelectionView: View {
   @EnvironmentObject var dataController: DataController
   @EnvironmentObject var userSettings: SettingsDefaults

   /// A static string constant for use in identifying the Tab selected in ContentView
   static let tag: String? = "ConversionSelectionView"

   private let accentColor = Color.accentColor

   // Bool for showing the Settings view from tool bar button
   @State private var showingSettings: Bool = false

   var body: some View {
      NavigationView {
         Group {
            if userSettings.homeViewType == .grid {
               gridView
                  .padding([.horizontal, .top])
            } else {
               listView
            }
         }
         .background(Color.systemGroupedBackground.ignoresSafeArea())
         .navigationTitle("Unit Converter")
         .navigationBarItems(trailing: showSettingsButton)
      }
      .accentColor(accentColor)
      .foregroundColor(accentColor)
   }

   let columns = [
//      GridItem(.fixed(200)),
      GridItem(.flexible(minimum: 30, maximum: 300), spacing: 15),
      GridItem(.flexible(minimum: 30, maximum: 300), spacing: 15),
      GridItem(.flexible(minimum: 30, maximum: 300), spacing: 15)
   ]

   var gridView: some View {
      ScrollView(.vertical, showsIndicators: true) {
         LazyVGrid(columns: columns, spacing: 20) {
            ForEach(ConversionType.allCases, content: ListingGridItem.init)
         }
      }
   }

   var listView: some View {
      List {
         ForEach(ConversionType.allCases, content: ListingRow.init)
      }
   }

   var showSettingsButton: some View {
      Button(action: toggleShowSettings) {
         Image(systemName: "gearshape")
      }
      .accessibilityLabel("Open Settings")
      .sheet(isPresented: $showingSettings, onDismiss: onDismissSettings) {
         SettingsView()
      }
   }

   func toggleShowSettings() {
      showingSettings.toggle()
   }

   func onDismissSettings() {
      print("Dismissing")
      userSettings.refresh.toggle()
   }

}

struct ConversionSelectionListView_Previews: PreviewProvider {

   static var previews: some View {
      ConversionSelectionView()
         .environmentObject(SettingsDefaults(with: .list))
      ConversionSelectionView()
         .environmentObject(SettingsDefaults(with: .grid))
   }
}
