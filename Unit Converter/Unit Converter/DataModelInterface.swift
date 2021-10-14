//
//  DataModelInterface.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/13/21.
//

import Foundation


enum ConversionType: CaseIterable {
   case length, volume, mass, area
}

struct UnitType {
   enum Length: CaseIterable {
      case inch, foot, yard, mile, millimeter, centimeter, meter, kilometer
   }

   enum Volume: CaseIterable {
      case ounce, cup, pint, quart, gallon, milliliter, liter
   }

   enum Area: CaseIterable {
      case  squareInch, squareFeet, acre, squareMile, squareCentimeter, squareMeter, hectare, squareKilometer
   }

   enum Mass: CaseIterable {
      case ounce, pound, stone, ton, milligram, gram, kilogram, metricTonne
   }
}
