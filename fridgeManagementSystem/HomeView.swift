import SwiftUI

struct HomeView: View {
    var role:String
    var body: some View {
        TabView {
                    ListOfFoodItemsView()
                        .tabItem {
                            Label("Tab 1", systemImage: "1.square.fill")
                        }
                    NewItemView()
                        .tabItem {
                            Label("Tab 2", systemImage: "2.square.fill")
                        }
                    ChangeQuantityOfFoodItemView()
                        .tabItem {
                            Label("Tab 3", systemImage: "3.square.fill")
                        }
                    
                    if role=="head-chef"{
                        LogHistoryView()
                            .tabItem {
                                Label("Tab 4", systemImage: "4.square.fill")
                            }
                    }
                    
                    
                }
    }
}

#Preview {
    HomeView(role:"head-chef")
}
