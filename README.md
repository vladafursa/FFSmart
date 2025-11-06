#  FridgeTracker Mobile App

FridgeTracker is a mobile application designed for restaurant kitchens to efficiently manage fridge inventory. It ensures chefs and head chefs can track food items, monitor expiry dates, and maintain accountability through a secure login system. Food servers are restricted from accessing fridge operations, keeping control in the hands of authorized staff.

---

##  Features
- **Food Item Tracking**  
  - Insert and remove items from the fridge  
  - Track name, quantity, and expiry date of each item  

- **User Authentication**  
  - Login system for chefs, head chefs and admins
  - Logs who added or removed items  
  - Food servers have no access to fridge operations  

- **User Interface**  
  - Easy-to-use mobile interface built with SwiftUI  
  - Dynamic updates for real-time inventory changes  

---

##  Architecture

This project adopts the **MVVM (Model-View-ViewModel)** architectural pattern for clean separation of concerns and scalability.

### Components
- **Model**  
  - Represents the data layer (e.g., `User`, `FoodItem`)  
  - Responsible for data storage and structures  

- **View**  
  - SwiftUI-based user interface  
  - Displays data bindings and captures user input  

- **ViewModel**  
  - Connects Model and View  
  - Translates data for UI representation  
  - Handles business logic via Services  

- **Services**  
  - Extensions for business logic  
  - Fetches data from Firebase and performs queries  
  - Centralized error handling  

---

##  Design Patterns

- **Observer Pattern**  
  - Enables real-time updates between ViewModels and Views  
  - Uses `ObservableObject` and `@Published` properties  

- **Singleton Pattern**  
  - Ensures single instances for shared resources (e.g., database connections, authentication)  

- **Dependency Injection**  
  - Allows mocking services for unit testing  
  - Improves separation of concerns and testability  

---

##  Error Handling

- Errors are thrown in **Services**  
- **ViewModels** catch and process errors, setting a `showAlert` flag  
- **Views** listen for changes and display alerts when needed  
- Prevents crashes, centralizes error handling, and improves user experience  

---
##  User help documentation
Login:

<img width="242" height="692" alt="Screenshot 2025-11-06 at 21 23 37" src="https://github.com/user-attachments/assets/036a631f-5a19-42a3-b2cb-b393848e26b2" />

Changing password:

<img width="600" height="599" alt="Screenshot 2025-11-06 at 21 24 11" src="https://github.com/user-attachments/assets/1212348c-42fd-4652-96e0-c56d557e657c" />

Registration:

<img width="382" height="682" alt="Screenshot 2025-11-06 at 21 24 37" src="https://github.com/user-attachments/assets/fe28e48c-e027-4f1b-90c2-8d36e27ccc9e" />

Viewing items:

<img width="217" height="699" alt="Screenshot 2025-11-06 at 21 25 42" src="https://github.com/user-attachments/assets/bc4bf75f-766a-4950-b9dd-63a85bbc63b9" />

Adding new items:

<img width="497" height="501" alt="Screenshot 2025-11-06 at 21 26 48" src="https://github.com/user-attachments/assets/8c997b22-cf35-4779-be22-8fa47124d348" />

Modifying items:

<img width="306" height="428" alt="Screenshot 2025-11-06 at 21 27 18" src="https://github.com/user-attachments/assets/7b67b9ce-229b-4791-8684-f892c7c447e8" />

Viewing logs:

<img width="260" height="405" alt="Screenshot 2025-11-06 at 21 27 49" src="https://github.com/user-attachments/assets/a4ab5cfa-ee76-4c8e-b016-2d78a73a6829" />

Access panel:

<img width="399" height="382" alt="Screenshot 2025-11-06 at 21 28 03" src="https://github.com/user-attachments/assets/97797c63-74ce-43b3-b00f-4b3352a29fcd" />

