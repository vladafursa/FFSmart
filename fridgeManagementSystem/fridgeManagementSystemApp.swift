import SwiftUI
import Firebase


@main
struct fridgeManagementSystemApp: App {
    init(){
           FirebaseApp.configure();
       }
    
    var body: some Scene {
        WindowGroup {
            if (AuthenticationService.shared.currentUser != nil) {
                HomeView()
            }
            else{
                LoginView()
            }
        }
    }
}
