# L2L Flutter App

L2L (Link to Learn) - Intelligent Learning Bookmark Platform

## Overview

The L2L Flutter application provides a cross-platform mobile/web interface for managing learning resources. The app integrates with the backend API to manage projects and links, and displays AI-generated content including summaries, flashcards, courses, and quizzes.

## Architecture

| Layer | Directory | Purpose |
|-------|-----------|---------|
| **Presentation** | `lib/presentation/` | UI screens and widgets |
| **ViewModels** | `lib/presentation/viewmodels/` | Riverpod StateNotifiers for state management |
| **Routing** | `lib/core/router/` | GoRouter navigation |
| **Data** | `lib/data/` | Models, repositories, services |
| **Core** | `lib/core/` | Constants, network, storage, utils |

### MVVM Architecture

The app follows the MVVM (Model-View-ViewModel) pattern:

- **Model**: Data classes (`LinkModel`, `ProjectModel`, `UserModel`) and repositories
- **View**: Flutter widgets (pages and reusable components) that observe ViewModel state
- **ViewModel**: `StateNotifier` classes that manage business logic and state transitions

### State Management

The app uses Riverpod with the Result pattern:

- **AuthViewModel**: Manages authentication state (login, logout, register)
- **ProjectViewModel**: Manages projects list and selected project with links
- **LinkViewModel**: Manages links list with filtering by project/tags

All repository methods return `Result<T>` (sealed class with `Success`/`Failure`) to enforce explicit error handling.

### Navigation Pattern

Navigation is triggered via enum flags in ViewModel state (`AuthNavigationTrigger`, `ProjectNavigationTrigger`, `LinkNavigationTrigger`). Views observe these triggers and perform navigation in `addPostFrameCallback`, keeping ViewModels testable and free of Flutter dependencies.

## Features

### Authentication
- Login/Register with JWT-based authentication
- Secure token storage with flutter_secure_storage
- Auto-refresh token handling

### Projects
- Create, view, update, delete projects
- View project links with AI processing status
- Generate AI courses from project links

### Links
- Save links with tags and project assignment
- View AI-generated summaries and flashcards
- Track link processing status (pending, processing, completed, failed)

## Setup

### Prerequisites

```bash
# Install Flutter
brew install flutter

# Verify installation
flutter doctor
```

### Installation

```bash
cd app

# Install dependencies
flutter pub get

# Generate code for models/providers
flutter pub run build_runner build --delete-conflicting-outputs
```

### Running the App

```bash
# Run on Chrome (web)
flutter run -d chrome

# Run on connected device
flutter run

# Run on macOS desktop
flutter run -d macos
```

## Code Generation

This project uses code generation for:
- **Freezed**: Immutable model classes with copyWith, equals, hashCode
- **JSON Serialization**: JSON to Dart object mapping
- **Riverpod**: State management providers

### Running Build Runner

```bash
# Generate code after model changes
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for development
flutter pub run build_runner watch
```

## Project Structure

```
app/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── core/
│   │   ├── router/               # GoRouter configuration
│   │   ├── constants/            # App constants (API endpoints, etc.)
│   │   ├── utils/                # Utility functions (Result, NavigationTriggers)
│   │   └── theme/                # App theme configuration
│   ├── data/
│   │   ├── models/               # Data models (Link, Project, User)
│   │   ├── repositories/         # Business logic (Auth, Project, Link)
│   │   └── services/             # API services (AuthService, ProjectService, LinkService)
│   └── presentation/
│       ├── viewmodels/           # Riverpod StateNotifiers
│       │   ├── auth_viewmodel.dart
│       │   ├── auth_state.dart
│       │   ├── project_viewmodel.dart
│       │   ├── project_state.dart
│       │   ├── link_viewmodel.dart
│       │   └── link_state.dart
│       ├── pages/                # Screen widgets
│       │   ├── auth/             # Login, Register screens
│       │   ├── home/             # Main app screens
│       │   ├── projects/         # Project list, detail, edit screens
│       │   └── links/            # Link list, detail, add screens
│       └── widgets/              # Reusable widgets
├── test/                         # Widget and unit tests
└── pubspec.yaml                  # Dependencies
```

## API Integration

The app communicates with the backend API at `http://localhost:3000/api/v1`:

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/auth/register` | POST | User registration |
| `/auth/login` | POST | User login |
| `/auth/refresh` | POST | Refresh access token |
| `/auth/me` | GET | Get current user |
| `/projects` | GET/POST | List/Create projects |
| `/projects/:id` | GET/PUT/DELETE | Get/Update/Delete project |
| `/projects/:id/generate-course` | POST | Generate AI course |
| `/links` | GET/POST | List/Create links |
| `/links/:id` | GET/PUT/DELETE | Get/Update/Delete link |

## State Management

The app uses Riverpod with MVVM architecture:

- **AuthViewModel**: Manages authentication state (login, logout, register) with navigation triggers
- **ProjectViewModel**: Manages projects list and selected project with links
- **LinkViewModel**: Manages links list with filtering by project/tags

All business logic is in ViewModels. Views (pages/widgets) only:
- Observe state via `ref.watch(viewModelProvider)`
- Invoke commands via `ref.read(viewModelProvider.notifier).method()`
- Handle navigation based on navigation trigger enums in state

## Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## Troubleshooting

### Build Runner Fails

```bash
# Clean and rebuild
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### API Connection Issues

Ensure the backend is running:

```bash
# Test backend
curl http://localhost:3000/health

# Check backend logs
docker-compose -f docker-compose.dev.yml logs -f api
```

## Dependencies

### Core
- `flutter_riverpod` - State management
- `go_router` - Navigation and routing
- `dio` - HTTP client
- `flutter_secure_storage` - Secure token storage
- `shared_preferences` - Local storage
- `freezed_annotation` - Freezed models
- `json_annotation` - JSON serialization

### Dev Dependencies
- `build_runner` - Code generation
- `freezed` - Code generation for immutable models
- `json_serializable` - JSON serialization codegen
- `mocktail` - Testing mocks
- `flutter_test` - Widget testing

---

**Last Updated**: March 2026
**Version**: 1.0.0 (MVP)
