//
//  AddTripView.swift
//  Tripify
//
//  Created by Krishay Gahlaut on 14/06/25.
//
import SwiftUI

struct AddTripView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TripViewModel

    @State private var name = ""
    @State private var destination = ""
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(86400)
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Trip Info")) {
                    TextField("Trip Name", text: $name)
                    TextField("Destination", text: $destination)
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                }

                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("New Trip")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let trip = Trip(name: name, destination: destination, startDate: startDate, endDate: endDate, notes: notes)
                        viewModel.addTrip(trip)
                        dismiss()
                    }
                    .disabled(name.isEmpty || destination.isEmpty)
                }
            }
        }
    }
}
