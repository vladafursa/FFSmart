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
                    
                    // Debugging output for document data
                    print("Document Data: \(data)")
                    
                    guard let username = data["username"] as? String,
                          let quantity = data["quantity"] as? Int,
                          let action = data["action"] as? String, // Assuming you have an "action" field
                          let name = data["what"] as? String else {
                        print("Missing required fields in document: \(document.documentID)")
                        return nil // Return nil if fields are missing, this will skip the document
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
}
