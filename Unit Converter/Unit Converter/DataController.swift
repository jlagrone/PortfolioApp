//
//  DataController.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/13/21.
//

import CoreData
import SwiftUI

class DataController: ObservableObject {
   let container: NSPersistentCloudKitContainer

   init(inMemory: Bool = false) {
      container = NSPersistentCloudKitContainer(name: "Main")

      if inMemory {
         container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
      }

      container.loadPersistentStores { storeDescription, error in
         if let error = error {
            fatalError("Fatal error loading store: \(error.localizedDescription)")
         }

      }
   }

   static var preview: DataController = {
      let dataController = DataController(inMemory: true)

      do {
         try dataController.createSampleData()
      } catch {
         fatalError("Fatal error creating preview: \(error.localizedDescription)")
      }

      return dataController
   }()

   /// Create some sample data in memory. FOR USE WITH TESTING ONLY.
   /// - Throws: if the `viewContext` fails to save
   func createSampleData() throws {
      let viewContext = container.viewContext

      for i in 0...4 {
         let conversion = Conversion(context: viewContext)
         conversion.type = Int16(Int.random(in: 0..<ConversionType.allCases.count))
         conversion.date = Date()
         conversion.inputUnit = UnitTemperature.fahrenheit.symbol
         conversion.inputValue = Double.random(in: 0...500.0)
         conversion.resultValue = Double.pi * Double.random(in: 0...5)
         conversion.resultUnit = UnitTemperature.celsius.symbol
         conversion.notes = "This conversion is sample \(i)."
      }

      try viewContext.save()
   }

   /// Save all changes
   func save() {
      if container.viewContext.hasChanges {
         try? container.viewContext.save()
      }
   }

   /// Delete specified object
   /// - Parameter object: object to be deleted
   func delete(_ object: NSManagedObject) {
       if let _object = object as? Conversion {
           print("DEBUG_RC: deleting \(_object.conversionTypeString), \(_object.conversionInputValueString)")
       }
      container.viewContext.delete(object)
   }

   /// Delete all projects in the persistent store. 
   func deleteAll() {
      let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Conversion.fetchRequest()
      let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
      _ = try? container.viewContext.execute(batchDeleteRequest)
   }
}
