import Foundation
import Observation
import Firebase
class RegisterViewModel:ObservableObject{
    @Published var email: String = ""
    @Published var name: String = ""
    @Published var password: String = ""
    @Published var repeatedPassword: String = ""
    @Published var role: String = ""
    @Published var errorMessage: String?
    @Published var submitedRegisterRequest: Bool = false
    @Published var showAlert = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var dismissMessage: String = ""
    func registerUser(){
        Task{
            do{
                try await RegisterService.shared.register(email: email, name: name, password: password, role: role)
                DispatchQueue.main.async {
                    self.errorMessage = nil
                    self.showSuccessAlert()
                    self.submitedRegisterRequest = true
                }
            }
            catch let error as registerError {
                DispatchQueue.main.async {
                    self.errorMessage = error.localisedDescription
                    self.showErrorAlert (message:self.errorMessage!)
                    self.submitedRegisterRequest = false
                }
            }
            catch{
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.showErrorAlert (message:self.errorMessage ?? "An unknown error occurred")
                    self.submitedRegisterRequest = false
                }
            }
        }
    }
    
    
    func showSuccessAlert(){
        self.alertTitle = "Registration request submitted"
        self.alertMessage = "Your registration request was submitted for admin's consideration"
        self.showAlert = true
        self.dismissMessage = "OK"
    }
   
    func showErrorAlert(message: String){
        self.alertTitle = "Unsuccessful registration"
        self.alertMessage = message
        self.showAlert = true
        self.dismissMessage = "try again"
    }
}
    
