import Firebase

final class AccessListService {
    private let db = Firestore.firestore()
    static let shared = AccessListService()
    private init() {}

    func addListenerForUserUpdates(completion: @escaping (Result<[User], Error>) -> Void) {
        db.collection("access-list").addSnapshotListener { snapshot, error in
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

    func deleteUserFromAuthenticationAsAdmin(id: String) {
        guard let url = URL(string: "http://localhost:3000/deleteUser/\(id)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("User deleted successfully.")
            } else {
                print("Failed to delete user.")
            }
        }.resume()
    }

    func deleteRequest(id: String) async throws {
        do {
            let userRef = db.collection("access-list").document(id)
            deleteUserFromAuthenticationAsAdmin(id: id)
            try await userRef.delete()
        } catch {
            throw error
        }
    }
}
