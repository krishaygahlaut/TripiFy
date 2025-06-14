//
//  trip.swift
//  Tripify
//
//  Created by Krishay Gahlaut on 14/06/25.
//

import Foundation

struct Trip: Identifiable, Codable {
    let id: UUID
    var name: String
    var destination: String
    var startDate: Date
    var endDate: Date
    var notes: String

    init(id: UUID = UUID(), name: String, destination: String, startDate: Date, endDate: Date, notes: String = "") {
        self.id = id
        self.name = name
        self.destination = destination
        self.startDate = startDate
        self.endDate = endDate
        self.notes = notes
    }
}
