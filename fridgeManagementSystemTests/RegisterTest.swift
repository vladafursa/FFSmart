@testable import fridgeManagementSystem
import XCTest

final class RegisterTest: XCTestCase {
    var registerViewModel: RegisterViewModel!
    override func setUpWithError() throws {
        super.setUp()
        registerViewModel = RegisterViewModel()
    }

    override func tearDownWithError() throws {
        registerViewModel = nil
        super.tearDown()
    }

    func testValidateForm_AllFieldsPresent_ShouldNotThrow() {
        registerViewModel.email = "test@example.com"
        registerViewModel.name = "Test Name"
        registerViewModel.password = "password123"
        registerViewModel.repeatedPassword = "password123"
        registerViewModel.role = "chef"

        XCTAssertNoThrow(try registerViewModel.validateForm())
    }

    func testValidateForm_withOneEmptyField_shouldThrow() {
        registerViewModel.email = ""
        registerViewModel.name = "Test Name"
        registerViewModel.password = "123456"
        registerViewModel.repeatedPassword = "123456"
        registerViewModel.role = "chef"
        XCTAssertThrowsError(try registerViewModel.validateForm()) { error in
            XCTAssertEqual(error as? formError, formError.emptyField)
        }
    }

    func testPerformanceExample() throws {
        registerViewModel.email = "test@example.com"
        registerViewModel.name = "Test Name"
        registerViewModel.password = "123456"
        registerViewModel.repeatedPassword = "123456"
        registerViewModel.role = "chef"
        measure {
            for _ in 0 ..< 1000 {
                do {
                    try registerViewModel.validateForm()
                } catch {
                    XCTFail("validateForm() should not have thrown an error")
                }
            }
        }
    }
}
