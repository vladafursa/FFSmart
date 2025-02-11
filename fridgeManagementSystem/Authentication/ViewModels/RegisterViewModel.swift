import Foundation
import Observation
import Firebase
class RegisterViewModel:ObservableObject{
    
    func register(email:String, name:String, password:String, role:String){
        let db = Firestore.firestore();
        db.collection("requests").document().setData(["email":email, "name":name, "password":password, "role":role]);
    }
}
    
