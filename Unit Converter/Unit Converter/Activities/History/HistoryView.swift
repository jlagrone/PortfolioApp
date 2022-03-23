//
//  HistoryView.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/14/21.
//

import SwiftUI
import CoreData

struct HistoryView: View {
   @EnvironmentObject var dataController: DataController
   @Environment(\.presentationMode) var presentationMode
   @Environment(\.dismiss) var dismiss

   @State private var showingSortOrder = false
   @State private var sortOrder = Conversion.SortOrder.creationDate
   @State private var sortAscending = true
   @State private var showingFilterBy = false
   @State private var filterBy: ConversionType?
   @State private var showingClearConfirmation = false

   /// A static string constant for use in identifying the Tab selected in ContentView
   static let tag: String? = "HistoryView" // needed to restore state

   /// Fetch history of [Conversion]
   let conversions: FetchRequest<Conversion>

   /// Initialize history with sorting descending by date
   init() {
      conversions = FetchRequest<Conversion>(entity: Conversion.entity(),
                                             sortDescriptors: [NSSortDescriptor(keyPath: \Conversion.date,
                                                                                ascending: false)
                                             ])
   }

   var body: some View {
      NavigationView {
         List {
            if let filterBy = filterBy, items.isEmpty {
               Text("Can't find any conversions by \(filterBy.string).")
            }
            ForEach(items) { conversion in
               NavigationLink(destination:
                                 ConversionView(item: conversion,
                                                type: ConversionType(rawValue: Int(conversion.type))!)) {
                  HistoryItemView(conversionItem: conversion)
               }
            }
            .onDelete(perform: deleteItem)
         }
         .listStyle(InsetGroupedListStyle())
         .navigationTitle("History")
         .toolbar { toolbarItems }

      }
   }

   /// Sorted and/or Filtered array of Conversion history items
   private var items: [Conversion] {
      var array: [Conversion]

      switch sortOrder {
         case .creationDate:
            array = conversions.wrappedValue.sorted(by: \Conversion.conversionDate,
                                                    ascending: sortAscending)
         case .conversionType:
            array = conversions.wrappedValue.sorted(by: \Conversion.conversionType,
                                                    ascending: sortAscending)
      }

      if let filterBy = filterBy {
         return array.filter { $0.conversionType == filterBy }
      }

      return array
   }

   // MARK: - Toolbar Items

   /// Toolbar buttons for Sort, Filter, and Clear history
   private var toolbarItems: some ToolbarContent {
      Group {
         ToolbarItemGroup(placement: .navigationBarLeading) {
            sortButton
            filterButton
         }
         ToolbarItemGroup(placement: .navigationBarTrailing) {
            clearButton
            dismissButton
         }
      }
   }

   // MARK: - Sort Button

   /// Button to show Sort By dialog
   private var sortButton: some View {
      Button {
         showingSortOrder.toggle()
      } label: {
         Image(systemName: "arrow.up.arrow.down.circle")
      }
      .accessibilityLabel("Sort history")
      .confirmationDialog("Sort by:",
                          isPresented: $showingSortOrder,
                          titleVisibility: .visible) { sortConfirmationDialogButtons }
   }

   /// Button Group for Sorting options
   private var sortConfirmationDialogButtons: some View {
      Group {
         Button("Creation Date (Ascending)") { sortOrder = .creationDate; sortAscending = true }
         Button("Creation Date (Descending)") { sortOrder = .creationDate; sortAscending = false }
         Button("Conversion Type (Ascending)") { sortOrder = .conversionType; sortAscending = true }
         Button("Conversion Type (Descending)") { sortOrder = .conversionType; sortAscending = false }
         Button("Cancel", role: .cancel) { }
      }
   }

   // MARK: - Filter Button

   /// Filter button image name.
   ///
   /// Filled version of image if the filter is ON.
   private var filterButtonImageName: String {
      (filterBy == nil) ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill"
   }

   /// Filter button to show Filter By dialog
   private var filterButton: some View {
      Button {
         showingFilterBy.toggle()
      } label: {
         Image(systemName: filterButtonImageName)
      }
      .accessibilityLabel("Filter history")
      .confirmationDialog("Filter by:",
                          isPresented: $showingFilterBy,
                          titleVisibility: .visible) { filterConfirmationDialogButtons }
   }

   /// Button Group for Filter options
   private var filterConfirmationDialogButtons: some View {
      Group {
         Button("None") { filterBy = nil }
         ForEach(ConversionType.allCases, id: \.rawValue) { type in
            Button(type.string) { self.filterBy = type }
         }
         Button("Cancel", role: .cancel) { }
      }
   }

   // MARK: - Clear History Button

   /// Button to clear all history
   private var clearButton: some View {
      Button {
         showingClearConfirmation.toggle()
      } label: {
         Image(systemName: "trash")
      }
      .accessibilityLabel("Clear history")
      .confirmationDialog(
         "Permanently clear all history?",
         isPresented: $showingClearConfirmation
      ) {
         Button("Clear history?", role: .destructive, action: clearDataBase)
      }

   }

   /// Delete all item from persistent storage
   ///
   /// This should happen after user has confirmed deletion of all items.
   private func clearDataBase() {
      dataController.deleteAll()
      dataController.save()
      dataController.container.viewContext.reset()
   }

   // MARK: - Dismiss Button

   /// Button to dismiss HistoryView
   private var dismissButton: some View {
      Button("Done") {
         dismiss()
      }
   }

   // MARK: - Delete Single Item

   /// Delete specified items from persistent storage
   /// - Parameter offsets: set of indices of items to remove
   private func deleteItem(offsets: IndexSet) {
      let allItems = items

      withAnimation {
         for offset in offsets {
            let item = allItems[offset]
            dataController.delete(item)
         }
         dataController.save()
      }
   }
}

struct HistoryView_Previews: PreviewProvider {
   static var dataController = DataController.preview

   static var previews: some View {
      HistoryView()
         .environment(\.managedObjectContext, dataController.container.viewContext)
         .environmentObject(dataController)
   }
}
