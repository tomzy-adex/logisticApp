# Logistics Platform - Flutter App

A comprehensive logistics management platform built with Flutter, featuring authentication, shipment management, tracking, and admin monitoring capabilities.

## Features

### 🔐 Authentication
- Secure login system with form validation
- Role-based access control (Admin vs User)
- Session management with local storage
- Demo credentials provided for testing

### 📦 Shipment Management
- Create new shipments with sender/receiver details
- Auto-generated tracking numbers
- Address geocoding with mock coordinates
- Status tracking (Pending, In-Transit, Delivered)
- Role-based shipment visibility

### 🔍 Shipment Tracking
- Public tracking interface (no login required)
- Real-time status updates
- Detailed shipment information
- Delivery timeline visualization

### 👨‍💼 Admin Features
- View all shipments in the system
- Update shipment statuses
- Monitor system activity logs
- User activity tracking

### 📱 Modern UI/UX
- Clean, intuitive interface
- Material Design 3 components
- Responsive layout
- Loading states and error handling
- Pull-to-refresh functionality

## Architecture

The app follows Clean Architecture principles with clear separation of concerns:

```
lib/
├── core/
│   ├── models/          # Data models
│   └── services/        # Business logic services
├── data/
│   └── mock_data.dart   # Mock data and utilities
├── presentation/
│   ├── providers/       # State management
│   ├── screens/         # UI screens
│   └── widgets/         # Reusable components
└── main.dart           # App entry point
```

## Setup Instructions

### Prerequisites
- Flutter SDK (3.2.3 or higher)
- Dart SDK
- Android Studio / VS Code
- Android Emulator or iOS Simulator

### Installation

1. **Clone the repository**
   ```bash
   git clone git@github.com:tomzy-adex/logisticApp.git
   cd logisticApp
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Demo Credentials

Use these credentials to test the application:

#### Admin User
- **Email:** admin@example.com
- **Password:** password
- **Capabilities:** Full access to all features, can update shipment statuses, view all shipments and logs

#### Regular User
- **Email:** user@example.com
- **Password:** password
- **Capabilities:** Create shipments, view own shipments, track shipments

### Sample Tracking Numbers

For testing the public tracking feature:
- TRK001234567
- TRK007654321
- TRK009876543

## Dependencies

- **provider:** State management
- **shared_preferences:** Local data storage
- **intl:** Date formatting
- **uuid:** Unique ID generation

## Key Features Implementation

### Authentication Flow
- Form validation with email and password requirements
- Mock authentication service with hardcoded users
- Secure session storage using SharedPreferences
- Automatic session restoration on app restart

### Shipment Creation
- Comprehensive form with validation
- Auto-generation of tracking numbers
- Mock geocoding service for address coordinates
- Real-time status updates

### Role-Based Access
- Admin users can view all shipments and update statuses
- Regular users can only view their own shipments
- Admin-only monitoring logs screen
- Dynamic navigation based on user role

### Public Tracking
- No authentication required
- Tracking number validation
- Detailed shipment information display
- Status timeline visualization

### Monitoring & Logging
- Automatic logging of user activities
- Shipment creation and update tracking
- Admin-only access to activity logs
- Detailed metadata storage

## Screenshots

The app includes the following main screens:
1. **Login Screen** - Authentication with demo credentials
2. **Home Screen** - Main navigation with role-based menu
3. **Shipments List** - View shipments with status indicators
4. **Create Shipment** - Form to create new shipments
5. **Track Shipment** - Public tracking interface
6. **Shipment Details** - Comprehensive shipment information
7. **Admin Logs** - System activity monitoring (admin only)

## Testing

The app includes comprehensive error handling and loading states:
- Network error simulation
- Form validation
- Loading indicators
- Error messages with retry options

## Future Enhancements

Potential improvements for production:
- Real API integration
- Push notifications for status updates
- Offline support
- Image upload for shipments
- Advanced filtering and search
- Export functionality
- Multi-language support

## License

This project is created as a take-home assessment for Flutter development. 