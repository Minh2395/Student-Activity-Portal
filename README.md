# Student Activity Portal

A mobile application that allows students of the Faculty of Information Technology to discover and register for academic activities and Youth Union activities.

## 1. Project Overview

**Student Activity Portal** is developed to support the management of student activities at the Faculty of Information Technology. Students can view their information and participate in activities through a mobile application.

The project follows a layered architecture to separate the presentation, business logic, data access, and backend API responsibilities.

## 2. Technology Stack

| Component          | Technology                                           |
| ------------------ | ---------------------------------------------------- |
| Mobile application | Flutter, Dart                                        |
| Backend            | ASP.NET Core Web API                                 |
| Framework          | .NET 9                                               |
| ORM                | Entity Framework Core                                |
| Database           | Microsoft SQL Server                                 |
| API communication  | HTTP / JSON                                          |
| Development tools  | Visual Studio, VS Code, SQL Server Management Studio |

## 3. System Architecture

```text
Flutter Mobile Application
          |
          | HTTP / JSON
          v
ASP.NET Core Web API
          |
          v
Entity Framework Core
          |
          v
Microsoft SQL Server
```

### Flutter Architecture

The Flutter application is organized into three main layers:

- `presentation`: User interface and application screens.
- `business`: Business logic and state management.
- `data`: Models, repositories, and data sources.

### Backend Architecture

The ASP.NET Core backend is responsible for handling HTTP requests, validating data, processing business logic, and communicating with SQL Server through Entity Framework Core.

## 4. Main Features

### Student Management

- View the student list.
- Add new student records.
- Edit student information.
- Soft-delete students by deactivating their accounts.
- Synchronize data with SQL Server through the API.

### Planned Features

- Activity category management.
- Academic and Youth Union activity management.
- Activity registration.
- Registration approval and rejection.
- Notification management.
- User authentication and role-based authorization.

## 5. Database

Database name: `StudentActivityPortal`

The database currently contains seven main tables:

| Table                    | Description                             |
| ------------------------ | --------------------------------------- |
| `Users`                  | User accounts and roles                 |
| `Students`               | Student information                     |
| `ActivityCategories`     | Activity categories                     |
| `Activities`             | Activity information                    |
| `Registrations`          | Student activity registrations          |
| `Notifications`          | Notification content                    |
| `NotificationRecipients` | Notification recipients and read status |

The database creation and checking scripts are maintained separately in the project source files.

## 6. Project Structure

```text
StudentActivityPortal/
│
├── StudentActivityPortal.Api/
│   ├── Controllers/
│   ├── Data/
│   ├── Dtos/
│   ├── Models/
│   │   └── Entities/
│   ├── Program.cs
│   └── appsettings.json
│
├── student_activity_portal/
│   ├── lib/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── business/
│   │   │   └── providers/
│   │   ├── presentation/
│   │   │   └── pages/
│   │   └── main.dart
│   └── pubspec.yaml
│
├── README.md
└── LICENSE.md
```

## 7. Requirements

Before running the project, install:

- Flutter SDK
- Dart SDK (included with Flutter)
- .NET 9 SDK
- Microsoft SQL Server
- SQL Server Management Studio
- Android Studio or another Flutter-compatible IDE

## 8. Database Configuration

Create or restore the `StudentActivityPortal` database in SQL Server.

Configure the connection string in:

`StudentActivityPortal.Api/appsettings.json`

Example:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost\\SQLEXPRESS;Database=StudentActivityPortal;Trusted_Connection=True;TrustServerCertificate=True;"
  }
}
```

Update the SQL Server instance name and authentication settings to match your local environment.

## 9. Running the Backend

Open a terminal:

```powershell
cd StudentActivityPortal.Api
dotnet restore
dotnet build
dotnet run --urls "http://0.0.0.0:5157"
```

The API will be available at:

```text
http://localhost:5157/api
```

Database connection test:

```text
GET http://localhost:5157/api/databasetest
```

Student API:

```text
GET    http://localhost:5157/api/students
GET    http://localhost:5157/api/students/{id}
POST   http://localhost:5157/api/students
PUT    http://localhost:5157/api/students/{id}
DELETE http://localhost:5157/api/students/{id}
```

## 10. Running the Flutter Application

Open another terminal:

```powershell
cd student_activity_portal
flutter pub get
flutter run
```

For Android Emulator, configure the API base URL as:

```dart
static const String baseUrl = "http://10.0.2.2:5157/api";
```

`10.0.2.2` allows the Android Emulator to access services running on the development computer.

For a physical Android device, replace this address with the computer's LAN IP address and ensure both devices can access the backend.

## 11. Current Development Status

| Feature                              | Status      |
| ------------------------------------ | ----------- |
| SQL Server database                  | Completed   |
| Entity Framework Core Database First | Completed   |
| Backend database connection          | Completed   |
| Student API                          | Implemented |
| Flutter data models                  | Completed   |
| API client and student repository    | Implemented |
| Student Provider                     | Implemented |
| Student list screen                  | Implemented |
| Add student                          | Implemented |
| Edit student                         | Implemented |
| Soft-delete student                  | Implemented |
| Activity category management         | Pending     |
| Activity management                  | Pending     |
| Activity registration                | Pending     |
| Notifications                        | Pending     |
| Authentication and authorization     | Pending     |

## 12. Contribution and Handover

Before continuing development:

1. Clone the repository.
2. Configure SQL Server and the database connection string.
3. Restore backend and Flutter dependencies.
4. Run the backend and verify database connectivity.
5. Run the Flutter application on an Android Emulator.
6. Review the existing architecture before adding new features.
7. Keep database changes, backend APIs, DTOs, and Flutter models synchronized.

Please develop new features following the existing layered architecture and naming conventions.

## 13. Notes

- The project is currently under development.
- The API and Flutter application must both be running for mobile data operations.
- The current Android Emulator API address is `http://10.0.2.2:5157/api`.
- Do not commit local secrets, passwords, or environment-specific credentials.

---

**Student Activity Portal**  
Faculty of Information Technology

## License

Copyright (c) 2026 [Copyright Holder]

All Rights Reserved.

Unauthorized copying, modification, distribution, or use of this project
is strictly prohibited without prior written permission.
