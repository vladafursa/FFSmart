import Firebase
import Foundation
import Observation

enum itemFormError: Error {
    case emptyField
    case invalidNumber
    var localisedDescription: String {
        switch self {
        case .emptyField:
            return "All fields should be filled"
        case .invalidNumber:
            return "provide number that is greater than zero"
        }
    }
}

class NewItemViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var quantity: Int = 0
    @Published var username: String = ""
    @Published var date = Date()
    @Published var showAlert = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String?
    @Published var dismissMessage: String = ""

    func validateForm() throws {
        if name.isEmpty || String(quantity).isEmpty {
            throw itemFormError.emptyField
        } else if quantity <= 0 {
            throw itemFormError.invalidNumber
        }
    }

    func addNewItem() {
        Task {
            do {
                try await FoodItemService.shared.addItem(item: FoodItem(id: UUID().uuidString, name: name, quantity: quantity, expirationDate: date))
                DispatchQueue.main.async {
                    self.showSuccessAlert()
                }
            } catch let error as itemFormError {
                DispatchQueue.main.async {
                    self.alertMessage = error.localisedDescription
                    self.showErrorAlert(message: self.alertMessage!)
                }
            } catch let error as itemError {
                DispatchQueue.main.async {
                    self.alertMessage = error.localisedDescription
                    self.showErrorAlert(message: self.alertMessage!)
                }
            } catch {
                DispatchQueue.main.async {
                    self.alertMessage = error.localizedDescription
                    self.showErrorAlert(message: self.alertMessage ?? "Unknown error occured")
                }
            }
        }
    }

    func showSuccessAlert() {
        alertTitle = "Item was added successfully"
        alertMessage = "You added a new item"
        showAlert = true
        dismissMessage = "OK"
    }

    func showErrorAlert(message: String) {
        alertTitle = "Couldn't add an item"
        alertMessage = message
        showAlert = true
        dismissMessage = "try again"
    }

    func setMidnightDate(_ date: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        if let midnightDate = calendar.date(from: components) {
            self.date = midnightDate
        }
    }
}
