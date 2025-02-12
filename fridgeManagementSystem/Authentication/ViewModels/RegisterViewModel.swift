import Foundation
import Observation
import Firebase


enum formError: Error {
    case invalidEmail
    case shortPassword
    case differentRepeatPassword
    case emptyField
    
    var localisedDescription: String {
        switch self {
        case .invalidEmail:
            return "You provided an invalid email, it should contain @"
        case .shortPassword:
            return "Your password is too short, it should be at least 6 characters"
        case .differentRepeatPassword:
            return "Your repeat password does not match with first one"
        case .emptyField:
            return "All fields should be filled"
        }
    }
}



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
    
    //accessed and modified from https://medium.com/@kalidoss.shanmugam/swift-ios-email-validation-best-practices-and-solutions-05456e265d2f
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func validateForm() throws{
        if email.isEmpty || name.isEmpty || password.isEmpty || repeatedPassword.isEmpty || role.isEmpty{
            throw formError.emptyField
        }
        else if !isValidEmail(email){
            throw formError.invalidEmail
        }
        else if password.count < 6{
            throw formError.shortPassword
        }
        else if password != repeatedPassword{
            throw formError.differentRepeatPassword
        }
    }
    
    
    
    func registerUser(){
        Task{
            do{
                try validateForm()
                try await RegisterService.shared.register(email: email, name: name, password: password, role: role)
                DispatchQueue.main.async {
                    self.errorMessage = nil
                    self.showSuccessAlert()
                    self.submitedRegisterRequest = true
                }
            }
            catch let error as formError {
                DispatchQueue.main.async {
                    self.errorMessage = error.localisedDescription
                    self.showErrorAlert (message:self.errorMessage!)
                    self.submitedRegisterRequest = false
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
    
