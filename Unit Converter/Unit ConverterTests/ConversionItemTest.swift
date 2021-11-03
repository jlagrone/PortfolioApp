//
//  ConversionItemTest.swift
//  Unit ConverterTests
//
//  Created by James LaGrone on 10/29/21.
//

import XCTest
import CoreData
@testable import Unit_Converter

class ConversionItemTest: BaseTestCase {
   func testCreatingConversionItems() {
      let targetCount = 10

      for _ in 0..<targetCount {
         _ = Conversion(context: managedObjectContext)
      }

      XCTAssertEqual(dataController.count(for: Conversion.fetchRequest()), targetCount)
   }

   func testDeletingItems() throws {
      try dataController.createSampleData()

      let request = NSFetchRequest<Conversion>(entityName: "Conversion")
      let items = try managedObjectContext.fetch(request)

      XCTAssertEqual(dataController.count(for: Conversion.fetchRequest()), 5)
      dataController.delete(items[0])

      XCTAssertEqual(dataController.count(for: Conversion.fetchRequest()), 4)
   }

   func testAddingItem() throws {

      var request = NSFetchRequest<Conversion>(entityName: "Conversion")

      XCTAssertEqual(dataController.count(for: Conversion.fetchRequest()), 0)

      try dataController.createSampleData()

      request = NSFetchRequest<Conversion>(entityName: "Conversion")
      _ = try managedObjectContext.fetch(request)

      XCTAssertEqual(dataController.count(for: Conversion.fetchRequest()), 5)

      _ = TemperatureUnits.sampleConversion(context: managedObjectContext)

      XCTAssertEqual(dataController.count(for: Conversion.fetchRequest()), 6)

   }
}
