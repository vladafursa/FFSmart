import SwiftUI
import Firebase


@main
struct fridgeManagementSystemApp: App {
    init(){
           FirebaseApp.configure();
       }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
