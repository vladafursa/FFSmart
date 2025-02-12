import FirebaseFirestore

enum registerError: Error {
    case userRegistered
    case userHasRequestedRegistration
    
    var localisedDescription: String {
        switch self {
        case .userRegistered:
            return "You are already registered"
        case .userHasRequestedRegistration:
            return "Your request is still under consideration of the admin"
        }
    }
}


final class RegisterService {
    private let db = Firestore.firestore()
            
    static let shared = RegisterService()
    let ACCESS_LIST_COLLECTION_NAME: String = "access-list"
    let REQUESTS_COLLECTION_NAME: String = "requests"
    
    private init() {}
    
        func register(email:String, name:String, password:String, role:String) async throws {
            do {
                let registered = try await isUserRegistered( email: email)
                if registered {
                    throw registerError.userRegistered
                }
                else{
                    let submittedRequest = try await isUserInRequestList(email: email)
                    if submittedRequest {
                        throw registerError.userHasRequestedRegistration
                    }
                    else{
                        try await db.collection("requests").document().setData(["email":email, "name":name, "password":password, "role":role]);
                    }
                }
            } catch {
              throw error
            }
        }
    
    
    func isUserRegistered( email: String) async throws -> Bool {
        return try await isUserPresentInDatabase(collection: ACCESS_LIST_COLLECTION_NAME, email: email)
    }
    
    func isUserInRequestList( email: String) async throws -> Bool {
        return try await isUserPresentInDatabase(collection: REQUESTS_COLLECTION_NAME, email: email)
    }
    
    func isUserPresentInDatabase(collection: String, email: String) async throws -> Bool {
        let query = db.collection(collection).whereField("email", isEqualTo: email)
        do {
            let snapshot = try await query.getDocuments()
            return !snapshot.documents.isEmpty
        } catch {
            return false
        }
    }
    
    
}

