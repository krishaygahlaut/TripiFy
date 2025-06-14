//
//  PackingItem.swift
//  Tripify
//
//  Created by Krishay Gahlaut on 14/06/25.
//
import Foundation

struct PackingItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var isPacked: Bool

    init(id: UUID = UUID(), name: String, isPacked: Bool = false) {
        self.id = id
        self.name = name
        self.isPacked = isPacked
    }
}
