import Foundation
import NotificationCenter
import SwiftUI

@MainActor
class LocalNotificationManager: ObservableObject {
    let notificationCenter = UNUserNotificationCenter.current()
    @Published var isGranted = false
    @Published var pendingRequests: [UNNotificationRequest] = []
    private var hasInitialized = false
    
    func requestAuthorization() async throws {
        try await notificationCenter.requestAuthorization(options: [.sound, .badge, .alert])
        await getCurrentSettings()
    }
    
    func getCurrentSettings() async {
        let currentSettings = await notificationCenter.notificationSettings()
        isGranted = (currentSettings.authorizationStatus == .authorized)
    }
    
    func userNotificationCenter(_center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        await getPendingRequests()
        return [.banner, .sound]
    }
    
    func getPendingRequests() async {
        pendingRequests = await notificationCenter.pendingNotificationRequests()
        print("pending: \(pendingRequests.count)")
    }
    
    func getPendingNotificationCount() async -> Int {
        await getPendingRequests()
        return pendingRequests.count
    }
    
    func openSettings() {
        Task { @MainActor in
            if let url = URL(string: UIApplication.openSettingsURLString),
               UIApplication.shared.canOpenURL(url) {
                await UIApplication.shared.open(url)
            }
        }
    }
    
    func schedule(localNotification: LocalNotification) async {
        let content = UNMutableNotificationContent()
        content.title = localNotification.title
        content.body = localNotification.body
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: localNotification.dateComponents, repeats: localNotification.repeats)
        
        let request = UNNotificationRequest(identifier: localNotification.identifier, content: content, trigger: trigger)
        
        try? await notificationCenter.add(request)
        
        
        
        await getPendingRequests()
    }
    
    func clearRequests() {
        notificationCenter.removeAllPendingNotificationRequests()
        pendingRequests.removeAll()
        print("pending: \(pendingRequests.count)")
    }
    
    func initializeNotificationsIfNeeded() async {
        guard !hasInitialized else { return }
        hasInitialized = true
        
        let count = await getPendingNotificationCount()
        if count == 0 {
            let dateComponents = DateComponents(hour: 8, minute: 0)
            let localNotification = LocalNotification(
                identifier: UUID().uuidString,
                title: "Remember to complete your habits",
                body: "You have uncompleted habits, lets get it done",
                dateComponents: dateComponents,
                repeats: true
            )
            await schedule(localNotification: localNotification)
        }
    }
}

struct LocalNotification {
    var identifier: String
    var title: String
    var body: String
    var dateComponents: DateComponents
    var repeats: Bool
    
    
    
    internal init(identifier: String, title: String, body: String, dateComponents: DateComponents, repeats: Bool) {
        self.identifier = identifier
        self.title = title
        self.body = body
        self.dateComponents = dateComponents
        self.repeats = repeats
    }
    
    
}
