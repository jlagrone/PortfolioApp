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

   var body: some View {
         Group {
            if userSettings.homeViewType == .grid {
               gridView
                  .padding([.horizontal, .top])
            } else {
               listView
            }
         }
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

}

struct ConversionSelectionListView_Previews: PreviewProvider {

   static var previews: some View {
      ConversionSelectionView()
         .environmentObject(SettingsDefaults(with: .list))
      ConversionSelectionView()
         .environmentObject(SettingsDefaults(with: .grid))
   }
}
