import SwiftUI
import Firebase

class AccessListViewModel: ObservableObject{
    @Published var users: [User] = []
    @Published var errorMessage: String?
    private let db = Firestore.firestore()
    
    let ACCESS_LIST_COLLECTION_NAME: String = "access-list"
    
    
    func listenForAccessListUpdates() {
                AccessListService.shared.addListenerForUserUpdates() { [weak self] result in
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
    
    
    
    
    func deleteRequest(id: String) {
            Task {
                do {
                    
                    try await AccessListService.shared.deleteRequest(id: id)
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
    
}
