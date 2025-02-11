import Foundation
import Observation
import Firebase
class LogHistoryViewModel:ObservableObject{
    @Published var Actions: [Action] = []
    
    func listenForActionUpdates() {
        let db = Firestore.firestore()
        
        db.collection("log-history").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            DispatchQueue.main.async {
                self.Actions = documents.compactMap { document -> Action? in
                    let data = document.data()
                    
                 
                    print("Document Data: \(data)")
                    
                    guard let username = data["username"] as? String,
                          let quantity = data["quantity"] as? Int,
                          let action = data["action"] as? String,
                          let name = data["what"] as? String else {
                        print("Missing required fields in document: \(document.documentID)")
                        return nil
                    }
                    
                    if let timestamp = data["when"] as? Timestamp {
                        let date = timestamp.dateValue() // Convert FIRTimestamp to Date
                        print("Extracted date: \(date)")
                        
                        // Return the Action object with valid data
                        return Action(id: document.documentID,
                                      username: username,
                                      name: name, action: action,
                                      quantity: quantity,
                                      time: date) // Use the extracted date
                    } else {
                        print("Missing timestamp in document: \(document.documentID)")
                        return nil // Skip if timestamp is missing
                    }
                }
                if self.Actions.isEmpty {
                    print("No actions found.")
                } else {
                    print("Actions loaded: \(self.Actions.count)")
                }
            }
        }
        
        
    }
    
    
    
    
    
    func findName(completion: @escaping (String?) -> Void) {
        guard let uid = AuthenticationService.shared.getCurrentUserUID() else {
            print("No user is currently logged in.")
            completion(nil)
            return
        }
        
        let db = Firestore.firestore()
        let docRef = db.collection("access-list").document(uid)
        
        docRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching document: \(error)")
                completion(nil)
                return
            }
            
            guard let document = document, document.exists else {
                print("Document does not exist")
                completion(nil)
                return
            }
            
            if let data = document.data(), let name = data["name"] as? String {
                completion(name)
            } else {
                print("Name not found")
                completion(nil)
            }
        }
    }
    
    
    
    
    func addLog(item:FoodItem, action:String){
            let db = Firestore.firestore();
            let currentDate=Date()
            findName { name in
                if let username = name {
                    let action = Action(id:UUID().uuidString, username:username, name:item.name, action:action, quantity:item.quantity, time:currentDate)
                    db.collection("log-history").document().setData(["username":action.username,"action":action.action,"quantity":action.quantity,"what":action.name, "when":action.time]);
                } else {
                    print("Name not found or error occurred")
                }
            }
           
        }
}
