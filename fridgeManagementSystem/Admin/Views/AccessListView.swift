import SwiftUI
import Firebase
import FirebaseAuth
struct AccessListView: View {
    @State private var users: [User] = []
    @StateObject private var accessViewModel = AccessListViewModel()
    @StateObject private var loginViewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack {
                    List(accessViewModel.users) { user in
                        VStack(alignment: .leading) {
                            Text("Name: \(user.name)")
                            Text("Email: \(user.email)")
                            Text("Role: \(user.role)")
                            
                            HStack {
                                Button(action: {
                                    accessViewModel.deleteUser(id: user.id)
                                }) {
                                    Text("Delete")
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                        }
                    }
                }
                NavigationLink(destination: RequestsView()){
                    Text("view requests")
                        .underline()
                }
                .padding(.trailing, 50)
            }
            .onAppear {
                accessViewModel.listenForAccessListUpdates()
            }
            
            NavigationLink(destination: LoginView()) {
            }
            .onDisappear {
                loginViewModel.logout()
                        }
        }
    }
}



#Preview {
    AccessListView()
}
