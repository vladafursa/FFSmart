import Firebase

final class RequestsService {
    private let database = Firestore.firestore()
    static let shared = RequestsService()
    private init() {}

    func addListenerForUserUpdates(completion: @escaping (Result<[User], Error>) -> Void) {
        database.collection("requests").addSnapshotListener { snapshot, error in
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
        do {
            let userRef = database.collection("requests").document(id)
            try await userRef.delete()
        } catch {
            throw error
        }
    }

    func addDataToAccessList() {}

    func acceptRequest(id: String) async throws {
        let database = Firestore.firestore()
        let sourceDocumentRef = database.collection("requests").document(id)

        let documentSnapshot = try await sourceDocumentRef.getDocument()
        guard let data = documentSnapshot.data(),
              let email = data["email"] as? String,
              let password = data["password"] as? String
        else {
            throw NSError(domain: "AcceptRequestError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Document not found or missing fields."])
        }

        let authResult = try await AuthenticationService.shared.register(email: email, password: password)
        let uid = authResult.user.uid

        var userData = data
        userData["uid"] = uid

        try await database.collection("access-list").document(uid).setData(userData, merge: true)

        try await sourceDocumentRef.delete()
        print("Document successfully copied to access-list and request deleted.")
    }
}
