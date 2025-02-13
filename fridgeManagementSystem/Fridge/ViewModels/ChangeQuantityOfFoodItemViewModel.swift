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
        Task{
            do {
                try await  FoodItemService.shared.deleteItem(id: id)
                DispatchQueue.main.async {
                    self.foodItems.removeAll { $0.id == id }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error deleting item: \(error.localizedDescription)"
                }
            }
        }
    }
    
    
    func updateItem(id: String, newQuantity:Int) {
        Task{
            do {
                try await  FoodItemService.shared.updateItem(id: id, newQuantity: newQuantity)
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error deleting item: \(error.localizedDescription)"
                }
            }
        }
    }
    
    
    
    
}


