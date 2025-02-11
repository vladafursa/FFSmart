import Foundation
import FirebaseAuth

@Observable
final class AuthenticationService{
    
    var currentUser:FirebaseAuth.User?
    private let auth=Auth.auth()
    static let shared = AuthenticationService()
    private init(){
        self.currentUser=auth.currentUser
    }
    
    
    func login(email:String, password:String) async throws{
       let result = try await auth.signIn(withEmail: email, password: password)
        currentUser=result.user
    }
    
    func register(email:String, password:String) async throws{
       let result = try await auth.createUser(withEmail: email, password: password)
       currentUser=result.user
    }
    
    func signOut() throws {
        try auth.signOut()
        currentUser=nil
    }
    
}

