import SwiftUI
import UserNotifications

@main
struct TripifyApp: App {
    @AppStorage("isDarkMode") var isDarkMode = false
    @StateObject var tripVM = TripViewModel()

    init() {
        requestNotificationPermission()
    }

    var body: some Scene {
        WindowGroup {
            TabView {
                TripListView()
                    .environmentObject(tripVM)
                    .tabItem { Label("Trips", systemImage: "airplane") }

                SettingsView()
                    .tabItem { Label("Settings", systemImage: "gear") }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }

    // MARK: - Ask for Notification Permission
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .notDetermined {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if let error = error {
                        print("❌ Notification permission error: \(error.localizedDescription)")
                    } else {
                        print(granted ? "✅ Notification permission granted" : "❌ Notification permission denied")
                    }
                }
            }
        }
    }
}
