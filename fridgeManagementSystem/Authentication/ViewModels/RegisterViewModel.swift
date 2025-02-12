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
    @Published var showErrorAlert: Bool = false
    @Published var showSuccessAlert: Bool = false
    @Published var submitedRegisterRequest: Bool = false
    
    func registerUser(){
        Task{
            do{
                try await RegisterService.shared.register(email: email, name: name, password: password, role: role)
                DispatchQueue.main.async {
                    self.errorMessage = nil
                    self.showErrorAlert = false
                    self.showSuccessAlert = true
                    self.submitedRegisterRequest = true
                }
            }
            catch{
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.showErrorAlert = true
                    self.showSuccessAlert = false
                    self.submitedRegisterRequest = false
                }
            }
        }
    }
    
}
    
