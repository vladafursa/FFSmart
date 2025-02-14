import Foundation

// MARK: - MockFirebase Class

class MockFirebase {
    // MARK: - Properties

    var authError: NSError? = NSError(domain: "MockFirebase", code: 1, userInfo: [NSLocalizedDescriptionKey: "Authentication failed"])
    var users: [MockUser] = []
    var currentUser: MockUser?
    var data: [String: Any] = [:]
    var url: String

    // MARK: - Initialization

    init(url: String) {
        self.url = url
    }

    // MARK: - Authentication Methods

    /// Simulates user authentication.
    func authUser(email: String, password: String, completion: @escaping (NSError?, MockAuthData?) -> Void) {
        if let user = users.first(where: { $0.email == email && $0.password == password }) {
            currentUser = user
            completion(nil, MockAuthData(user: user))
        } else {
            completion(authError, nil)
        }
    }

    /// Simulates user registration.
    func createUser(email: String, password: String, completion: @escaping (NSError?) -> Void) {
        if users.contains(where: { $0.email == email }) {
            completion(NSError(domain: "MockFirebase", code: 2, userInfo: [NSLocalizedDescriptionKey: "Email already exists"]))
        } else {
            let newUser = MockUser(email: email, password: password)
            users.append(newUser)
            completion(nil)
        }
    }

    /// Logs out the current user.
    func unauth() {
        currentUser = nil
    }

    // MARK: - Database Methods

    /// Sets a value at a specific path.
    func setValue(_ value: Any?, forKey key: String) {
        data[key] = value
    }

    /// Retrieves a value at a specific path.
    func getValue(forKey key: String) -> Any? {
        return data[key]
    }

    /// Removes a value at a specific path.
    func removeValue(forKey key: String) {
        data.removeValue(forKey: key)
    }

    /// Observes changes at a specific path.
    func observe(eventType _: MockEventType, with block: @escaping (MockDataSnapshot) -> Void) {
        let snapshot = MockDataSnapshot(data: data)
        block(snapshot)
    }

    /// Stops observing changes.
    func removeObserver() {
        // No-op in mock implementation
    }

    /// Creates a child reference.
    func child(byAppendingPath path: String) -> MockFirebase {
        return MockFirebase(url: "\(url)/\(path)")
    }
}

// MARK: - MockUser Class

class MockUser {
    var email: String
    var password: String
    var uid: String

    init(email: String, password: String) {
        self.email = email
        self.password = password
        uid = UUID().uuidString
    }
}

// MARK: - MockAuthData Class

class MockAuthData {
    var user: MockUser

    init(user: MockUser) {
        self.user = user
    }

    var uid: String {
        return user.uid
    }

    var provider: String {
        return "password"
    }
}

// MARK: - MockDataSnapshot Class

class MockDataSnapshot {
    var value: Any?

    init(data: [String: Any]) {
        value = data
    }

    func hasChild(_ key: String) -> Bool {
        return (value as? [String: Any])?[key] != nil
    }
}

// MARK: - MockEventType Enum

enum MockEventType {
    case value
    case childAdded
    case childRemoved
    case childChanged
}
