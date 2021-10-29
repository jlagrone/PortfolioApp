//
//  Sequence-Extension.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/20/21.
//

import Foundation

// Found at https://www.hackingwithswift.com/plus/ultimate-portfolio-app/custom-sorting-for-items
extension Sequence {

   /// Sort this Sequence using a KeyPath and comparator function
   ///
   /// - Example:
   ///
   ///   `sorted(by: \Conversion.conversionDate, ascending: sortAscending)`
   ///
   /// - Parameters:
   ///   - by: KeyPath for sorting the array
   ///   - using: comparator function for sorting order
   ///
   /// - Returns: sorted array of `Element`
   ///
    func sorted<Value>(by keyPath: KeyPath<Element, Value>,
                       using areInIncreasingOrder: (Value, Value) throws -> Bool) rethrows -> [Element] {
        try self.sorted {
            try areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath])
        }
    }

   /// Sort this Sequence using a KeyPath and ordering (ascending, descending)
   ///
   ///    The `ascending` parameter defaults to true when omitted.
   /// - Parameters:
   ///   - by: KeyPath for sorting the array
   ///   - ascending: if `true`, sorts in ascending order; default is true
   ///
   /// - Returns: sorted array of `Element`
   ///
    func sorted<Value: Comparable>(by keyPath: KeyPath<Element, Value>, ascending: Bool = true) -> [Element] {
        if ascending {
           return self.sorted(by: keyPath, using: <)
        } else {
           return self.sorted(by: keyPath, using: >)
        }
    }

   /// Sort this Sequence using `NSSortDescriptor`
   ///
   /// - Parameter sortDescriptor: sort descriptor specifying KeyPath and ordering
   /// - Returns: sorted array of `Element`s
    func sorted(by sortDescriptor: NSSortDescriptor) -> [Element] {
        self.sorted {
            sortDescriptor.compare($0, to: $1) == .orderedAscending
        }
    }

   /// Sort this Sequence using multiple `NSSortDescriptor`s
   /// - Parameter sortDescriptors: array of sort descriptors specifying KeyPaths and orderings on those paths
   /// - Returns: sorted array of `Element`s
    func sorted(by sortDescriptors: [NSSortDescriptor]) -> [Element] {
        self.sorted {
            for descriptor in sortDescriptors {
                switch descriptor.compare($0, to: $1) {
                case .orderedAscending:
                    return true
                case .orderedDescending:
                    return false
                case .orderedSame:
                    continue
                }
            }

            return false
        }
    }

}
