# 👨‍💼 EmployeeManager

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.35.6-02569B?logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?logo=firebase&logoColor=black)
![Bloc](https://img.shields.io/badge/State%20Management-Bloc-blue)

**A Flutter-based employee management application with Firebase Firestore integration**

</div>

---

## 📖 About This Project

EmployeeManager is a Flutter application that demonstrates professional mobile app development skills including Firebase integration, Bloc state management, and real-time data synchronization. The app manages employee records with intelligent visual flagging for long-serving active employees.

---

## ✨ Key Features

- 📋 **Employee Listing** - Display all employees from Firebase Firestore
- 🟢 **Smart Highlighting** - Employees who are active and have 5+ years of service are marked in green
- ➕ **Add Employees** - Simple dialog interface to add new employees
- ✏️ **Update Employees** - Edit employee details with smart change detection
- 🔄 **Real-Time Updates** - Automatic sync when Firestore data changes
- ✅ **Data Validation** - Comprehensive business rules for data integrity

### Business Logic: Employee Highlighting

Employees are flagged in green when they meet both criteria:
- Currently active (`isWorking = true`)
- Served 5+ years with the organization

```dart
final joinDate = employee.dateOfJoin.toDate();
final yearsOfService = DateTime.now().difference(joinDate).inDays >= 365 * 5;
final isHighlighted = employee.isWorking && yearsOfService;
```

---

## 🛠️ Tech Stack

| Component | Technology |
|-----------|-----------|
| Framework | Flutter (Dart) |
| State Management | Bloc Pattern |
| Backend Database | Firebase Firestore |
| Architecture | Clean Architecture with Repository Pattern |

---

## 📁 Project Structure

```
lib/
├── bloc/
│   └── operations_bloc.dart          # State management
├── model/
│   └── employee.dart                 # Data model
├── repository/
│   └── firebase_repository.dart      # Firebase operations
├── ui/
│   └── employee_action.dart          # UI screens
└── main.dart                         # App entry point
```

---

## 💾 Firestore Data Structure

**Collection:** `employees`

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | String | Yes | Unique employee ID |
| `name` | String | Yes | Employee name |
| `salary` | Number | Yes | Employee salary |
| `isWorking` | Boolean | Yes | Current work status |
| `dateOfJoin` | Timestamp | Yes | Joining date |
| `dateOfResign` | Timestamp | Conditional | Required if not working |

**Example:**
```json
{
  "id": "emp_001",
  "name": "John Doe",
  "salary": 75000,
  "isWorking": true,
  "dateOfJoin": "2018-03-15T00:00:00Z",
  "dateOfResign": null
}
```

---

## ✅ Validation Rules

The application enforces these business rules:

| Rule | Description |
|------|-------------|
| Active employees | `dateOfResign` not required if `isWorking = true` |
| Resigned employees | `dateOfResign` mandatory if `isWorking = false` |
| Date consistency | Join and resign dates cannot be the same |
| Chronological order | Resign date must be after join date |

---

## 🚀 Installation & Setup

### Prerequisites
- Flutter SDK (3.35.6)
- Firebase account
- Android Studio or VS Code

### Steps

**1. Clone the repository**
```bash
git clone https://github.com/yourusername/EmployeeManager.git
cd EmployeeManager
```

**2. Install dependencies**
```bash
flutter pub get
```

**3. Firebase Setup**
- Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
- Enable Firestore Database in Firebase Console

**4. Run the app**
```bash
flutter run
dart pub global activate flutterfire_cli
flutterfire configure --project=employee-manager-6da28 (from root project)
```

---

## 🎥 Demo Video

📹 **[Watch Complete Demo]([https://www.loom.com/share/your-video-id](https://drive.google.com/file/d/1HijBu6bXeGwxxiccCmg7Yizb_wLcBqnT/view?usp=sharing))**

**Demo showcases:**
- Adding new employees
- Updating employee information
- Real-time Firestore sync
- Employee highlighting logic
- Data validation in action

---

## 🎯 Key Highlights

**Why this project demonstrates professional skills:**

✅ **Clean Architecture** - Separation of concerns with Bloc, Repository, and UI layers  
✅ **State Management** - Professional Bloc pattern implementation  
✅ **Firebase Integration** - Real-time database operations with Firestore  
✅ **Business Logic** - Complex validation rules and conditional logic  
✅ **Real-Time Sync** - Automatic UI updates with Stream-based data flow  
✅ **Production Ready** - Error handling, validation, and user feedback  

---

<div align="center">

**Built with Flutter & Firebase**

⭐ This project demonstrates production-ready Flutter development skills

</div>
