import SwiftUI
import UserNotifications
import UIKit

struct TripDetailView: View {
    let trip: Trip
    @StateObject private var itineraryVM = ItineraryViewModel()
    @State private var showPackingList = false

    @State private var newTitle = ""
    @State private var newTime = Date()
    @State private var newNotes = ""

    var body: some View {
        NavigationStack {
            Form {
                // Add itinerary
                Section(header: Text("Add Itinerary Item")) {
                    TextField("Title", text: $newTitle)
                    DatePicker("Time", selection: $newTime, displayedComponents: .hourAndMinute)
                    TextField("Notes", text: $newNotes)

                    Button("Add") {
                        itineraryVM.addItem(title: newTitle, time: newTime, notes: newNotes)
                        newTitle = ""
                        newTime = Date()
                        newNotes = ""
                    }
                    .disabled(newTitle.isEmpty)
                }

                // View itinerary
                if !itineraryVM.items.isEmpty {
                    Section(header: Text("Daily Schedule")) {
                        ForEach(itineraryVM.items) { item in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.title).font(.headline)
                                Text(item.time.formatted(date: .omitted, time: .shortened))
                                    .foregroundColor(.secondary)
                                if !item.notes.isEmpty {
                                    Text(item.notes)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: itineraryVM.deleteItem)
                    }
                }

                // Actions
                Section(header: Text("Trip Tools")) {
                    Button("🧳 Open Packing List") {
                        showPackingList = true
                    }

                    Button("🔔 Set Trip Start Reminder") {
                        scheduleTripReminder()
                    }

                    Button("📄 Export Itinerary as PDF") {
                        exportTripAsPDF()
                    }

                    Button("🌍 View in Maps") {
                        openInMaps(query: trip.destination)
                    }
                }
            }
            .navigationTitle(trip.name)
            .sheet(isPresented: $showPackingList) {
                PackingListView(trip: trip)
            }
        }
    }

    // MARK: - Schedule Reminder
    private func scheduleTripReminder() {
        let content = UNMutableNotificationContent()
        content.title = "✈️ Your trip to \(trip.destination) starts today!"
        content.body = "\(trip.name) kicks off now. Safe travels!"
        content.sound = .default

        // 🔧 Option A: Schedule at 9:00 AM on trip start date
        var triggerDate = Calendar.current.dateComponents([.year, .month, .day], from: trip.startDate)
        triggerDate.hour = 9
        triggerDate.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        // 🔧 Option B (for testing): 10 seconds from now
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)

        let request = UNNotificationRequest(
            identifier: trip.id.uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Notification error: \(error.localizedDescription)")
            } else {
                print("✅ Trip reminder scheduled for \(triggerDate)")

                UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                    print("🔔 Pending Notifications:")
                    for req in requests {
                        print("- \(req.identifier): \(req.trigger?.description ?? "nil")")
                    }
                }
            }
        }
    }

    // MARK: - Export PDF
    private func exportTripAsPDF() {
        let pdfData = PDFExportService.generatePDF(for: trip, itinerary: itineraryVM.items)
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("\(trip.name).pdf")

        do {
            try pdfData.write(to: url)
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)

            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = scene.windows.first?.rootViewController {
                rootVC.present(activityVC, animated: true)
            }
        } catch {
            print("❌ PDF export failed: \(error.localizedDescription)")
        }
    }

    // MARK: - Open in Maps
    private func openInMaps(query: String) {
        let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "http://maps.apple.com/?q=\(escapedQuery)") {
            UIApplication.shared.open(url)
        }
    }
}
