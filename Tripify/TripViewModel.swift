//
//  TripViewModel.swift
//  Tripify
//
//  Created by Krishay Gahlaut on 14/06/25.
//

import Foundation
import Combine

class TripViewModel: ObservableObject {
    @Published var trips: [Trip] = []

    func addTrip(_ trip: Trip) {
        trips.append(trip)
    }

    func deleteTrip(at offsets: IndexSet) {
        trips.remove(atOffsets: offsets)
    }
}
