//
//  Date-Extension.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/15/21.
//

import Foundation


extension Date {


    /// Create a Date object from a date string with *dd/mm/yy* format
    ///     Uses `"en_US"` for locale
    /// - Parameter dateString: Date in *dd/mm/yy* format
   init(_ dateString: String)  {

      let dateStringFormatter = DateFormatter()
      dateStringFormatter.dateStyle = .short
      dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale?

      let calendar = Calendar.current
      let year = calendar.component(.year, from: Date())

      var str = dateString
      let parts = dateString.components(separatedBy: "/")
      if parts.count == 2 {
         str = "\(dateString)/\(year)"
      }

      if let d = dateStringFormatter.date(from: str) {
         self.init(timeInterval:0, since:d)
      } else {
         self.init(timeIntervalSince1970: 0)
      }
   }
    
    /// Date as string with `.short` style for dateStyle and timeStyle
    var shortDescription: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }

}
