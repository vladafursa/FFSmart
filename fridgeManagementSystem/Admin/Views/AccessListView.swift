import SwiftUI
import Firebase
import FirebaseAuth

struct AccessListView: View {
    @StateObject private var accessViewModel = AccessListViewModel()
    @StateObject private var loginViewModel = LoginViewModel()
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Access list")
                    .font(.largeTitle)
                    .foregroundColor(Color("TextColor"))
                    .bold()

                List(accessViewModel.users) { user in
                    VStack(alignment: .leading) {
                        HStack {
                            VStack {
                                Text("\(user.name) | \(user.role)")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("\(user.email)")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            HStack {
                                Button(action: {
                                    accessViewModel.deleteRequest(id: user.id)
                                }) {
                                    Text("Delete")
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color("RemoveColor"))
                                .cornerRadius(5)
                            }
                        }
                    }
                }
                .foregroundColor(Color("TextColor"))
                .background(Color("BackgroundColor"))
                .scrollContentBackground(.hidden)
                
              
                NavigationLink(destination: RequestsView()) {
                    Text("view requests")
                        .font(.title2)
                        .foregroundColor(.white)
                        .bold()
                        .padding(10)
                        .background(Color.green)
                        .cornerRadius(5)
                        .padding(20)
                }
            }
        }
        .onAppear {
            accessViewModel.listenForAccessListUpdates()
        }
    }
}

#Preview {
    AccessListView()
}
