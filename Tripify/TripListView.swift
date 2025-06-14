import SwiftUI

struct TripListView: View {
    @StateObject private var viewModel = TripViewModel()
    @State private var showAddTrip = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                VStack(spacing: 0) {

                    // MARK: - Elegant Premium Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("TripiFy")
                            .font(.system(size: 34, weight: .semibold, design: .rounded))
                            .foregroundColor(.primary)

                        Text("by Krishay Gahlaut")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 12)
                    .padding(.bottom, 4)
                    .background(Color(.systemBackground).opacity(0.95))
                    .overlay(Divider(), alignment: .bottom)

                    // MARK: - Trip List or Empty State
                    if viewModel.trips.isEmpty {
                        Spacer()
                        VStack(spacing: 12) {
                            Image(systemName: "airplane.departure")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.blue.opacity(0.7))

                            Text("No Trips Yet")
                                .font(.title2)
                                .foregroundColor(.secondary)

                            Text("Tap + to add your first trip")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    } else {
                        List {
                            ForEach(viewModel.trips) { trip in
                                NavigationLink(destination: TripDetailView(trip: trip)) {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(trip.name)
                                            .font(.headline)
                                            .foregroundColor(.primary)

                                        Text(trip.destination)
                                            .font(.subheadline)
                                            .foregroundColor(.blue)

                                        Text("\(trip.startDate.formatted(date: .abbreviated, time: .omitted)) → \(trip.endDate.formatted(date: .abbreviated, time: .omitted))")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.vertical, 6)
                                }
                            }
                            .onDelete(perform: viewModel.deleteTrip)
                        }
                        .listStyle(.insetGrouped)
                    }

                    Spacer(minLength: 0)
                }

                // MARK: - Floating Add Button
                Button(action: {
                    showAddTrip = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 4)
                }
                .padding()
                .accessibilityLabel("Add Trip")
            }
            .sheet(isPresented: $showAddTrip) {
                AddTripView(viewModel: viewModel)
            }
        }
    }
}
