//
//  ExtensionTests.swift
//  Unit ConverterTests
//
//  Created by James LaGrone on 11/3/21.
//

import XCTest
@testable import Unit_Converter

class ExtensionTests: XCTestCase {
   func testSequenceKeyPathSortingSelf() {
      let items = [1, 5, 4, 2, 3]
      let sortedItems = items.sorted(by: \.self)
      XCTAssertEqual(sortedItems, [1, 2, 3, 4, 5], "The numbers should be ascending.")
   }

   func testSequenceKeyPathSortingSortingCustom() {
      struct Item: Equatable {
         var string: String
      }

      let items = [
         Item(string: "Delta"),
         Item(string: "Alpha"),
         Item(string: "Gamma"),
         Item(string: "Beta")
      ]

      let itemsDescending = [
         Item(string: "Gamma"),
         Item(string: "Delta"),
         Item(string: "Beta"),
         Item(string: "Alpha")
      ]

      let sortedItems = items.sorted(by: \.string) { $0 > $1}
      XCTAssertEqual(sortedItems, itemsDescending, "Items should be descending.")
   }
}
