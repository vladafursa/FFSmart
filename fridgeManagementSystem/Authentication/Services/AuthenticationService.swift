import Foundation
import FirebaseAuth
import Firebase
//customised errors
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
    @Published var userRole: String?
    private let auth=Auth.auth()
    static let shared = AuthenticationService()
    
    private var authListener: AuthStateDidChangeListenerHandle?
    
    private init() {
        authListener = Auth.auth().addStateDidChangeListener { _, user in
            DispatchQueue.main.async {
                self.currentUser = user
                self.fetchCurrentUserRole()
            }
        }
    }
    
    
    func login(email: String, password: String) async throws {
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            print("Login Result: \(result)")
            DispatchQueue.main.async {
                self.currentUser = result.user
            }
        } catch {
            print("Email: \(email), Password: \(password)")
            print("Error Code: \((error as NSError).code)")
            
            let nsError = error as NSError
            print("NSError Domain: \(nsError.domain), Code: \(nsError.code)")
            
            if let errorCode = AuthErrorCode(rawValue: nsError.code) {
                print("Mapped Firebase Auth Error Code: \(errorCode.code)")
                switch errorCode.code {
                case .userNotFound:
                    throw AuthError.userNotFound
                case .networkError:
                    throw AuthError.networkError
                case .wrongPassword, .invalidCredential:
                    throw AuthError.incorrectPassword
                default:
                    throw AuthError.unknownError
                }
            } else{
                throw AuthError.unknownError
            }
        }
    }
    
    
    func register(email:String, password:String) async throws{
        let result = try await auth.createUser(withEmail: email, password: password)
        currentUser=nil
    }
    
    func signOut() throws {
        try auth.signOut()
        DispatchQueue.main.async {
            self.currentUser=nil
            self.userRole = nil 
        }
    }
    
    
    func forgotPassword(email: String) async throws{
        do{
            
            try await auth.sendPasswordReset(withEmail: email)
        }
        catch{
            let nsError = error as NSError
            if let errorCode = AuthErrorCode(rawValue: nsError.code) {
                print("Mapped Firebase Auth Error Code: \(errorCode.code)")
                switch errorCode.code {
                case .userNotFound:
                    throw AuthError.userNotFound
                case .networkError:
                    throw AuthError.networkError
                default:
                    throw AuthError.unknownError
                }
            } else{
                throw AuthError.unknownError
            }
        }
    }
    
    func fetchCurrentUserRole() {
        findRole { [weak self] role in
            self?.userRole = role
        }
    }
    
    func getCurrentUserUID() -> String? {
        return currentUser?.uid
    }
    
    
    
    func findRole(completion: @escaping (String?) -> Void) {
        guard let uid = getCurrentUserUID() else {
            print("No user is currently logged in.")
            completion(nil)
            return
        }
        let db = Firestore.firestore()
        let docRef = db.collection("access-list").document(uid)
        
        docRef.getDocument { (document, error) in
            if let error = error {
                print("Error retrieving document: \(error.localizedDescription)")
                
                return
            }
            
            guard let document = document, document.exists else {
                print("No document found, defaulting to admin")
                completion("admin")
                return
            }
            
            let data = document.data()
            let role = (data?["role"] as? String)!
            print(role)
            completion(role)
        }
    }
    
    
}

