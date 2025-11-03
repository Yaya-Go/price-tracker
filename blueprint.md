# Project Blueprint

## Overview

This document outlines the structure, features, and development history of the Flutter application. It serves as a single source of truth for the project's design and implementation.

## Features & Design

*   **Firebase Integration:** The project is connected to a Firebase backend.
*   **Dependency Management:** All dependencies are up-to-date.
*   **Cloud Firestore:** The project uses Cloud Firestore as its database, with security rules configured to allow authenticated users to read and write to the `products` collection.

## Development History

### Initial Setup

*   **Firebase Initialization:**
    *   Configured the Firebase server environment (`.idx/mcp.json`).
    *   Installed the Firebase CLI (`firebase-tools`).
    *   Authenticated the user's Firebase account.
    *   Configured the Flutter project with `flutterfire configure`.
    *   Updated all project dependencies to the latest versions.

### Firestore Configuration

*   **Firestore Initialization:** Ran `firebase init firestore` to set up Firestore rules and indexes.
*   **Security Rules:** Updated and deployed `firestore.rules` to restrict database access to authenticated users.

### Package Name Change

*   **Android:**
    *   Updated `applicationId` and `namespace` in `android/app/build.gradle.kts` to `com.lmywilks.price_tracker`.
    *   Moved `MainActivity.kt` to `android/app/src/main/kotlin/com/lmywilks/price_tracker/` and updated its package declaration.
*   **Firebase:**
    *   Re-ran `flutterfire configure` to generate new platform-specific configurations (`google-services.json` and `firebase_options.dart`) to match the new package name.
*   **iOS:**
    *   No changes were made as the `ios` directory was not found.
