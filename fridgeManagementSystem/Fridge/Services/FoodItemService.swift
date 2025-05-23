import Firebase

enum itemError: Error {
    case sameItemAlreadyExists
    var localisedDescription: String {
        switch self {
        case .sameItemAlreadyExists:
            return "Same item already exists: either change the quality or provide a new name"
        }
    }
}

protocol FoodItemServiceProtocol {
    func addListenerForFoodItemsUpdates(completion: @escaping (Result<[FoodItem], Error>) -> Void)
    func addItem(item: FoodItem) async throws
    func checkIfFoodItemExists(name: String, expirationDate: Date) async throws -> Bool
    func deleteItem(id: String) async throws
    func updateItem(id: String, newQuantity: Int) async throws
}

final class FoodItemService: FoodItemServiceProtocol {
    private let database = Firestore.firestore()
    static let shared = FoodItemService()
    private init() {}

    func addListenerForFoodItemsUpdates(completion: @escaping (Result<[FoodItem], Error>) -> Void) {
        database.collection("food-items").addSnapshotListener { snapshot, error in
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

    func addItem(item: FoodItem) async throws {
        do {
            let exists = try await checkIfFoodItemExists(name: item.name, expirationDate: item.expirationDate)
            if exists {
                throw itemError.sameItemAlreadyExists
            } else {
                try await database.collection("food-items").document().setData(["name": item.name, "quantity": item.quantity, "expiration-date": item.expirationDate])
            }
        } catch {
            throw error
        }
    }

    func checkIfFoodItemExists(name: String, expirationDate: Date) async throws -> Bool {
        let query =
            database.collection("food-items")
                .whereField("name", isEqualTo: name)
                .whereField("expiration-date", isEqualTo: expirationDate)
        do {
            let snapshot = try await query.getDocuments()
            return !snapshot.documents.isEmpty
        } catch {
            return false
        }
    }

    func deleteItem(id: String) async throws {
        do {
            let itemRef = database.collection("food-items").document(id)
            try await itemRef.delete()
        } catch {
            throw error
        }
    }

    func updateItem(id: String, newQuantity: Int) async throws {
        do {
            let itemRef = database.collection("food-items").document(id)
            try await itemRef.updateData([
                "quantity": newQuantity,
            ])
        } catch {
            throw error
        }
    }
}
