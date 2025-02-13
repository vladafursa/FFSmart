import Foundation
import Observation
import Firebase
class ChangeQuantityOfFoodItemViewModel:ObservableObject{
    @Published var foodItems: [FoodItem] = []
    @Published var errorMessage: String?
    @Published var showErrorAlert: Bool = false
    
    func listenForFoodItemUpdates() {
        FoodItemService.shared.addListenerForFoodItemsUpdates() { [weak self] result in
            DispatchQueue.main.async {
                            switch result {
                            case .success(let items):
                                self?.foodItems = items
                                self?.errorMessage = nil
                                self?.showErrorAlert = false
                            case .failure(let error):
                                self?.errorMessage = "Failed to fetch food items: \(error.localizedDescription)"
                                self?.showErrorAlert = true
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
                    self.errorMessage=nil
                    self.showErrorAlert=false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error deleting item: \(error.localizedDescription)"
                    self.showErrorAlert=true
                }
            }
        }
    }
    
    
    func updateItem(id: String, newQuantity:Int) {
        Task{
            do {
                try await  FoodItemService.shared.updateItem(id: id, newQuantity: newQuantity)
                DispatchQueue.main.async {
                    self.errorMessage=nil
                    self.showErrorAlert=false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error updating item: \(error.localizedDescription)"
                    self.showErrorAlert=true
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


