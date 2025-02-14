import Firebase
import FirebaseAuth
import SwiftUI

class RequestsViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var errorMessage: String?
    @Published var showErrorAlert: Bool = false

    private let db = Firestore.firestore()

    func deleteRequest(id: String) {
        Task {
            do {
                try await RequestsService.shared.deleteRequest(id: id)
                DispatchQueue.main.async {
                    self.users.removeAll { $0.id == id }
                    self.errorMessage = nil
                    self.showErrorAlert = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error deleting request: \(error.localizedDescription)"
                    self.showErrorAlert = true
                }
            }
        }
    }

    func listenForRequestsUpdates() {
        RequestsService.shared.addListenerForUserUpdates { [weak self] result in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                switch result {
                case let .success(users):
                    strongSelf.users = users
                    strongSelf.errorMessage = nil
                    strongSelf.showErrorAlert = false
                case let .failure(error):
                    strongSelf.errorMessage = "Failed to fetch requests: \(error.localizedDescription)"
                    strongSelf.showErrorAlert = true
                    print("Error: \(error)")
                }
            }
        }
    }

    func acceptRequest(id: String) {
        Task {
            do {
                try await RequestsService.shared.acceptRequest(id: id)

                DispatchQueue.main.async {
                    self.users.removeAll { $0.id == id }
                    print("User successfully accepted and removed from requests.")
                    self.errorMessage = nil
                    self.showErrorAlert = false
                }

            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error processing request: \(error.localizedDescription)"
                    self.showErrorAlert = true
                }
            }
        }
    }
}
