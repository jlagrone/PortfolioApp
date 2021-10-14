//
//  HistoryView.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/14/21.
//

import SwiftUI

struct HistoryView: View {
    let pastConversions: FetchRequest<Conversion>

    init() {
        pastConversions = FetchRequest<Conversion>(entity: Conversion.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Conversion.date, ascending: false)], predicate: nil, animation: nil)
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(pastConversions.wrappedValue) { conversion in
                    HStack {
                        Text("\(getString(from: conversion.conversionDate))")
                        Text(conversion.notes ?? "Huh?")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Conversion History")
        }
    }

    private func getString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
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
