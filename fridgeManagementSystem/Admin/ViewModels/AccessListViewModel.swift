import Firebase
import SwiftUI

class AccessListViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var errorMessage: String?
    @Published var showErrorAlert: Bool = false

    func listenForAccessListUpdates() {
        AccessListService.shared.addListenerForUserUpdates { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(users):
                    self?.users = users
                    self?.errorMessage = nil
                    self?.showErrorAlert = false
                case let .failure(error):
                    self?.errorMessage = "Failed to fetch access list: \(error.localizedDescription)"
                    self!.showErrorAlert = true
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
                    self.errorMessage = nil
                    self.showErrorAlert = false
                }

            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error deleting user: \(error.localizedDescription)"
                    self.showErrorAlert = false
                }
            }
        }
    }
}
