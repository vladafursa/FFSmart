import Firebase
import SwiftUI

@main
struct fridgeManagementSystemApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
