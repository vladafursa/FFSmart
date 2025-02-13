import SwiftUI

struct HomeView: View {
    var role:String
    var body: some View {
        TabView {
                    ListOfFoodItemsView()
                        .tabItem {
                            Label("Main", systemImage: "list.number")
                        }
                        .foregroundColor(Color("TextColor"))
                    NewItemView()
                        .tabItem {
                            Label("Add", systemImage: "plus.circle")
                        }
                        .foregroundColor(Color("TextColor"))
                    ChangeQuantityOfFoodItemView()
                        .tabItem {
                            Label("Modify", systemImage: "square.and.pencil")
                        }
                        .foregroundColor(Color("TextColor"))
                    if role=="head-chef"{
                        LogHistoryView()
                            .tabItem {
                                Label("Log", systemImage: "text.document")
                            }
                            .foregroundColor(Color("TextColor"))
                    }
                    
                    
                }
    }
}

#Preview {
    HomeView(role:"head-chef")
}
