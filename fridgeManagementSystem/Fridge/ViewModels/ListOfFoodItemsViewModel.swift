import Foundation
import Observation
import Firebase
class ListOfFoodItemsViewModel:ObservableObject{
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
    
    
    func formattedDate(for date: Date) -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "dd-MM-yyyy"
           return dateFormatter.string(from: date)
       }
    func sortFoodItemsByExpirationDate() {
            self.foodItems.sort { $0.expirationDate < $1.expirationDate }
        }
    func sortFoodItemsByAlphabet() {
            self.foodItems.sort { $0.name < $1.name }
        }
    
    func sortFoodItemsByQuantity() {
            self.foodItems.sort { $0.quantity < $1.quantity }
        }
    
}
    
