import FirebaseFirestore

final class RegisterService {
    private let db = Firestore.firestore()
            
    static let shared = RegisterService()
    
    private init() {}
    
        func register(email:String, name:String, password:String, role:String) async throws {
            do {
                try await db.collection("requests").document().setData(["email":email, "name":name, "password":password, "role":role]);
            } catch {
              throw error
            }
        }
}

