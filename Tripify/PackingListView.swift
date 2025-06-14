//
//  PackingListView.swift
//  Tripify
//
//  Created by Krishay Gahlaut on 14/06/25.
//
import SwiftUI

struct PackingListView: View {
    let trip: Trip
    @State private var items: [PackingItem] = []
    @State private var newItem = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Image(systemName: item.isPacked ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(item.isPacked ? .green : .gray)
                            .onTapGesture {
                                togglePacked(item)
                            }
                    }
                }
                .onDelete { indexSet in
                    items.remove(atOffsets: indexSet)
                }

                HStack {
                    TextField("New item", text: $newItem)
                    Button("Add") {
                        if !newItem.isEmpty {
                            items.append(PackingItem(name: newItem))
                            newItem = ""
                        }
                    }
                }
            }
            .navigationTitle("🧳 Packing List")
            .onAppear {
                if items.isEmpty {
                    generateSuggestedItems()
                }
            }
        }
    }

    private func togglePacked(_ item: PackingItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isPacked.toggle()
        }
    }

    private func generateSuggestedItems() {
        items = [
            PackingItem(name: "Toothbrush"),
            PackingItem(name: "Clothes"),
            PackingItem(name: "Phone Charger"),
            PackingItem(name: "Passport"),
            PackingItem(name: "Power Bank"),
        ]

        let days = Calendar.current.dateComponents([.day], from: trip.startDate, to: trip.endDate).day ?? 1
        if days >= 4 {
            items.append(PackingItem(name: "Extra Shoes"))
            items.append(PackingItem(name: "Laundry Bag"))
        }

        if trip.destination.lowercased().contains("beach") {
            items.append(PackingItem(name: "Swimsuit"))
            items.append(PackingItem(name: "Sunscreen"))
        }
    }
}
