//
//  DataController.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/13/21.
//

import CoreData
import SwiftUI

/// An environment singleton for managing Core Data stack, handling fetch requests, sample data, saving and deleting,
class DataController: ObservableObject {

   /// The lone CloudKit container for storing all data.
   let container: NSPersistentCloudKitContainer

   /// Initializes a data controller, either in memory for testing and previewing, or
   ///  on permanent storage in regular use. Defaults to permanent storage.
   /// - Parameter inMemory: Whether to store data in temporary memory or not.
   init(inMemory: Bool = false) {
      container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)

      //   For testing and previewing, create temporary database and write to /dev/null
      //   so data is destroying on app exit.
      if inMemory {
         container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
      }

      container.loadPersistentStores { _, error in
         if let error = error {
            fatalError("Fatal error loading store: \(error.localizedDescription)")
         }

      }
   }

   static let model: NSManagedObjectModel = {
      guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
         fatalError("Faile to locate model file.")
      }

      guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
         fatalError("Failed to load model file.")
      }

      return managedObjectModel
   }()

    /// For use in SwiftUI previews and Testing
    static var preview: DataController = {
      let dataController = DataController(inMemory: true)

      do {
         try dataController.createSampleData()
      } catch {
         fatalError("Fatal error creating preview: \(error.localizedDescription)")
      }

      return dataController
   }()

   /// Creates some example items to make testing easier.
   ///
   /// FOR USE WITH TESTING ONLY.
   /// - Throws: An NSError sent from calling save() on the NSManagedObjectContext
   func createSampleData() throws {
      let viewContext = container.viewContext

      _ = LengthUnits.sampleConversion(context: viewContext)
      _ = MassUnits.sampleConversion(context: viewContext)
      _ = VolumeUnits.sampleConversion(context: viewContext)
      _ = PressureUnits.sampleConversion(context: viewContext)
      _ = TemperatureUnits.sampleConversion(context: viewContext)

      try viewContext.save()
   }

   /// Saves Core Data context iff there are changes. Errors caused by saving are silently ignored since all
   /// attributes are optional.
   func save() {
      if container.viewContext.hasChanges {
         try? container.viewContext.save()
      }
   }

   /// Deletes specified object
   /// - Parameter object: object to be deleted
   func delete(_ object: NSManagedObject) {
       if let object = object as? Conversion {
           print("DEBUG_RC: deleting \(object.conversionTypeString), \(object.conversionInputValueString)")
       }
      container.viewContext.delete(object)
   }

   /// Deletes all projects in the persistent store.
   func deleteAll() {
      let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Conversion.fetchRequest()
      let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
      _ = try? container.viewContext.execute(batchDeleteRequest)
   }

   func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
      (try? container.viewContext.count(for: fetchRequest)) ?? 0
   }
}
