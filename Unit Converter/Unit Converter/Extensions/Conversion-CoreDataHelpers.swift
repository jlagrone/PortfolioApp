//
//  Conversion-CoreDataHelpers.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/14/21.
//

import Foundation
import CoreData
import SwiftUI

//  Conversion properties in Core Data model:
//      date        Date
//      inputUnit   String      (ft, m, L, ºC, kg, etc.)
//      inputValue  Double
//      notes       String
//      resultUnit  String      (ft, m, L, ºC, kg, etc.)
//      resultValue Double
//      type        int16       (length, mass, volume, temperature, etc.)

/// This extension to the Conversion class created by Core Data attributes are
/// helpers to unwrap optionals from Core Data.
extension Conversion {

    enum SortOrder {
        case creationDate, conversionType
    }

   convenience init(type: ConversionType, date: Date,
                    inputUnit: String, inputValue: Double,
                    resultUnit: String, resultValue: Double,
                    context: NSManagedObjectContext? = nil) {

      if let context = context {
         self.init(context: context)
      } else {
         self.init()
      }

      self.type = type.int16Value
      self.date = date
      self.inputUnit = inputUnit
      self.inputValue = inputValue
      self.resultUnit = resultUnit
      self.resultValue = resultValue
      self.notes = ""
   }

    // MARK: - Date
    var conversionDate: Date { date ?? Date("1/1/1970") }

    // MARK: - Conversion Type

    // Takes Int16 value from Core Data and returns associated `ConversionType`
    var conversionType: ConversionType {
        let type = ConversionType(rawValue: Int(type)) ?? .length
        return type
    }

    /// The `String` for the `conversionType` for UI presentation, like "Length (Distance)"
    var conversionTypeString: String {
        let type = ConversionType(rawValue: Int(type))
        let returnString = type?.string ?? ""
        return returnString
    }

    // MARK: - Original (inputValue and inputUnit)

   /// The "from" value provided by the user
   var conversionInputValue: Double { inputValue }
   // No unwrapping necessary; just provides consistent interface

    /// *"ft"* or *"ºC"*
    var conversionInputSymbol: String { inputUnit ?? ""}

    /// In the format of *12 ft* or *5.3 m*
    var conversionInputAsString: String {
        "\(inputValue) \(conversionInputSymbol)"
    }

    /// The input value as a `String`
    var conversionInputValueString: String {
        String(inputValue)
    }

    /// The unit converting FROM
    var conversionInputUnit: Dimension {
       guard let dimension = UnitProtocolHelper.dimension(of: conversionInputSymbol) else {
          fatalError("Conversion input unit received a bad symbol: \(conversionInputSymbol)")
       }
       return dimension
    }

    ///  Provides original input value as a `Measurement` object
    var originalAsMeasurement: Measurement<Dimension> {
        let measurement = Measurement(value: inputValue, unit: conversionInputUnit )
        return measurement
    }

    /// In the format of *12 ft* or *5.3 m, using significant digits*
    var conversionFormattedInputAsString: String {
        let string = formatAsString(originalAsMeasurement)
        return string
    }

    // MARK: - Result (resultValue and resultUnit)

    /// No unwrapping necessary; just provides consistent interface
    var conversionResultValue: Double { resultValue }

    /// *"ft"* or *"ºC"*
    var conversionResultSymbol: String { resultUnit ?? ""}

    /// In the format of *12 ft* or *5.3 m*
    var conversionResultAsString: String {
         "\(resultValue) \(conversionResultSymbol)"
    }

    /// The unit converting TO.
    var conversionResultUnit: Dimension {
       guard let dimension = UnitProtocolHelper.dimension(of: conversionResultSymbol) else {
          fatalError("Conversion input unit received a bad symbol: \(conversionInputSymbol)")
       }
       return dimension
    }

    ///  Provides result value as a `Measurement` object
    var resultAsMeasurement: Measurement<Dimension> {
       let measurement = Measurement(value: inputValue, unit: conversionInputUnit )
       let result = measurement.converted(to: conversionResultUnit)
       return result
    }

    /// In the format of *12 ft* or *5.3 m, using significant digits*
    var conversionFormattedResultAsString: String {
        let string = formatAsString(resultAsMeasurement)
        return string
    }

    // MARK: - Notes
    /// Unwrapped notes property
    var conversionNotes: String {
        notes ?? ""
    }

    // MARK: - Methods

    /// This method returns the `measurement` parameter as string using specified significant digits.
    /// - Parameter measurement: A Measurement object to stringify
    /// - Parameter sigDigits: (Optional) number of significant digits to use. Default value is 5.
    /// - Returns: A string representation of the `measurement`in the format of "*1.2345 ºC*"
    private func formatAsString(_ measurement: Measurement<Dimension>, sigDigits: Int = 5) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.roundingMode = .halfUp
        numberFormatter.maximumSignificantDigits = sigDigits

       let formatter = MeasurementFormatter()
       formatter.numberFormatter = numberFormatter
       formatter.unitOptions = .providedUnit
       let returnValue = formatter.string(from: measurement)
       return returnValue

//        let number = numberformatter.string(from: measurement.value as NSNumber)
//        return "\(number ?? "NAN") \(measurement.unit.symbol)"
    }

   static var example: Conversion {
      let controller = DataController.preview
      let viewContext = controller.container.viewContext

      return LengthUnits.sampleConversion(context: viewContext)
   }
}
