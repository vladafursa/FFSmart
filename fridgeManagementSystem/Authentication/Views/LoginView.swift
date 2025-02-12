import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @StateObject private var authService = AuthenticationService.shared
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
                            .autocapitalization(.none)
                        SecureField("password", text: $viewModel.password)
                            .font(.title2)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
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
            
            .navigationDestination(isPresented: $viewModel.isLoggedIn) {
                if authService.userRole == "admin" {
                                    AccessListView()
                                } else {
                                    HomeView(role:authService.userRole ?? "")
                                }
                }
       
        }.onAppear {
            viewModel.logout()
        }
        .alert(isPresented: $viewModel.showErrorAlert) {
            Alert(
                title: Text("Unsuccessful login"),
                message: Text(viewModel.errorMessage ?? "An unknown error occurred"),
                dismissButton: .default(Text("try again"))
            )
            
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    LoginView()
}
