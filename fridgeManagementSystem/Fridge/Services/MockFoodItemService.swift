import Foundation

class MockFoodItemService: FoodItemServiceProtocol {
    var items: [FoodItem] = []
    var mockResult: Result<[FoodItem], Error>?
    private var completion: ((Result<[FoodItem], Error>) -> Void)?
    var shouldThrowErrorOnAddItem = false
    var shouldThrowErrorOnCheckIfExists = false
    var mockFoodItem: FoodItem? // Holds a mock food item for testing
    func addListenerForFoodItemsUpdates(completion: @escaping (Result<[FoodItem], Error>) -> Void) {
        self.completion = completion
    }

    func triggerUpdate() {
        if let result = mockResult {
            completion?(result)
        }
    }

    func addItem(item: FoodItem) async throws {
        if shouldThrowErrorOnAddItem {
            throw itemError.sameItemAlreadyExists
        } else {
            mockFoodItem = item
        }
    }

    func checkIfFoodItemExists(name: String, expirationDate: Date) async throws -> Bool {
        if shouldThrowErrorOnCheckIfExists {
            throw itemError.sameItemAlreadyExists
        }
        return mockFoodItem?.name == name && mockFoodItem?.expirationDate == expirationDate
    }

    func deleteItem(id _: String) async throws {
        // Not needed in these tests
    }

    func updateItem(id _: String, newQuantity _: Int) async throws {
        // Not needed in these tests
    }
}
