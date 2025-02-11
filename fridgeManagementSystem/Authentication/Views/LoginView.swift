import SwiftUI


struct LoginView: View {
    @State var viewModel = LoginViewModel()
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
                        TextField("email", text: $viewModel.email)
                            .font(.title2)
                            .disableAutocorrection(true)
                        
                        SecureField("password", text: $viewModel.password)
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
                    
                    Button(action: { viewModel.login() }) {
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
