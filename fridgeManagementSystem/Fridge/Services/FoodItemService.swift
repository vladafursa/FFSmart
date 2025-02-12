import Firebase
final class FoodItemService {
    private let db = Firestore.firestore()
    static let shared = FoodItemService()
    private init() {}
    
    func addListenerForFoodItemsUpdates(completion: @escaping (Result<[FoodItem], Error>) -> Void) {
        db.collection("food-items").addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }
                let items: [FoodItem] = documents.map { document in
                let data = document.data()
                let name = data["name"] as! String
                let quantity = data["quantity"] as! Int
                let expirationDateTimestamp = data["expiration-date"] as! Timestamp
                let expirationDate = expirationDateTimestamp.dateValue()
                
                return FoodItem(id: document.documentID, name: name, quantity: quantity, expirationDate: expirationDate)
            }
            completion(.success(items))
        }
    }
    
    
    
}
