//
//   ItineraryItem.swift
//  Tripify
//
//  Created by Krishay Gahlaut on 14/06/25.
//
import Foundation

struct ItineraryItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var time: Date
    var notes: String

    init(id: UUID = UUID(), title: String, time: Date, notes: String = "") {
        self.id = id
        self.title = title
        self.time = time
        self.notes = notes
    }
}
