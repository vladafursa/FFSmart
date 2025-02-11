import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    @State  var email = ""
    @State  var password = ""
    @State private var isLoggedIn = false
    @State private var role = ""
    @State private var loading = true
    @State private var showTabView = false
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Login")
                        .font(.largeTitle)
                        .foregroundColor(Color("TextColor"))
                        .bold()
                        .padding()
                    Spacer()
                }
                
                VStack(spacing: 15) {
                    VStack(spacing: 35) {
                        TextField("email", text: $email)
                            .font(.title2)
                            .disableAutocorrection(true)
                        
                        SecureField("password", text: $password)
                            .font(.title2)
                            .disableAutocorrection(true)
                    }
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 300)
                    
                    HStack {
                        Spacer()
                        NavigationLink(destination: VerifyEmailView()) {
                            Text("Forgot password?")
                                .underline()
                        }
                        .padding(.trailing, 50)
                    }
                    
                    Button(action: {  }) {
                        Text("Submit")
                    }
                    .font(.title2)
                    .foregroundColor(.white)
                    .bold()
                    .padding(10)
                    .frame(maxWidth: 120)
                    .background(Color("ButtonColor"))
                    .cornerRadius(5)
                    .padding(20)
                    
                    HStack {
                        Text("Not registered yet?")
                            .foregroundColor(Color("TextColor"))
                        NavigationLink(destination: RegisterView()) {
                            Text("Register")
                                .underline()
                        }
                    }
                    .padding(20)
                }
            }
        }
    }
    
  
    
    
    
    }


#Preview {
    LoginView()
}
