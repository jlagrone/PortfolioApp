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
    @FetchRequest<Conversion>(entity: Conversion.entity(), sortDescriptors: [                                                    NSSortDescriptor(keyPath: \Conversion.date, ascending: false) ]) var items: FetchedResults<Conversion>
//    @State private var refeshingID = UUID()

    static let tag: String? = "HistoryView"

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { conversion in
                    HistoryItemView(conversionItem: conversion)
                }
                .onDelete(perform: deleteItem)
//                .id(refeshingID)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Conversion History")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    clearButton
                }
            }
        }

    }

    private var clearButton: some View {
        Button("Clear", action: clearDataBase)
    }

    func deleteItem(offsets: IndexSet) {
        let allItems = items

        withAnimation {
            for offset in offsets {
                let item = allItems[offset]
                dataController.delete(item)
            }

            dataController.save()
        }

    }

    private func clearDataBase() {
        dataController.deleteAll()
        dataController.save()
        dataController.container.viewContext.reset()
//        self.refeshingID = UUID()
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
