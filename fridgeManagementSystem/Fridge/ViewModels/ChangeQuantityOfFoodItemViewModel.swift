import Foundation
import Observation
import Firebase
class ChangeQuantityOfFoodItemViewModel:ObservableObject{
    @Published var foodItems: [FoodItem] = []
    
    func listenForFoodItemUpdates() {
        let db = Firestore.firestore()
        
        db.collection("food-items").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            DispatchQueue.main.async {
                self.foodItems = documents.compactMap { document in
                    let data = document.data()
                    guard let name = data["name"] as? String,
                          let quantity = data["quantity"] as? Int,
                          let expirationDateTimestamp = data["expiration-date"] as? Timestamp else {
                        return nil
                    }
                    
                    
                    let expirationDate = expirationDateTimestamp.dateValue()
                    
                    return FoodItem(id: document.documentID, name: name, quantity: quantity, expirationDate: expirationDate)
                }
            }
        }
    }
    
    
    
    
    func deleteItem(id: String) {
        let db = Firestore.firestore()
        
        let itemRef = db.collection("food-items").document(id)
        
        itemRef.delete { error in
            if let error = error {
                print("Error deleting item: \(error)")
            } else {
                print("User deleted successfully")
                self.foodItems.removeAll { $0.id == id }
            }
        }
    }
    
    
    func updateItem(id: String, newQuantity:Int) {
        let db = Firestore.firestore()
        
        let itemRef = db.collection("food-items").document(id)
        itemRef.updateData([
            "quantity": newQuantity
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated!")
            }
            
        }
    }
    
    
    
    
}


