import Firebase
import Foundation
import Observation

class ChangeQuantityOfFoodItemViewModel: ObservableObject {
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

    func deleteItem(id: String) {
        Task {
            do {
                try await foodItemService.deleteItem(id: id)
                DispatchQueue.main.async {
                    self.foodItems.removeAll { $0.id == id }
                    self.errorMessage = nil
                    self.showErrorAlert = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error deleting item: \(error.localizedDescription)"
                    self.showErrorAlert = true
                }
            }
        }
    }

    func updateItem(id: String, newQuantity: Int) {
        Task {
            do {
                try await foodItemService.updateItem(id: id, newQuantity: newQuantity)
                DispatchQueue.main.async {
                    self.errorMessage = nil
                    self.showErrorAlert = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error updating item: \(error.localizedDescription)"
                    self.showErrorAlert = true
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
