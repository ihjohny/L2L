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

The app follows the MVVM (Model-View-ViewModel) pattern with separated responsibilities:

- **Model**: Data classes (`LinkModel`, `ProjectModel`, `UserModel`) and repositories
- **View**: Flutter widgets (pages and reusable components) that observe ViewModel state
- **ViewModel**: `StateNotifier` classes that manage business logic and state transitions

### ViewModel Separation

Link-related functionality is split into three dedicated ViewModels:

| ViewModel | Purpose | Key Feature |
|-----------|---------|-------------|
| `LinkListViewModel` | Links list with filtering | Lightweight, no AI output data |
| `LinkDetailViewModel` | Single link with full data | Includes AI summary and flashcards |
| `AddLinkViewModel` | Create new link form | Manages form state and project creation |

This separation is necessary because the Link List API does NOT include AI-generated content (summary, flashcards) while the Link Detail API DOES include complete AI output.

### State Management

The app uses Riverpod with the Result pattern:

- **AuthViewModel**: Manages authentication state (login, logout, register)
- **ProjectViewModel**: Manages projects list and selected project with links
- **LinkListViewModel**: Manages links list with filtering by project/tags (no AI output)
- **LinkDetailViewModel**: Manages single link with complete AI-generated content
- **AddLinkViewModel**: Manages form state for creating new links

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

- **View courses with lesson-by-lesson navigation**
  - Progress stepper with interactive dots
  - Estimated reading time per lesson
  - Previous/Next navigation controls
  - Jump to any lesson directly from the course list

### Links
- Save links with tags and project assignment
- View AI-generated summaries and flashcards
- Track link processing status (pending, processing, completed, failed)
- Retry failed link processing with a single tap

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

## Documentation

For detailed implementation information, see:
- [Course Detail Page Implementation](../docs/implementation/course_detail_page.md) - Architecture and design decisions for the course viewer

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
│       │   ├── link_list_viewmodel.dart
│       │   ├── link_list_state.dart
│       │   ├── link_detail_viewmodel.dart
│       │   ├── link_detail_state.dart
│       │   ├── add_link_viewmodel.dart
│       │   └── add_link_state.dart
│       ├── pages/                # Screen widgets
│       │   ├── auth/             # Login, Register screens
│       │   ├── home/             # Main app screens
│       │   ├── projects/         # Project list, detail, edit screens
│       │   ├── links/            # Link list, detail, add screens
│       │   └── course/           # Course detail screen with lesson navigation
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
| `/projects/:id/generate-course-quiz` | POST | Generate AI course and quiz |
| `/projects/:id/course` | GET | Get course for a project |
| `/projects/:id/quiz` | GET | Get quiz for a project |
| `/links` | GET/POST | List/Create links |
| `/links/:id` | GET/PUT/DELETE | Get/Update/Delete link |
| `/links/:id/retry` | POST | Retry failed link processing |

## State Management

The app uses Riverpod with MVVM architecture:

- **AuthViewModel**: Manages authentication state (login, logout, register) with navigation triggers
- **ProjectDetailsViewModel**: Manages project details, links, course, and quiz data
- **LinkListViewModel**: Manages links list with filtering by project/tags (lightweight, no AI output)
- **LinkDetailViewModel**: Manages single link with complete AI-generated content (summary, flashcards)
- **AddLinkViewModel**: Manages form state for creating new links with optional project creation
- **CourseDetailViewModel**: Manages course viewing with lesson navigation, reading time estimation, and progress tracking

All business logic is in ViewModels. Views (pages/widgets) only:
- Observe state via `ref.watch(viewModelProvider)`
- Invoke commands via `ref.read(viewModelProvider.notifier).method()`
- Handle navigation based on navigation trigger enums in state

**Note on ViewModels:**
- **Link ViewModels**: Three separate ViewModels because the List API returns links WITHOUT AI output (lightweight) while the Detail API returns links WITH AI output (summary, flashcards)
- **CourseDetailViewModel**: Dedicated to course viewing with lesson navigation, progress tracking, and reading time estimation
- **AddLinkViewModel**: Manages form state and optional project creation

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
