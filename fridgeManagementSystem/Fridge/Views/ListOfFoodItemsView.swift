import SwiftUI
import Firebase


struct ListOfFoodItemsView: View {
    @StateObject private var listOfFoodItemsViewModel = ListOfFoodItemsViewModel()
    
    
    var body: some View {
        VStack{
            
            Menu {
                Button {
                    listOfFoodItemsViewModel.sortFoodItemsByExpirationDate()
                } label: {
                    Text("by expiration date")
                }
                Button {
                    listOfFoodItemsViewModel.sortFoodItemsByAlphabet()
                } label: {
                    Text("by alphabet")
                    
                }
                Button {
                    listOfFoodItemsViewModel.sortFoodItemsByQuantity()
                } label: {
                    Text("by quantity")
                }
            } label: {
                HStack {
                                               Text("Sort by")
                                                   .foregroundColor(.gray)
                                               Spacer()
                                               Image(systemName: "chevron.down")
                                           }
                 
            }
            .foregroundColor(.gray)
                                    .padding(6)
                                    .frame(maxWidth: 300)
                                    .foregroundColor(Color("TextColor"))
                                    .background(Color.white)
                                    .cornerRadius(5)
                                    .menuStyle(ButtonMenuStyle())
                                    .font(.title2)
            List(listOfFoodItemsViewModel.foodItems) { item in
                VStack(alignment: .leading) {
                    Text("Name: \(item.name)")
                    Text("Quantity: \(item.quantity)")
                    Text("Expiration Date: \(listOfFoodItemsViewModel.formattedDate(for: item.expirationDate))")
                }
            }
            
        }
        .onAppear {
            listOfFoodItemsViewModel.listenForFoodItemUpdates()
        }
        
    }
    
}

#Preview {
    ListOfFoodItemsView()
}
