import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct RequestsView: View {
    @State private var users: [User] = []
    
    @StateObject private var requestsViewModel = RequestsViewModel()
    var body: some View {
        ZStack{
            Color("BackgroundColor")
                                          .edgesIgnoringSafeArea(.all)
            
            VStack{
                VStack {
                    Text("Upcoming requests")
                        .font(.largeTitle)
                        .foregroundColor(Color("TextColor"))
                        .bold()
                }
                VStack {
                    List(requestsViewModel.users) { user in
                        VStack(alignment: .leading) {
                            HStack{
                                VStack{
                                    Text("\(user.name) | \(user.role)")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("\(user.email)")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                }
                                
                                HStack {
                                    Button(action: {
                                        print("Deny tapped for \(user.id)")
                                        requestsViewModel.deleteRequest(id: user.id)
                                    }) {
                                        Image(systemName:"minus.circle")
                                            .foregroundColor(.red)
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        print("Accept tapped for \(user.id)")
                                        requestsViewModel.acceptRequest(id: user.id)
                                    }) {
                                        Image(systemName:"plus.circle")
                                            .foregroundColor(.green)
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                }
                            }
                            
                        }
                    }
                    .foregroundColor(Color("TextColor"))
                                     
                                        .background(Color("BackgroundColor"))
                                        .scrollContentBackground(.hidden)

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
