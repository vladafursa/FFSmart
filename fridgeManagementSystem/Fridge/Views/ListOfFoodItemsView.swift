import SwiftUI
import Firebase


struct ListOfFoodItemsView: View {
    @State private var foodItems: [FoodItem] = []
    @StateObject private var listOfFoodItemsViewModel = ListOfFoodItemsViewModel()
    
    
    var body: some View {
        VStack{
            List(listOfFoodItemsViewModel.foodItems) { item in
                VStack(alignment: .leading) {
                    Text("Name: \(item.name)")
                    Text("Quantity: \(item.quantity)")
                    Text("Expiration Date: \(formattedDate(for: item.expirationDate))")
                }
            }
        }
        .onAppear {
            listOfFoodItemsViewModel.listenForFoodItemUpdates()
        }
        
    }
    
    func formattedDate(for date: Date) -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "dd-MM-yyyy"
           return dateFormatter.string(from: date)
       }
    
    
    
}

#Preview {
    ListOfFoodItemsView()
}
