import SwiftUI
import Firebase

class AccessListViewModel: ObservableObject{
    @Published var users: [User] = []
     
    private let db = Firestore.firestore()
    
    let ACCESS_LIST_COLLECTION_NAME: String = "access-list"
    
    
    func listenForAccessListUpdates(){
        listenForUserUpdates(collectionName: ACCESS_LIST_COLLECTION_NAME)
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
    
    func deleteUserFromAuthenticationAsAdmin(id: String){
        
        guard let url = URL(string: "http://localhost:3000/deleteUser/\(id)") else { return }

           var request = URLRequest(url: url)
           request.httpMethod = "DELETE"

           URLSession.shared.dataTask(with: request) { data, response, error in
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
    
    
    
    func deleteUser(id: String) {
           let userRef = db.collection("access-list").document(id)
        deleteUserFromAuthenticationAsAdmin(id: id)
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
}
