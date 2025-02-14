import SwiftUI

struct VerifyEmailView: View {
    @StateObject private var verifyEmailViewModel = VerifyEmailViewModel()
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("You need to verify email to change password")
                    .font(.largeTitle)
                    .foregroundColor(Color("TextColor"))
                    .bold()
                    .padding()
                Spacer()
            }

            VStack {
                VStack {
                    TextField(
                        "email",
                        text: $verifyEmailViewModel.email
                    )
                    .font(.title2)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                }
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 300)

                VStack(spacing: 45) {
                    Button(action: { verifyEmailViewModel.resetPassword() }) {
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

            NavigationLink(destination: LoginView()) {}
        }

        .alert(isPresented: $verifyEmailViewModel.showAlert) {
            Alert(
                title: Text(verifyEmailViewModel.alertTitle),
                message: Text(verifyEmailViewModel.alertMessage),
                dismissButton: .default(Text(verifyEmailViewModel.dismissMessage))
            )
        }

        NavigationLink(destination: LoginView(), isActive: $verifyEmailViewModel.verificationLinkSent) {
            EmptyView()
        }
    }
}

#Preview {
    VerifyEmailView()
}
