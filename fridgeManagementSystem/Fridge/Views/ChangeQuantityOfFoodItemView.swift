import SwiftUI
import Firebase
import FirebaseAuth
import Foundation
struct ChangeQuantityOfFoodItemView: View {
    @StateObject private var changeItemViewModel = ChangeQuantityOfFoodItemViewModel()
    @StateObject private var logViewModel = LogHistoryViewModel()
    @State private var performedAction:String = ""
    var body: some View {
        VStack {
            ForEach($changeItemViewModel.foodItems) { $foodItem in
                VStack {
                    Text("\(foodItem.name)")
                    Text("\(formattedDate(for: foodItem.expirationDate))")
                    
                    TextField("Quantity", value: $foodItem.quantity, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .keyboardType(.numberPad)
                        .onChange(of: foodItem.quantity) { oldValue, newValue in
                            print("Quantity changed from \(oldValue) to \(newValue)")
                            changeItemViewModel.updateItem(id: foodItem.id, newQuantity: newValue)
                            
                            let difference = newValue - oldValue
                            let changedItem = FoodItem(id: foodItem.id, name: foodItem.name, quantity: abs(difference), expirationDate: foodItem.expirationDate)
                            if difference<0{
                                performedAction="removed"
                            }
                            else{
                                performedAction="inserted"
                            }
                        
                                                    logViewModel.addLogAfterDelay(item: changedItem, difference: difference, action: performedAction)
                        }
                }
                
                HStack {
                    Button(action: {
                        changeItemViewModel.deleteItem(id: foodItem.id)
                        logViewModel.addLog(item: foodItem, action: "deleted")
                    }) {
                        Text("Remove")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    
                    Spacer()
                    
                    Button(action: {
                        foodItem.quantity -= 1
                    }) {
                        Text("-")
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        foodItem.quantity += 1
                    }) {
                        Text("+")
                    }
                }
            }
        }
        .onAppear {
            changeItemViewModel.listenForFoodItemUpdates()
        }
    }
    
    func formattedDate(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    ChangeQuantityOfFoodItemView()
}
