import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct RequestsView: View {
    @State private var users: [User] = []
    
    @StateObject private var requestsViewModel = RequestsViewModel()
    var body: some View {
        VStack {
            List(requestsViewModel.users) { user in
                VStack(alignment: .leading) {
                    Text("Name: \(user.name)")
                    Text("Email: \(user.email)")
                    Text("Role: \(user.role)")
                    
                    HStack {
                        Button(action: {
                            print("Deny tapped for \(user.id)")
                            requestsViewModel.deleteRequest(id: user.id)
                        }) {
                            Text("Deny")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Spacer()
                        
                        Button(action: {
                            print("Accept tapped for \(user.id)")
                            requestsViewModel.acceptRequest(id: user.id)
                        }) {
                            Text("Accept")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }


                    
                }
            }
        }
        .onAppear {
            requestsViewModel.listenForRequestsUpdates()
        }
        
        NavigationLink(destination: AccessListView()){
            
        }
    }
   
    
    
}

#Preview {
    RequestsView()
}
