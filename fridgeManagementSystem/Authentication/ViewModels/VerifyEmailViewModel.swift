import Foundation
import Observation

class VerifyEmailViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var errorMessage: String?
    @Published var verificationLinkSent: Bool = false
    @Published var showAlert = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var dismissMessage: String = ""
    
    
    func resetPassword(){
        Task{
            do {
                try await AuthenticationService.shared.forgotPassword(email: email)
                DispatchQueue.main.async {
                    self.errorMessage = nil
                    self.showSuccessAlert()
                    self.verificationLinkSent = true
                }
            } catch let error as AuthError {
                print("Login failed with AuthError: \(error.localisedDescription)")
                DispatchQueue.main.async {
                    self.errorMessage = error.localisedDescription
                    self.showErrorAlert(message: self.errorMessage!)
                    self.verificationLinkSent = false
                }
            } catch {
                print("Login failed with unknown error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.showErrorAlert(message: self.errorMessage ?? "an uknown error occured")
                    self.verificationLinkSent = false
                }
            }
        }
    }
    
    
    func showSuccessAlert(){
        self.alertTitle = "Verification email was sent"
        self.alertMessage = "Check your inbox and follow the instruction to reset your password"
        self.showAlert = true
        self.dismissMessage = "OK"
    }
   
    func showErrorAlert(message: String){
        self.alertTitle = "Something went wrong"
        self.alertMessage = message
        self.showAlert = true
        self.dismissMessage = "try again"
    }
    
}
    
    
    
        
    
    

