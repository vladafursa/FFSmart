import SwiftUI
import Firebase
import Foundation
import FirebaseAuth
struct NewItemView: View {
    @StateObject private var newItemViewModel = NewItemViewModel()
    @StateObject private var logViewModel = LogHistoryViewModel()
    var body: some View {
        
        VStack{
            TextField(
                "name",
                text: $newItemViewModel.name
                
            )
            .font(.title2)
            .disableAutocorrection(true)
            .padding()
            
            TextField("quantity", value: $newItemViewModel.quantity, format: .number)
                .textFieldStyle(.roundedBorder)
                .padding()
                .font(.title2)
            
            DatePicker("", selection: $newItemViewModel.date, displayedComponents: .date)
                .labelsHidden()
                .datePickerStyle(.compact)
            
            Button("Save") {
              
                let item =  FoodItem(id:UUID().uuidString, name:self.newItemViewModel.name,quantity:self.newItemViewModel.quantity, expirationDate: self.newItemViewModel.date)
                
                newItemViewModel.addItem(item: item)
                logViewModel.addLog(item: item, action: "added")
              
               
            }
        }
        
    }
    
    
    
    
    
    
    
   
   
       
    }
    
    


    
    
    

#Preview {
    NewItemView()
}
