# 🍴 FridgeTracker Mobile App

FridgeTracker is a mobile application designed for restaurant kitchens to efficiently manage fridge inventory. It ensures chefs and head chefs can track food items, monitor expiry dates, and maintain accountability through a secure login system. Food servers are restricted from accessing fridge operations, keeping control in the hands of authorized staff.

---

## 📋 Features
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

## 🏗️ Architecture

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

## 🎨 Design Patterns

- **Observer Pattern**  
  - Enables real-time updates between ViewModels and Views  
  - Uses `ObservableObject` and `@Published` properties  

- **Singleton Pattern**  
  - Ensures single instances for shared resources (e.g., database connections, authentication)  

- **Dependency Injection**  
  - Allows mocking services for unit testing  
  - Improves separation of concerns and testability  

---

## ⚠️ Error Handling

- Errors are thrown in **Services**  
- **ViewModels** catch and process errors, setting a `showAlert` flag  
- **Views** listen for changes and display alerts when needed  
- Prevents crashes, centralizes error handling, and improves user experience  

---

