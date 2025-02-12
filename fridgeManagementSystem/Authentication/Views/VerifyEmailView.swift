import SwiftUI

struct VerifyEmailView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var email: String = ""
    var body: some View {
        ZStack{
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Text("You need to verify email to change password")
                    .font(.largeTitle)
                    .foregroundColor(Color("TextColor"))
                    .bold()
                    .padding()
                Spacer()
                
            }
            
            VStack{
                
                VStack{
                    TextField(
                        "email",
                        text: $email
                        
                    )
                    .font(.title2)
                    .disableAutocorrection(true)
                }
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 300)
               
                VStack(spacing: 45){
                    Button(action: {viewModel.resetPassword(email: email)}) {
                        Text("Verify")
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
            }
            
            
            NavigationLink(destination: LoginView()){
                
            }
        }
    }
}


#Preview {
    VerifyEmailView()
}
