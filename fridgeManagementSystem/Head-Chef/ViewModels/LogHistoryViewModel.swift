import Firebase
import Foundation
import Observation

class LogHistoryViewModel: ObservableObject {
    @Published var Actions: [Action] = []
    @Published var errorMessage: String?
    @Published var showErrorAlert: Bool = false
    func listenForNewActionUpdates() {
        LogService.shared.addListenerForActionUpdates { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(items):
                    self?.Actions = items
                    self!.errorMessage = nil
                    self!.showErrorAlert = false
                case let .failure(error):
                    self?.errorMessage = "Failed to fetch actions: \(error.localizedDescription)"
                    self!.showErrorAlert = true
                    print("Error: \(error)")
                }
            }
        }
    }

    private var logWorkItem: DispatchWorkItem?
    private var accumulatedDifferences: [String: Int] = [:]

    func addLogAfterDelay(item: FoodItem, difference: Int, action: String, delay: TimeInterval = 1.0) {
        print("Scheduling log for item: \(item.name), action: \(action), with delay: \(delay) seconds")

        logWorkItem?.cancel()

        if let currentDifference = accumulatedDifferences[item.id] {
            accumulatedDifferences[item.id] = currentDifference + difference
        } else {
            accumulatedDifferences[item.id] = difference
        }

        logWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            if let finalDifference = self.accumulatedDifferences[item.id] {
                let updatedItem = FoodItem(id: item.id, name: item.name, quantity: abs(finalDifference), expirationDate: item.expirationDate)
                let finalAction = finalDifference < 0 ? "removed" : "inserted"
                self.addLog(item: updatedItem, action: finalAction)

                self.accumulatedDifferences[item.id] = nil
            }
        }

        if let logWorkItem = logWorkItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: logWorkItem)
        } else {
            print("Failed to create DispatchWorkItem")
        }
    }

    func addLog(item: FoodItem, action: String) {
        LogService.shared.addLog(item: item, action: action) { result in
            switch result {
            case .success:
                print("Log successfully added!")
            case let .failure(error):
                print("Error adding log: \(error.localizedDescription)")
            }
        }
    }

    func formattedDate(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }
}
