import SwiftUI
import Firebase
import FirebaseAuth
class RequestsViewModel: ObservableObject{
    @Published var users: [User] = []
     
    private let db = Firestore.firestore()
    
    func deleteRequest(id: String) {
        let db = Firestore.firestore()
        
        let userRef = db.collection("requests").document(id)
        
        
        userRef.delete { error in
            if let error = error {
                print("Error deleting user: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.users.removeAll { $0.id == id }
                    print("User deleted successfully")
                }
            }
        }
    }
    let REQUESTS_COLLECTION_NAME: String = "requests"
    
    
    func listenForRequestsUpdates(){
        listenForUserUpdates(collectionName: REQUESTS_COLLECTION_NAME)
    }
   
    func listenForUserUpdates(collectionName: String) {
        db.collection(collectionName).addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            self.users = documents.compactMap { document in
                let data = document.data()
                print("Document Data: \(data)")
                guard let name = data["name"] as? String,
                      let email = data["email"] as? String,
                      let password = data["password"] as? String,
                      let role = data["role"] as? String else {
                    return nil
                }
                return User(id: document.documentID, email: email, name: name, password: password, role: role)
            }
        }
    }
    
    func acceptRequest(id: String) {
            let db = Firestore.firestore()
            let sourceDocumentRef = db.collection("requests").document(id)

            sourceDocumentRef.getDocument { (documentSnapshot, error) in
                if let error = error {
                    print("Error fetching document: \(error)")
                    return
                }

                guard let documentSnapshot = documentSnapshot,
                      documentSnapshot.exists,
                      let data = documentSnapshot.data(),
                      let email = data["email"] as? String,
                      let password = data["password"] as? String else {
                    print("Document not found or missing fields.")
                    return
                }
                
                Auth.auth().createUser(withEmail: email, password: password) { authResult, authError in
                                if let authError = authError {
                                    print("Error creating Auth user: \(authError.localizedDescription)")
                                    return
                                }

                                guard let uid = authResult?.user.uid else {
                                    print("Failed to get user UID.")
                                    return
                                }

                   
                                var userData = data
                                userData["uid"] = uid

                                db.collection("access-list").document(uid).setData(userData, merge: true) { error in
                                    if let error = error {
                                        print("Error copying document to access-list: \(error)")
                                    } else {
                                        print("Document successfully copied to access-list.")
                                        self.deleteRequest(id: id)
                                    }
                                }
                            }
                        }
                    }
    
    
    
}
