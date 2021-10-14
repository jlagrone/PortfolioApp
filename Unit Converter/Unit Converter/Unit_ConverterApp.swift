//
//  Unit_ConverterApp.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/13/21.
//

import SwiftUI

@main
struct Unit_ConverterApp: App {
   @StateObject var dataController: DataController

   init() {
      let dataController = DataController()
      _dataController = StateObject(wrappedValue: dataController)
   }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext) // for SwiftUI to read dataController
                .environmentObject(dataController) // our code to read dataController
        }
    }
}
