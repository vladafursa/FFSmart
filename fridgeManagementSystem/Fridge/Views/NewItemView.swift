import SwiftUI
import Firebase
import Foundation
import FirebaseAuth
struct NewItemView: View {
    @StateObject private var newItemViewModel = NewItemViewModel()
    @StateObject private var logViewModel = LogHistoryViewModel()
    var body: some View {
        ZStack{
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            
            
                 VStack{
                            Text("New item")
                                .font(.largeTitle)
                                .foregroundColor(Color("TextColor"))
                                .bold()
                                .padding()
                            Spacer()
                        }
            
            VStack{
                HStack{
                    Text("Name")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color("TextColor"))
                        .font(.title2)
                    TextField(
                        "name",
                        text: $newItemViewModel.name
                        
                    )
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .font(.title2)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                }
                HStack{
                    Text("quantity")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color("TextColor"))
                        .font(.title2)
                    TextField("quantity", value: $newItemViewModel.quantity, format: .number)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                        .font(.title2)
                        .keyboardType(.numberPad)
                }
                HStack{
                    Text("Expiration date")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color("TextColor"))
                        .font(.title2)
                    DatePicker("", selection: $newItemViewModel.date, displayedComponents: .date)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .labelsHidden()
                        .datePickerStyle(.compact)
                }
                Button(action: {
                    let item =  FoodItem(id:UUID().uuidString, name:self.newItemViewModel.name,quantity:self.newItemViewModel.quantity, expirationDate: self.newItemViewModel.date)
                    
                    newItemViewModel.addNewItem()
                    logViewModel.addLog(item: item, action: "added")
                    
                }){
                    Text("Save")
                }
                .font(.title2)
                .foregroundColor(.white)
                .bold()
                .padding(10)
                .frame(maxWidth: 120)
                .background(Color("ButtonColor"))
                .cornerRadius(5)
                .padding(20)
            }
            .padding()
                                    .frame(width: 380, height: 350)
                                    
            
            
        }
        .alert(isPresented: $newItemViewModel.showAlert) {
                    Alert(
                        title: Text(newItemViewModel.alertTitle),
                        message: Text(newItemViewModel.alertMessage),
                        dismissButton: .default(Text(newItemViewModel.dismissMessage))
                    )
                }
    }
}
    

#Preview {
    NewItemView()
}
