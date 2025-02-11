import Foundation
import FirebaseAuth

enum AuthError: Error {
    case userNotFound
    case incorrectPassword
    case networkError
    case unknownError
    
    var localisedDescription: String {
        switch self {
        case .userNotFound:
            return "The user with such email does not exist. Please enter a valid email"
        case .incorrectPassword:
            return "You provided incorrect password"
        case .networkError:
            return "There are some network issues, try again later"
        case .unknownError:
            return "Something went wrong, we are trying to solve it. try again later"
        }
    }
}

final class AuthenticationService: ObservableObject {
    @Published var currentUser:FirebaseAuth.User?
    private let auth=Auth.auth()
    static let shared = AuthenticationService()
    
    private init(){
        self.currentUser=auth.currentUser
    }
    
    
    func login(email: String, password: String) async throws {
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            print("Login Result: \(result)")
            currentUser = result.user
        } catch {
            print("Email: \(email), Password: \(password)")
            print("Error Code: \((error as NSError).code)")
            
            // Use NSError domain and code for detailed debugging
            let nsError = error as NSError
            print("NSError Domain: \(nsError.domain), Code: \(nsError.code)")
            
            if let errorCode = AuthErrorCode(rawValue: nsError.code) {
                print("Mapped Firebase Auth Error Code: \(errorCode.code)")
                switch errorCode.code {
                case .userNotFound:
                    throw AuthError.userNotFound
                case .networkError:
                    throw AuthError.networkError
                case .invalidCredential:
                    throw AuthError.incorrectPassword
                case .wrongPassword:
                    throw AuthError.incorrectPassword
                default:
                    throw AuthError.unknownError
                }
            } else {
                throw AuthError.unknownError
            }
        }
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

