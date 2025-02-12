import Foundation
import Observation
import Firebase
class RegisterViewModel:ObservableObject{
    @Published var email: String = ""
    @Published var name: String = ""
    @Published var password: String = ""
    @Published var repeatedPassword: String = ""
    @Published var role: String = ""
    func register(email:String, name:String, password:String, role:String){
        let db = Firestore.firestore();
        db.collection("requests").document().setData(["email":email, "name":name, "password":password, "role":role]);
    }
}
    
