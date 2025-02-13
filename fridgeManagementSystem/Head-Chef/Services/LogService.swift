import Firebase

final class LogService {
    private let db = Firestore.firestore()
    static let shared = LogService()
    private init() {}
    
    func addListenerForActionUpdates(completion: @escaping (Result<[Action], Error>) -> Void) {
        db.collection("log-history").addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }
            let actions: [Action] = documents.compactMap { document in
                let data = document.data()
                
                guard let username = data["username"] as? String,
                      let quantity = data["quantity"] as? Int,
                      let action = data["action"] as? String,
                      let name = data["what"] as? String,
                      let timestamp = data["when"] as? Timestamp else {
                    print("Missing required fields in document: \(document.documentID)")
                    return nil
                }
                
                let date = timestamp.dateValue()
                return Action(id: document.documentID,
                              username: username,
                              name: name, action: action,
                              quantity: quantity,
                              time: date)
            }
            completion(.success(actions))
        }
    }
    
    
    
    func findName(completion: @escaping (Result<String, Error>) -> Void) {
            guard let uid = AuthenticationService.shared.getCurrentUserUID() else {
                completion(.failure(NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "No user is currently logged in."])))
                return
            }

            let docRef = db.collection("access-list").document(uid)

            docRef.getDocument { (document, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let document = document, document.exists, let data = document.data(), let name = data["name"] as? String else {
                    completion(.failure(NSError(domain: "FirestoreError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Username not found."])))
                    return
                }

                completion(.success(name))
            }
        }

        func addLog(item: FoodItem, action: String, completion: @escaping (Result<Void, Error>) -> Void) {
            let currentDate = Date()

            findName { result in
                switch result {
                case .success(let username):
                    let actionData: [String: Any] = [
                        "username": username,
                        "action": action,
                        "quantity": item.quantity,
                        "what": item.name,
                        "when": currentDate
                    ]

                    self.db.collection("log-history").document().setData(actionData) { error in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(()))
                        }
                    }

                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    

}
