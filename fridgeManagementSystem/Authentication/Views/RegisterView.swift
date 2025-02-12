import SwiftUI
import Firebase;
struct RegisterView: View {
    @StateObject private var registerViewModel = RegisterViewModel()
    @State private var selectedRole: String = "role"
    var body: some View {
        
        ZStack{
            Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
            
            VStack{
                Text("Register")
                    .font(.largeTitle)
                    .foregroundColor(Color("TextColor"))
                    .bold()
                    .padding()
                Spacer()
                
            }
          
            VStack{
                
                VStack(spacing:25){
                    
                    TextField(
                        "name",
                        text: $registerViewModel.name
                        
                    )
                    .font(.title2)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    
                        Menu {
                            Button("chef") {
                                registerViewModel.role="chef"
                                selectedRole=registerViewModel.role
                            }
                            Button("head-chef") {
                                registerViewModel.role="head-chef"
                                selectedRole=registerViewModel.role
                            }
                        }label: {
                            HStack {
                                Text(selectedRole)
                                    .foregroundColor(.gray)
                                Spacer()
                                Image(systemName: "chevron.down")
                            }
                        }
                        .foregroundColor(.gray)
                        .padding(6)
                        .frame(maxWidth: 300)
                        .foregroundColor(Color("TextColor"))
                        .background(Color.white)
                        .cornerRadius(5)
                        .menuStyle(ButtonMenuStyle())
                        .font(.title2)
                       
                        
                    
                    TextField(
                        "email",
                        text: $registerViewModel.email
                        
                    )
                    .font(.title2)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    TextField(
                        "password",
                        text: $registerViewModel.password
                        
                    )
                    .font(.title2)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    TextField(
                        "repeat password",
                        text: $registerViewModel.repeatedPassword
                        
                    )
                    .font(.title2)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                }
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 300)
               
                VStack(spacing: 20){
                    Button(action: {registerViewModel.register(email: self.registerViewModel.email, name: self.registerViewModel.name, password: self.registerViewModel.password, role: self.registerViewModel.role )}) {
                        Text("Register")
                    }
                        .font(.title2)
                        .foregroundColor(.white)
                        .bold()
                        .padding(10)
                        .frame(maxWidth: 120)
                        .background(Color("ButtonColor"))
                        .cornerRadius(5)
                        .padding(20)
                }
            }
               
                NavigationLink(destination: LoginView()){
                    
                }
            
        }
    }
}

#Preview {
    RegisterView()
}
