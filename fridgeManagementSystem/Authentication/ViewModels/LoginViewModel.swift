import Foundation
import Observation

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var showErrorAlert: Bool = false
    @Published var isLoggedIn: Bool = false
    
    func login() {
        print("Login initiated with email: \(email)")
        Task {
            do {
                try await AuthenticationService.shared.login(email: email, password: password)
                print("Login successful")
                DispatchQueue.main.async {
                    self.errorMessage = nil
                    self.showErrorAlert = false
                    self.isLoggedIn = true
                    print("Updated UI: User logged in successfully")
                }
            } catch let error as AuthError {
                print("Login failed with AuthError: \(error.localisedDescription)")
                DispatchQueue.main.async {
                    self.errorMessage = error.localisedDescription
                    self.showErrorAlert = true
                    self.isLoggedIn = false
                    print("Updated UI: Error - \(error.localisedDescription)")
                }
            } catch {
                print("Login failed with unknown error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.showErrorAlert = true
                    self.isLoggedIn = false
                    print("Updated UI: Error - \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    
    func logout(){
        Task{
            do{
                try AuthenticationService.shared.signOut()
                DispatchQueue.main.async {
                    self.isLoggedIn = false
                    self.errorMessage = nil
                    self.showErrorAlert = false
                }
            }
            catch{
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.showErrorAlert = true
                }
            }
        }
    }
    
    
    
    
    func resetPassword(email: String){
        Task{
            do{
                try await AuthenticationService.shared.forgotPassword(email: email)
            }
            catch{
                print(error.localizedDescription)
            }
        }
    }
    
    
}
    
    
    
        
    
    

