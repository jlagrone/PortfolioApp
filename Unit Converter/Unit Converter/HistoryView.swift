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
    @Environment(\.managedObjectContext) var managedObjectContext

    @State private var showingSortOrder = false
    @State private var sortOrder = Conversion.SortOrder.creationDate
    @State private var sortAscending = true
    @State private var showingFilterBy = false
    @State private var filterBy: ConversionType? = nil

    static let tag: String? = "HistoryView" // needed to restore state

    let conversions: FetchRequest<Conversion>

    init() {
        conversions = FetchRequest<Conversion>(entity: Conversion.entity(), sortDescriptors: [                                                    NSSortDescriptor(keyPath: \Conversion.date, ascending: false) ])
    }

    private var clearButton: some View {
        Button(action: clearDataBase) {
            Image(systemName: "trash")
        }
        .accessibilityLabel("Clear history.")
    }

    private var sortButton: some View {
        Button(action: { showingSortOrder.toggle() } ) {
            Image(systemName: "arrow.up.arrow.down.circle")
        }
    }

    private var filterButtonImageName: String {
        (filterBy == nil) ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill"
    }
    private var filterButton: some View {
        Button(action: { showingFilterBy.toggle() } ) {
            Image(systemName: filterButtonImageName)
        }
    }

    private var sortConfirmationDialogButtons: some View {
        Group {
            Button("Creation Date (Ascending)") { sortOrder = .creationDate; sortAscending = true }
            Button("Creation Date (Descending)") { sortOrder = .creationDate; sortAscending = false }
            Button("Conversion Type (Ascending)") { sortOrder = .conversionType; sortAscending = true }
            Button("Conversion Type (Descending)") { sortOrder = .conversionType; sortAscending = false }
            Button("Cancel", role: .cancel) { }
        }
    }

    private var filterConfirmationDialogButtons: some View {
        Group {
            Button("None") { filterBy = nil }
            ForEach(ConversionType.allCases, id: \.rawValue) { type in
                Button(type.string) { self.filterBy = type }
            }
            Button("Cancel", role: .cancel) { }
        }
    }


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

    var toolbarItems: some ToolbarContent {
        Group{
            ToolbarItemGroup(placement: .navigationBarLeading) {
                sortButton
                filterButton
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                clearButton
            }
        }
    }

    var body: some View {
        NavigationView {
            List {
                if let filterBy = filterBy, items.isEmpty  {
                    Text("Can't find any conversions by \(filterBy.string).")
                }
                ForEach(items) { conversion in
                    HistoryItemView(conversionItem: conversion)
                }
                .onDelete(perform: deleteItem)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("History")
            .toolbar { toolbarItems }
            .confirmationDialog("Select sort order", isPresented: $showingSortOrder, titleVisibility: .visible) { sortConfirmationDialogButtons }
            .confirmationDialog("Filter by", isPresented: $showingFilterBy, titleVisibility: .visible) { filterConfirmationDialogButtons }
        }
    }



    func deleteItem(offsets: IndexSet) {
        let allItems = items

        withAnimation {
            for offset in offsets {
                let item = allItems[offset]
                print("DEBUG_RC", item.conversionType.string)
                dataController.delete(item)
            }
            dataController.save()
        }
    }

    private func clearDataBase() {
        dataController.deleteAll()
        dataController.save()
        dataController.container.viewContext.reset()
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
