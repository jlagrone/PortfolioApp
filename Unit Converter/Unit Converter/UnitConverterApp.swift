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

   init() {
      let dataController = DataController()
      _dataController = StateObject(wrappedValue: dataController)
   }

    var body: some Scene {
        WindowGroup {
            ContentView()
            // for SwiftUI to read dataController
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController) // our code to read dataController
        }
    }
}
