import Foundation
import Observation
import Firebase
class ListOfFoodItemsViewModel:ObservableObject{
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
    
    
    func formattedDate(for date: Date) -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "dd-MM-yyyy"
           return dateFormatter.string(from: date)
       }
    
}
    
