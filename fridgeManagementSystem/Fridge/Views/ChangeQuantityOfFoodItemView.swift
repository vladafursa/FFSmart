import SwiftUI
import Firebase
import FirebaseAuth

struct ChangeQuantityOfFoodItemView: View {
    @StateObject private var changeItemViewModel = ChangeQuantityOfFoodItemViewModel()
    var body: some View {
        VStack{
                  
            ForEach(changeItemViewModel.foodItems.indices, id: \.self) { index in
                          
                                    VStack{
                                        Text("\(changeItemViewModel.foodItems[index].name)")
                                        Text("\(formattedDate(for: changeItemViewModel.foodItems[index].expirationDate))")
                                        
                                        TextField("Quantity", value: $changeItemViewModel.foodItems[index].quantity, format: .number)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .padding()
                                            .keyboardType(.numberPad)
                                            .onChange(of: changeItemViewModel.foodItems[index].quantity) { oldValue, newValue in

                                                print("Quantity changed from \(oldValue) to \(newValue)")
                                                changeItemViewModel.updateItem(id: changeItemViewModel.foodItems[index].id, newQuantity: newValue)
                                            }
                                    }
                                    HStack{
                                        Button(action:{
                                            print("Accept tapped for \(changeItemViewModel.foodItems[index].id)")
                                            changeItemViewModel.deleteItem(id: changeItemViewModel.foodItems[index].id)
                                        }){
                                                                   Text("Remove")
                                                               }
                                                               .buttonStyle(BorderlessButtonStyle())
                                                               
                                                               Spacer()
                                        
                                        
                                        Button(action: {
                                            changeItemViewModel.foodItems[index].quantity -= 1
                                        }) {
                                            Text("-")
                                        }

                                        Spacer()
                                        
                                    Button(action: {
                                        changeItemViewModel.foodItems[index].quantity += 1
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
