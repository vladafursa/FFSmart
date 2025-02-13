import Firebase
final class RequestsService {
    private let db = Firestore.firestore()
    static let shared = RequestsService()
    private init() {}
  
    
    func addListenerForUserUpdates(completion: @escaping (Result<[User], Error>) -> Void) {
            db.collection("requests").addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }
                    let users: [User] = documents.map { document in
                    let data = document.data()
                    let name = data["name"] as! String
                    let email = data["email"] as! String
                    let password = data["password"] as! String
                    let role = data["role"] as! String
                    
                    return User(id: document.documentID, email: email, name: name, password: password, role: role)
                }
                completion(.success(users))
            }
        }
    
    
    func deleteRequest(id: String) async throws {
        do{
            let userRef = db.collection("requests").document(id)
            try await userRef.delete()
        }
        catch{
            throw error
        }
    }
    
    
    
    
    func addDataToAccessList(){
        
    }
    
    func acceptRequest(id: String) async throws {
        let db = Firestore.firestore()
        let sourceDocumentRef = db.collection("requests").document(id)

        // Fetch the document and handle the data
        let documentSnapshot = try await sourceDocumentRef.getDocument()
        guard let data = documentSnapshot.data(),
              let email = data["email"] as? String,
              let password = data["password"] as? String else {
            throw NSError(domain: "AcceptRequestError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Document not found or missing fields."])
        }

        // Register the user
        let authResult = try await AuthenticationService.shared.register(email: email, password: password)
        let uid = authResult.user.uid

        // Prepare user data
        var userData = data
        userData["uid"] = uid

        // Save user data to access-list
        try await db.collection("access-list").document(uid).setData(userData, merge: true)

        // Delete the request document
        try await sourceDocumentRef.delete()
        print("Document successfully copied to access-list and request deleted.")
    }

}

    
    
    
    
    
    
    

