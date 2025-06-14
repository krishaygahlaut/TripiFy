//
//  ItineraryViewModel.swift
//  Tripify
//
//  Created by Krishay Gahlaut on 14/06/25.
//
import Foundation

class ItineraryViewModel: ObservableObject {
    @Published var items: [ItineraryItem] = []

    func addItem(title: String, time: Date, notes: String) {
        let newItem = ItineraryItem(title: title, time: time, notes: notes)
        items.append(newItem)
    }

    func deleteItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
}
