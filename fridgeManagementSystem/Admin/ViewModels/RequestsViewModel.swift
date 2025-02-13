import SwiftUI
import Firebase
import FirebaseAuth
class RequestsViewModel: ObservableObject{
    @Published var users: [User] = []
    @Published var errorMessage: String?
    private let db = Firestore.firestore()
    
  
    func deleteRequest(id: String){
        Task{
            do {
                try await  RequestsService.shared.deleteRequest(id: id)
                DispatchQueue.main.async {
                    self.users.removeAll { $0.id == id }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error deleting item: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func listenForRequestsUpdates() {
            RequestsService.shared.addListenerForUserUpdates() { [weak self] result in
                DispatchQueue.main.async {
                                switch result {
                                case .success(let users):
                                    self?.users = users
                                case .failure(let error):
                                    self?.errorMessage = "Failed to fetch food items: \(error.localizedDescription)"
                                    print("Error: \(error)")
                                }
                    }
            }
        }
        
    
    func acceptRequest(id: String) {
        Task {
            do {
                // Call the service's acceptRequest function
                try await RequestsService.shared.acceptRequest(id: id)
                
                // Optionally, update the UI on success
                DispatchQueue.main.async {
                    self.users.removeAll { $0.id == id }
                    print("User successfully accepted and removed from requests.")
                }

            } catch {
                // Handle any errors
                DispatchQueue.main.async {
                    self.errorMessage = "Error processing request: \(error.localizedDescription)"
                }
            }
        }
    }

    
    
    
}
