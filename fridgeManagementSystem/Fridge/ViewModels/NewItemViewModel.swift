import Foundation
import Observation
import Firebase

enum itemFormError: Error {
    case alreadyExistItem
    case emptyField
    case invalidValue
    
    var localisedDescription: String {
        switch self {
        case .alreadyExistItem:
            return "Same item already exists: either change quality of it or provide another name"
        case .invalidValue:
            return "quality should be a number"
        case .emptyField:
            return "All fields should be filled"
        }
    }
}


class NewItemViewModel:ObservableObject{
    @Published var name: String = ""
    @Published var quantity:Int=0
    @Published var username: String = ""
    @Published var date=Date()
    @Published var showAlert = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var dismissMessage: String = ""
    func addItem(item:FoodItem){
        let db = Firestore.firestore();
        db.collection("food-items").document().setData(["name":item.name, "quantity":item.quantity, "expiration-date":item.expirationDate]);
        
    }
    
    func validateForm() throws{
        if name.isEmpty || String(quantity).isEmpty{
            throw itemFormError.emptyField
        }
    }
    
    /*func validateForm() throws{
            if email.isEmpty || name.isEmpty || password.isEmpty || repeatedPassword.isEmpty || role.isEmpty{
                throw formError.emptyField
            }
            else if !isValidEmail(email){
                throw formError.invalidEmail
            }
            else if password.count < 6{
                throw formError.shortPassword
            }
            else if password != repeatedPassword{
                throw formError.differentRepeatPassword
            }
        }
    */
    
    func addNewItem(){
        Task{
            do{
                try await FoodItemService.shared.addItem(item: FoodItem(id:UUID().uuidString, name: name, quantity: quantity, expirationDate: date))
                DispatchQueue.main.async {
                                   self.showSuccessAlert()
                               }
            }
            catch{
                
            }
        }
    }
    
    
    func showSuccessAlert(){
            self.alertTitle = "Item was added successfully"
            self.alertMessage = "You added a new item"
            self.showAlert = true
            self.dismissMessage = "OK"
        }
       
        func showErrorAlert(message: String){
            self.alertTitle = "Unsuccessful registration"
            self.alertMessage = message
            self.showAlert = true
            self.dismissMessage = "try again"
        }
    
}
