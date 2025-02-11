import SwiftUI
import Firebase


struct ListOfFoodItemsView: View {
    @StateObject private var listOfFoodItemsViewModel = ListOfFoodItemsViewModel()
    
    
    var body: some View {
        VStack{
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
