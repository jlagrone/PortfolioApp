//
//  Unit_ConverterApp.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/13/21.
//

import SwiftUI

@main
struct UnitConverterApp: App {
   @StateObject var dataController: DataController
   @ObservedObject var userSettings: SettingsDefaults
   // Initialize the app with the DataController singleton for placement into the environment
   init() {
      let dataController = DataController()
      _dataController = StateObject(wrappedValue: dataController)
      userSettings = SettingsDefaults()
   }

    var body: some Scene {
        WindowGroup {
            ContentView()
            // for SwiftUI to read dataController
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController) // our code to read dataController
                .environmentObject(userSettings)
        }
    }
}
