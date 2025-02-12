import Foundation
import Observation
import Firebase
class ChangeQuantityOfFoodItemViewModel:ObservableObject{
    @Published var foodItems: [FoodItem] = []
    @Published var errorMessage: String?
    
    func listenForFoodItemUpdates() {
        FoodItemService.shared.addListenerForFoodItemsUpdates() { [weak self] result in
            DispatchQueue.main.async {
                            switch result {
                            case .success(let items):
                                self?.foodItems = items
                            case .failure(let error):
                                self?.errorMessage = "Failed to fetch food items: \(error.localizedDescription)"
                                print("Error: \(error)")
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


