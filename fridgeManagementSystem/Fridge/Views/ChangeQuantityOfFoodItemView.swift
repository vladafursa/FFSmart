import SwiftUI
import Firebase
import FirebaseAuth
import Foundation
struct ChangeQuantityOfFoodItemView: View {
    @StateObject private var changeItemViewModel = ChangeQuantityOfFoodItemViewModel()
    @StateObject private var logViewModel = LogHistoryViewModel()
    @State private var performedAction:String = ""
    var body: some View {
        ZStack{
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
        ScrollView{
            VStack {
                                    Text("Modify inventory")
                                        .font(.largeTitle)
                                        .foregroundColor(Color("TextColor"))
                                        .bold()
                                }
                VStack {
                    ForEach($changeItemViewModel.foodItems) { $foodItem in
                        HStack {
                            VStack{
                                Text("\(foodItem.name)")
                                    .foregroundColor(Color("TextColor"))
                                Text("\(changeItemViewModel.formattedDate(for: foodItem.expirationDate))")
                                    .foregroundColor(Color("TextColor"))
                            }
                            HStack{
                                TextField("Quantity", value: $foodItem.quantity, format: .number)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .foregroundColor(Color("TextColor"))
                                    .padding()
                                    .frame(maxWidth: 100)
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
                                    foodItem.quantity += 1
                                }) {
                                    Text("+")

                                }
                                Spacer()
                                Button(action: {
                                    foodItem.quantity -= 1
                                }) {
                                    Text("-")
                                }
                                
                                Spacer()
                                Button(action: {
                                    changeItemViewModel.deleteItem(id: foodItem.id)
                                    logViewModel.addLog(item: foodItem, action: "deleted")
                                }) {
                                    Image(systemName:"trash.fill")
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                }
            
            }
        .padding()
        }
        .onAppear {
            changeItemViewModel.listenForFoodItemUpdates()
        }
        .alert(isPresented: $changeItemViewModel.showErrorAlert) {
            Alert(
                title: Text("Couldn't perform changes"),
                message: Text(changeItemViewModel.errorMessage ?? "An unknown error occurred"),
                dismissButton: .default(Text("try again"))
            )
        }
    }
    
    
}

#Preview {
    ChangeQuantityOfFoodItemView()
}
