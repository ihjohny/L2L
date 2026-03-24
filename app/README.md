# L2L Flutter App

L2L (Link to Learn) - Intelligent Learning Bookmark Platform

## Overview

The L2L Flutter application provides a cross-platform mobile/web interface for managing learning resources. The app integrates with the backend API to manage projects and links, and displays AI-generated content including summaries, flashcards, courses, and quizzes.

## Architecture

| Layer | Directory | Purpose |
|-------|-----------|---------|
| **Presentation** | `lib/presentation/` | UI screens and widgets |
| **Providers** | `lib/core/providers/` | Riverpod state management |
| **Routing** | `lib/core/router/` | GoRouter navigation |
| **Data** | `lib/data/` | Models, services, repositories |
| **Core** | `lib/core/` | Constants, network, storage, utils |

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
│   │   ├── providers/            # Riverpod providers (auth, projects, links)
│   │   ├── router/               # GoRouter configuration
│   │   ├── constants/            # App constants (API endpoints, etc.)
│   │   └── utils/                # Utility functions
│   ├── data/
│   │   ├── models/               # Data models (Link, Project, User)
│   │   └── services/             # API services (AuthService, ProjectService, LinkService)
│   └── presentation/
│       ├── pages/                # Screen widgets
│       │   ├── auth/             # Login, Register screens
│       │   ├── home/             # Main app screens
│       │   ├── projects/         # Project list, detail, create screens
│       │   └── links/            # Link detail screens
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

The app uses Riverpod for state management:

- **AuthNotifier**: Manages authentication state (login, logout, register)
- **ProjectsNotifier**: Manages projects list and selected project
- **LinksNotifier**: Manages links list with filtering by project/tags

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
