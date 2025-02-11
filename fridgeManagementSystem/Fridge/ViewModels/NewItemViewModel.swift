import Foundation
import Observation
import Firebase
class NewItemViewModel:ObservableObject{
    
    
    @Published var name: String = ""
    @Published var quantity:Int=0
    @Published var username: String = ""
    @Published var date=Date()

    func addItem(item:FoodItem){
        let db = Firestore.firestore();
        db.collection("food-items").document().setData(["name":item.name, "quantity":item.quantity, "expiration-date":item.expirationDate]);
        
    }
}
