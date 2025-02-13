import SwiftUI
import Firebase


struct ListOfFoodItemsView: View {
    @StateObject private var listOfFoodItemsViewModel = ListOfFoodItemsViewModel()
    
    
    var body: some View {
        
        ZStack{
            Color("BackgroundColor")
                                .edgesIgnoringSafeArea(.all)

            
        VStack{
            VStack {
                        Text("Food inventory")
                            .font(.largeTitle)
                            .foregroundColor(Color("TextColor"))
                            .bold()
                    }
            
            
            HStack(){
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
                .padding(8)
                .frame(maxWidth: 150)
                .foregroundColor(Color("TextColor"))
                .background(Color.white)
                .cornerRadius(5)
                .menuStyle(ButtonMenuStyle())
                .font(.title2)
                Spacer()
            }
            .padding(.horizontal, 22)
            .padding(.vertical)
            VStack(spacing:0){
                HStack {
                    Text("Name")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Quantity")
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text("Expiration date")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .foregroundColor(Color("TextColor"))
                .padding(.horizontal)
                .padding(.vertical, 8)
                .frame(maxWidth: 360)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.bottom, 0)
                    List(listOfFoodItemsViewModel.foodItems) { item in
                        HStack {
                            Text("\(item.name)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(item.quantity)")
                                .frame(maxWidth: .infinity, alignment: .center)
                            Text("\(listOfFoodItemsViewModel.formattedDate(for: item.expirationDate))")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    .foregroundColor(Color("TextColor"))
                    .padding(.top, 0)
                    .offset(y:-20)
                    .background(Color("BackgroundColor"))
                    .scrollContentBackground(.hidden)
                
            }
        }
    }
        .onAppear {
            listOfFoodItemsViewModel.listenForFoodItemUpdates()
        }
        .alert(isPresented: $listOfFoodItemsViewModel.showErrorAlert) {
            Alert(
                title: Text("Couldn't load items"),
                message: Text(listOfFoodItemsViewModel.errorMessage ?? "An unknown error occurred"),
                dismissButton: .default(Text("try again"))
            )
        }
        
    }
    
}

#Preview {
    ListOfFoodItemsView()
}
