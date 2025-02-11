import SwiftUI
import Firebase;
struct RegisterView: View {
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var password: String = ""
    @State private var repeatedPassword: String = ""
    @State private var role: String = ""
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
                        text: $name
                        
                    )
                    .font(.title2)
                    .disableAutocorrection(true)
                    
                    
                        Menu {
                            Button("chef") {
                                role="chef"
                            }
                            Button("head-chef") {
                                role="head-chef"
                            }
                        }label: {
                            HStack {
                                Text("role")
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
                        text: $email
                        
                    )
                    .font(.title2)
                    .disableAutocorrection(true)
                    
                    TextField(
                        "password",
                        text: $password
                        
                    )
                    .font(.title2)
                    .disableAutocorrection(true)
                    
                    TextField(
                        "repeat password",
                        text: $repeatedPassword
                        
                    )
                    .font(.title2)
                    .disableAutocorrection(true)
                }
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 300)
               
                VStack(spacing: 20){
                    Button(action: {}) {
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
            
            
            
            
            
            VStack{
               
                NavigationLink(destination: LoginView()){
                    
                }
            }
        }
    }
}

#Preview {
    RegisterView()
}
