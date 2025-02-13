import SwiftUI
import Firebase


struct LogHistoryView: View {
    @State private var Actions: [Action] = []
    @StateObject private var logHistoryViewModel = LogHistoryViewModel()
    var body: some View {
        ZStack{
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            VStack{
                VStack {
                    Text("Log history")
                        .font(.largeTitle)
                        .foregroundColor(Color("TextColor"))
                        .bold()
                }
                
                VStack{
                    List(logHistoryViewModel.Actions) { action in
                        VStack(alignment: .leading) {
                            Text("\(action.username) \(action.action) \(action.quantity) \(action.name) \(logHistoryViewModel.formattedDate(for:action.time))")
                        }
                        .listRowBackground(Color.clear)
                    }
                    .foregroundColor(Color("TextColor"))
                    .background(Color("BackgroundColor"))
                    .scrollContentBackground(.hidden)
                }
                
            }
        }
        .onAppear {
           logHistoryViewModel.listenForNewActionUpdates()
       }
        .alert(isPresented: $logHistoryViewModel.showErrorAlert) {
            Alert(
                title: Text("Can't show logs"),
                message: Text(logHistoryViewModel.errorMessage ?? "An unknown error occurred"),
                dismissButton: .default(Text("try again"))
            )
        }
    }
}

#Preview {
    LogHistoryView()
}
