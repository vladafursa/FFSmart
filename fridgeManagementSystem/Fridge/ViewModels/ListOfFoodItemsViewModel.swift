import Firebase
import Foundation
import Observation

class ListOfFoodItemsViewModel: ObservableObject {
    @Published var foodItems: [FoodItem] = []
    @Published var errorMessage: String?
    @Published var showErrorAlert: Bool = false
    private let foodItemService: FoodItemServiceProtocol

    init(foodItemService: FoodItemServiceProtocol = FoodItemService.shared) {
        self.foodItemService = foodItemService
    }

    func listenForFoodItemUpdates() {
        foodItemService.addListenerForFoodItemsUpdates { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(items):
                    self?.foodItems = items
                    print(" fetched items: \(self?.foodItems.count)")
                    self?.errorMessage = nil
                    self?.showErrorAlert = false
                case let .failure(error):
                    self?.errorMessage = "Failed to fetch food items: \(error.localizedDescription)"
                    self?.showErrorAlert = true
                    print("Error: \(error)")
                }
            }
        }
    }

    func formattedDate(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date)
    }

    func sortFoodItemsByExpirationDate() {
        foodItems.sort { $0.expirationDate < $1.expirationDate }
    }

    func sortFoodItemsByAlphabet() {
        foodItems.sort { $0.name < $1.name }
    }

    func sortFoodItemsByQuantity() {
        foodItems.sort { $0.quantity < $1.quantity }
    }
}
