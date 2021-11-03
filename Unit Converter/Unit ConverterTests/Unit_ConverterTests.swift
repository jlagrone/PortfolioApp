//
//  Unit_ConverterTests.swift
//  Unit ConverterTests
//
//  Created by James LaGrone on 10/29/21.
//

import CoreData
import XCTest
@testable import Unit_Converter

class BaseTestCase: XCTestCase {
   var dataController: DataController!
   var managedObjectContext: NSManagedObjectContext!

   override func setUpWithError() throws {
      dataController = DataController(inMemory: true)
      managedObjectContext = dataController.container.viewContext
   }
}
