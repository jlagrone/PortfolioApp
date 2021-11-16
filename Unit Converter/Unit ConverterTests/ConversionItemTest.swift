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

   func testDeletingItem() throws {
      try dataController.createSampleData()

      let request = NSFetchRequest<Conversion>(entityName: "Conversion")
      let items = try managedObjectContext.fetch(request)

      XCTAssertEqual(dataController.count(for: Conversion.fetchRequest()), 5)
      dataController.delete(items[0])

      XCTAssertEqual(dataController.count(for: Conversion.fetchRequest()), 4)
   }

   func testDeletingAllItems() throws {
      try dataController.createSampleData()

      dataController.deleteAll()

      XCTAssertEqual(dataController.count(for: Conversion.fetchRequest()), 0)
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

   func testExampleConversion() {
      let conversion = Conversion.example
      XCTAssertEqual(conversion.inputUnit, UnitLength.meters.symbol)
      XCTAssertEqual(conversion.inputValue, Double.pi )

   }

   func testLengthItem() throws {
      let length = LengthUnits.sampleMeasurement
      XCTAssertEqual(length.unit, .meters)
      XCTAssertEqual(length.value, Double.pi )
   }

   func testMassItem() throws {
      let mass = MassUnits.sampleMeasurement
      XCTAssertEqual(mass.unit, .grams)
      XCTAssertEqual(mass.value, Double.pi )
   }

   func testTemperatureItem() throws {
      let temperature = TemperatureUnits.sampleMeasurement
      XCTAssertEqual(temperature.unit, .fahrenheit )
      XCTAssertEqual(temperature.value, 32.0 )
   }

   func testVolumeItem() throws {
      let volume = VolumeUnits.sampleMeasurement
      XCTAssertEqual(volume.unit, .liters)
      XCTAssertEqual(volume.value, Double.pi )
   }

   func testPressureItem() throws {
      let pressure = PressureUnits.sampleMeasurement
      XCTAssertEqual(pressure.unit, .bars)
      XCTAssertEqual(pressure.value, Double.pi )
   }
}
