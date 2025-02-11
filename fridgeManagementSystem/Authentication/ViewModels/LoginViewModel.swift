import Foundation
import Observation
@Observable
class LoginViewModel{
    var email = ""
    var password = ""
    
    func login(){
        Task{
            do{
                try await AuthenticationService.shared.login(email: email, password: password)
            }
            catch{
                print(error.localizedDescription)
            }
        }
    }
}

