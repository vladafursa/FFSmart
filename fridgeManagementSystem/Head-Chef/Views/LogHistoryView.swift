import SwiftUI
import Firebase


struct LogHistoryView: View {
    @State private var Actions: [Action] = []
    @StateObject private var logHistoryViewModel = LogHistoryViewModel()
    var body: some View {
        VStack{
            List(logHistoryViewModel.Actions) { action in
                VStack(alignment: .leading) {
                    Text("\(action.username) \(action.action) \(action.quantity) \(action.name) \(action.time)")
                    
                   
                }
            }
        }
        .onAppear {
           logHistoryViewModel.listenForActionUpdates()
       }
    }
}

#Preview {
    LogHistoryView()
}
