# product_au

A new Flutter project.

## Getting Started
Brief Description

Product AU is a Flutter application for browsing products, searching for products, viewing product details, and managing favorite products. The application integrates Firebase Authentication and retrieves product information through an API service.

Main Features
User authentication using Firebase Authentication
Product listing
Product search
Product details
Add/remove products from favorites
Persistent favorite-product storage
Responsive Flutter UI
Android support
Web support for the application architecture
Loading and error states for API operations
Setup Instructions
Prerequisites

Make sure the following tools are installed:

Flutter SDK
Dart SDK included with Flutter
Android Studio
Android SDK
Android emulator or physical Android device
Git

Check the installed Flutter version with:

flutter --version

Check that the Flutter environment is configured correctly:

flutter doctor

Resolve any required issues reported by flutter doctor before running the application.

Clone the Repository

Clone the project using Git:

git clone <YOUR_GITHUB_REPOSITORY_URL>

Navigate into the project:

cd product_au
Install Dependencies

Run:

flutter pub get

The project uses Flutter packages including Firebase and SharedPreferences.

Firebase Configuration

The application uses Firebase Authentication.

Before running the application, configure Firebase for the platforms you want to support.

Android

Create/configure a Firebase project and register the Android application using the correct Android package name.

Download the Firebase Android configuration file:

google-services.json

Place it in:

android/app/google-services.json

Do not commit private Firebase configuration or credentials to a public repository unless the configuration is intended to be publicly distributed and contains no sensitive credentials.

Firebase Authentication

In the Firebase Console:

Open the project.
Go to Authentication.
Open Sign-in method.
Enable the authentication providers required by the application.
Make sure the Android application is registered correctly.
API Configuration

Product data is retrieved through the application's product service:

lib/services/product_service.dart

If the application uses an external product API, configure the required API base URL/endpoints in the appropriate service or configuration file.

Do not commit private API keys, access tokens, passwords, or other secrets.

If environment variables or a local configuration file are required, provide a sample configuration such as:

.env.example

and keep the real credentials outside the repository.

Run the Application

Connect an Android device or start an emulator.

Check available devices:

flutter devices

Then run:

flutter run

For a specific device:

flutter run -d <device-id>
Technical Decisions
State Management

The application uses Flutter's ChangeNotifier pattern for application state management.

For example:

ProductProvider

is responsible for managing:

Product data
Search state
Loading state
API errors
Selected product details
Favorite product IDs

UI widgets can listen to the provider and automatically update when the state changes.

Project Structure

The project follows a feature-oriented Flutter structure with separate responsibilities for models, services, providers, utilities, and screens.

A simplified structure is:

lib/
├── models/
│   └── product.dart
│
├── providers/
│   └── product_provider.dart
│
├── services/
│   └── product_service.dart
│
├── screens/
│   ├── auth/
│   ├── home/
│   └── ...
│
├── utils/
│   └── ...
│
└── main.dart
Models

Models represent application data.

For example:

lib/models/product.dart

contains the product data model.

Services

Services are responsible for communication with external APIs.

For example:

lib/services/product_service.dart

handles product-related API operations.

Providers

Providers contain application state and business logic.

For example:

lib/providers/product_provider.dart

manages products, searching, favorites, and product details.

API Integration

API communication is separated from the UI through ProductService.

This keeps network-related logic outside the widgets and makes the application easier to maintain and test.

The provider calls the service when it needs to:

Load products
Search products
Retrieve product details

The UI then receives the updated state through ChangeNotifier.

Local Storage

Favorite product IDs are stored using:

shared_preferences

The application stores favorite product IDs as strings and restores them when the application starts.

Two keys are currently used:

favorite_product_ids
favorite_product_ids_backup

The backup key provides an additional fallback for restoring favorite IDs if the primary key is unavailable.

The application uses SharedPreferences rather than directly importing:

dart:html

because dart:html is only available on Flutter Web and cannot be imported when compiling the Android application.