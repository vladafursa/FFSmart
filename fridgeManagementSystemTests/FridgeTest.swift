@testable import fridgeManagementSystem
import XCTest

final class FridgeTest: XCTestCase {
    var viewModel: ListOfFoodItemsViewModel!
    var mockService: MockFoodItemService!

    override func setUp() {
        super.setUp()
        mockService = MockFoodItemService()
        viewModel = ListOfFoodItemsViewModel(foodItemService: mockService)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testFoodItemsFetchSuccess() {
        let foodItems = [FoodItem(id: "1", name: "Apple", quantity: 5, expirationDate: Date())]
        mockService.mockResult = .success(foodItems)

        let expectation = self.expectation(description: "Food items fetched successfully")

        viewModel.listenForFoodItemUpdates()

        mockService.triggerUpdate()

        DispatchQueue.main.async {
            XCTAssertEqual(self.viewModel.foodItems.count, 1)
            XCTAssertEqual(self.viewModel.foodItems.first?.name, "Apple")
            XCTAssertNil(self.viewModel.errorMessage)
            XCTAssertFalse(self.viewModel.showErrorAlert)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testFoodItemsFetchFailure() {
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Fetch error"])
        mockService.mockResult = .failure(error)

        let expectation = self.expectation(description: "Food items fetch failed")

        viewModel.listenForFoodItemUpdates()

        mockService.triggerUpdate()

        DispatchQueue.main.async {
            XCTAssertEqual(self.viewModel.foodItems.count, 0)
            XCTAssertEqual(self.viewModel.errorMessage, "Failed to fetch food items: Fetch error")
            XCTAssertTrue(self.viewModel.showErrorAlert)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
}
