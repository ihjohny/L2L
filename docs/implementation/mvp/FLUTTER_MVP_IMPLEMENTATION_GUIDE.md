# L2L (Link to Learn) - Flutter MVP Implementation Guide

**Version:** 1.0
**Date:** March 2026
**Status:** Authoritative Guide for Flutter MVP Development

---

## Document Purpose

This document provides step-by-step implementation instructions for the L2L Flutter MVP application. It aligns with the backend APIs defined in the [AI_AGENT_MVP_IMPLEMENTATION_GUIDE.md](./AI_AGENT_MVP_IMPLEMENTATION_GUIDE.md) and focuses on delivering the minimum viable product to validate the core value proposition.

### How to Use This Guide

1. **Sequential Execution:** Follow phases in order (Foundation → Core Features → MVP Complete)
2. **Pattern-Based:** Each screen specifies the required state management, API calls, and UI components
3. **No Code Included:** This guide describes what to implement, not how to write the code
4. **Verification Steps:** Each phase includes validation criteria

---

## Table of Contents

1. [MVP Scope & Priorities](#1-mvp-scope--priorities)
2. [Architecture Overview](#2-architecture-overview)
3. [Project Setup & Configuration](#3-project-setup--configuration)
4. [Core Infrastructure](#4-core-infrastructure)
5. [Screen Implementation Guide](#5-screen-implementation-guide)
6. [State Management Patterns](#6-state-management-patterns)
7. [API Integration](#7-api-integration)
8. [Navigation & Routing](#8-navigation--routing)
9. [MVP Verification Checklist](#9-mvp-verification-checklist)

---

## 1. MVP Scope & Priorities

### 1.1 Core User Flows

| Priority | Flow | Description |
|----------|------|-------------|
| P0 | Authentication | Register → Login → Access App |
| P0 | Save Link | Add URL → Assign Project → View Processing Status |
| P0 | View Link Content | Open Link → View Summary → View Flashcards |
| P0 | Project Management | Create Project → View Links → Generate Course |
| P1 | Profile Management | View Profile → Logout |

### 1.2 Screens in Scope

| Screen | Priority | Backend API |
|--------|----------|-------------|
| Login | P0 | POST /auth/login |
| Signup | P0 | POST /auth/register |
| Profile | P1 | GET /auth/me |
| Main Container (Tab Navigation - Home, Projects, Profile) | P0 | N/A |
| Home (Feed Tab) | P0 | GET /projects, GET /links |
| Projects List | P0 | GET /projects |
| Project Details | P0 | GET /projects/:id, POST /projects/:id/generate-course |
| Edit Project | P1 | PUT /projects/:id |
| Links List | P0 | GET /links |
| Add Link (with inline project creation) | P0 | POST /links, POST /projects |
| Link Details | P0 | GET /links/:id |

### 1.3 Out of Scope (Phase 2+)

- Course lesson viewing UI (beyond basic generation confirmation)
- Quiz taking UI
- Flashcard interactive study mode
- Settings and preferences
- Share functionality
- Offline mode
- Push notifications

---

## 2. Architecture Overview

### 2.1 Layered Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │   Screens   │  │   Widgets   │  │    State Notifiers  │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                      Domain Layer                            │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │                   Repositories                          │ │
│  └─────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                       Data Layer                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │   Models    │  │  Services   │  │   Dio Client        │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Directory Structure

```
lib/
├── main.dart                          # App entry point
├── app.dart                           # MaterialApp configuration
│
├── providers/
│   ├── auth_providers.dart            # Auth state management
│   ├── project_providers.dart         # Project state management
│   └── link_providers.dart            # Link state management
│
├── core/
│   ├── app/
│   │   └── app.dart                   # Root widget (L2LApp)
│   ├── config/
│   │   ├── env_config.dart            # Environment variables
│   │   └── theme_config.dart          # App theme
│   ├── constants/
│   │   └── app_constants.dart         # Static constants
│   ├── network/
│   │   └── dio_client.dart            # HTTP client singleton
│   ├── storage/
│   │   └── secure_storage.dart        # Token storage
│   └── router/
│       └── app_router.dart            # GoRouter configuration
│
├── data/
│   ├── models/
│   │   ├── user_model.dart            # User data class
│   │   ├── auth_request.dart          # Login/Register DTOs
│   │   ├── auth_response.dart         # Auth API response
│   │   ├── project_model.dart         # Project data class
│   │   ├── link_model.dart            # Link data class
│   │   └── job_model.dart             # Job status data class
│   ├── repositories/
│   │   └── auth_repository.dart       # Auth business logic
│   └── services/
│       ├── auth_service.dart          # Auth API calls
│       ├── project_service.dart       # Project API calls
│       ├── link_service.dart          # Link API calls
│       └── job_service.dart           # Job status API calls
│
└── presentation/
    ├── pages/
    │   ├── splash/
    │   │   └── splash_page.dart           # Initial loading screen
    │   ├── auth/
    │   │   ├── login_page.dart            # Login screen
    │   │   └── register_page.dart         # Registration screen
    │   ├── main_container/
    │   │   └── main_container_page.dart   # Main tab navigation (Home, Projects, Profile)
    │   ├── home/
    │   │   ├── home_page.dart             # Home/Feed screen (default tab)
    │   │   └── widgets/
    │   │       ├── recent_projects_section.dart  # Horizontal project list for Home
    │   │       └── recent_links_section.dart     # Vertical links list for Home
    │   ├── links/
    │   │   ├── links_list_page.dart       # Links list
    │   │   ├── link_details_page.dart     # Link details
    │   │   └── add_link_page.dart         # Add link (modal/page)
    │   ├── profile/
    │   │   └── profile_page.dart          # User profile
    │   └── projects/
    │       ├── projects_list_page.dart    # Projects list
    │       ├── project_detail_page.dart   # Project details
    │       └── edit_project_page.dart     # Edit project
    │
    └── widgets/
        ├── common/
        │   ├── app_button.dart            # Primary button component
        │   ├── app_text_field.dart        # Input field component
        │   ├── loading_widget.dart        # Loading indicator
        │   └── error_widget.dart          # Error display component
        ├── link_card.dart                 # Reusable link card widget
        └── project_card.dart              # Reusable project card widget
```

---

## 3. Project Setup & Configuration

### 3.1 Environment Configuration

**File:** `lib/core/config/env_config.dart`

**Implementation Requirements:**
- Load API base URL from environment (`.env` file for development)
- Define connection timeouts (connect: 30s, receive: 30s)
- Define API path prefix (e.g., `/api/v1`)
- Enable/disable logging based on environment
- Support multiple environments (development, staging, production)

**Configuration Values:**
| Variable | Development | Production |
|----------|-------------|------------|
| API Base URL | `http://localhost:3000` | Production API URL |
| Connect Timeout | 30000ms | 15000ms |
| Receive Timeout | 30000ms | 30000ms |
| Enable Logging | true | false |
| API Path | `/api/v1` | `/api/v1` |

### 3.2 Theme Configuration

**File:** `lib/core/config/theme_config.dart`

**Implementation Requirements:**
- Define primary color (brand color for L2L)
- Define color scheme (light mode for MVP)
- Define text themes (headline, title, body, caption)
- Define button themes (elevated, text, outlined)
- Define input decoration theme
- Use Google Fonts or system fonts

**Theme Tokens:**
| Token | Value |
|-------|-------|
| Primary Color | Blue (#2196F3 or similar) |
| Error Color | Red (#F44336) |
| Success Color | Green (#4CAF50) |
| Font Family | Inter or system default |
| Border Radius | 8dp (buttons), 12dp (cards) |

### 3.3 Dependencies

**File:** `pubspec.yaml`

**Required Dependencies (already configured):**
- `flutter_riverpod` - State management
- `go_router` - Navigation
- `dio` - HTTP client
- `pretty_dio_logger` - Request/response logging
- `shared_preferences` - Local storage for tokens
- `hive_flutter` - Optional local caching
- `freezed_annotation` + `json_annotation` - Data classes
- `intl` - Date formatting
- `url_launcher` - Open external URLs

**Required Dev Dependencies:**
- `build_runner` - Code generation
- `freezed` - Immutable data classes
- `json_serializable` - JSON serialization
- `flutter_lints` - Code style rules
- `mocktail` - Testing mocks

---

## 4. Core Infrastructure

### 4.1 Network Layer (Dio Client)

**File:** `lib/core/network/dio_client.dart`

**Responsibilities:**
- Singleton pattern for HTTP client
- Base configuration (base URL, timeouts, headers)
- Request interceptor for adding auth token
- Response interceptor for error handling
- Token refresh on 401 responses
- Structured error handling with custom exceptions

**Interceptor Flow:**
1. **Request Interceptor:**
   - Read stored access token from SecureStorage
   - Add `Authorization: Bearer <token>` header if token exists
   - Continue request

2. **Response Interceptor:**
   - On 401: Trigger token refresh or logout
   - On 4xx: Parse error message from response body
   - On 5xx: Return generic server error
   - On timeout: Return connection timeout message
   - On cancel: Return request cancelled message

**Error Handling:**
- Map HTTP status codes to user-friendly messages
- Create custom exception classes (AuthenticationException, ValidationException, NetworkException)
- Return Exception objects that UI can display in SnackBars

### 4.2 Secure Storage

**File:** `lib/core/storage/secure_storage.dart`

**Responsibilities:**
- Store access token securely (flutter_secure_storage)
- Store refresh token securely
- Retrieve tokens for API requests
- Clear tokens on logout
- Initialize storage on app start

**Storage Keys:**
| Key | Type | Description |
|-----|------|-------------|
| `access_token` | String | JWT access token |
| `refresh_token` | String | JWT refresh token |

### 4.3 Data Models

**File:** `lib/data/models/*.dart`

**Pattern:** Use Freezed for immutable data classes with JSON serialization

**Required Models:**

#### User
| Field | Type | Description |
|-------|------|-------------|
| id | String | User ID from MongoDB |
| email | String | User email address |
| name | String | User display name |

#### AuthRequest
| Field | Type | Description |
|-------|------|-------------|
| email | String | Login/Register email |
| password | String | Login/Register password |
| name | String? | Registration name |

#### AuthResponse
| Field | Type | Description |
|-------|------|-------------|
| user | UserModel | User data |
| accessToken | String | JWT access token |
| refreshToken | String | JWT refresh token |

#### Project
| Field | Type | Description |
|-------|------|-------------|
| id | String | Project ID |
| userId | String | Owner user ID |
| name | String | Project name |
| description | String? | Project description |
| aiOutputId | String? | Generated course ID |
| linkIds | List<String> | Associated link IDs |
| createdAt | DateTime | Creation timestamp |
| updatedAt | DateTime | Last update timestamp |

#### Link
| Field | Type | Description |
|-------|------|-------------|
| id | String | Link ID |
| userId | String | Owner user ID |
| url | String | Original URL |
| projectId | String? | Associated project ID |
| title | String? | Page title |
| aiOutputId | String? | AI output ID |
| tags | List<String> | User-assigned tags |
| status | LinkStatus | Processing status |
| statusMessage | String? | Error message if failed |
| summary | SummaryContent? | AI summary |
| flashcards | FlashcardsContent? | AI flashcards |
| createdAt | DateTime | Creation timestamp |
| updatedAt | DateTime | Last update timestamp |

#### LinkStatus (Enum)
- `pending` - Waiting to be processed
- `processing` - Currently being processed
- `completed` - Processing complete
- `failed` - Processing failed

#### SummaryContent
| Field | Type | Description |
|-------|------|-------------|
| keyPoints | List<String> | Main points from content |
| mainArgument | String | Core argument/thesis |
| takeaways | List<String> | Actionable takeaways |

#### Flashcard
| Field | Type | Description |
|-------|------|-------------|
| question | String | Front of card |
| answer | String | Back of card |
| difficulty | String | easy/medium/hard |

#### FlashcardsContent
| Field | Type | Description |
|-------|------|-------------|
| flashcards | List<Flashcard> | Array of flashcards |

#### Course (for Phase 2)
| Field | Type | Description |
|-------|------|-------------|
| title | String | Course title |
| description | String | Course description |
| lessons | List<CourseLesson> | Ordered lessons |

#### CourseLesson (for Phase 2)
| Field | Type | Description |
|-------|------|-------------|
| title | String | Lesson title |
| content | String | Lesson content |
| order | int | Lesson sequence |

#### Quiz (for Phase 2)
| Field | Type | Description |
|-------|------|-------------|
| questions | List<QuizQuestion> | Quiz questions |

#### QuizQuestion (for Phase 2)
| Field | Type | Description |
|-------|------|-------------|
| question | String | Question text |
| options | List<String> | Multiple choice options |
| correct | int | Index of correct answer |
| explanation | String | Answer explanation |

#### Job
| Field | Type | Description |
|-------|------|-------------|
| id | String | Job ID |
| userId | String | Owner user ID |
| type | String | process_link/generate_course |
| status | JobStatus | Job status |
| progress | int | Progress percentage (0-100) |
| data | Map<String, dynamic> | Job data |
| processedAt | DateTime? | Completion timestamp |

#### JobStatus (Enum)
- `waiting` - In queue
- `active` - Currently processing
- `completed` - Successfully completed
- `failed` - Failed with error
- `delayed` - Delayed retry

---

## 5. Screen Implementation Guide

### 5.1 Splash Screen

**File:** `lib/presentation/pages/splash/splash_page.dart`

**Purpose:** Initial loading screen while checking authentication state

**State Requirements:**
- No local state needed
- Triggers auth initialization on mount
- Auto-navigates based on auth state

**Logic Flow:**
1. On page load, initialize authentication (check for stored tokens)
2. If user is authenticated, navigate to Home
3. If not authenticated, navigate to Login
4. Display app logo and loading indicator during initialization

**UI Components:**
- Centered app logo/icon
- Loading indicator (CircularProgressIndicator)
- App name/tagline

**Navigation:**
- Auto-redirects to `/login` or `/` based on auth state
- No user interaction required

---

### 5.2 Login Screen

**File:** `lib/presentation/pages/auth/login_page.dart`

**Purpose:** User authentication

**State Requirements (via Riverpod):**
- Email input
- Password input
- Loading state
- Error message
- Obscure password toggle

**API Integration:**
- Call `AuthService.login(email, password)`
- On success: Store tokens, navigate to Home
- On failure: Display error message

**Form Validation:**
- Email: Required, must contain @
- Password: Required, minimum 6 characters

**UI Components:**
- App logo/header
- Email text field
- Password text field with show/hide toggle
- Sign In button (full width)
- Loading indicator on button during submission
- "Don't have an account? Sign up" link to Register

**Navigation:**
- Success: Navigate to Home (`/`)
- Register link: Navigate to Register (`/register`)

**Error Handling:**
- Display validation errors inline
- Display API errors in SnackBar
- Clear error on retry

---

### 5.3 Signup Screen

**File:** `lib/presentation/pages/auth/register_page.dart`

**Purpose:** User registration

**State Requirements (via Riverpod):**
- Name input
- Email input
- Password input
- Confirm password input
- Loading state
- Error message
- Obscure password toggles

**API Integration:**
- Call `AuthService.register(name, email, password)`
- Backend expects: `firstName`, `lastName`, `email`, `password`, `username`
- For MVP: Split name into firstName/lastName, use email as username
- On success: Store tokens, navigate to Home
- On failure: Display error message

**Form Validation:**
- Name: Required, minimum 2 characters
- Email: Required, must contain @, valid format
- Password: Required, minimum 6 characters
- Confirm Password: Required, must match password

**UI Components:**
- Back button (app bar)
- Name text field
- Email text field
- Password text field with show/hide toggle
- Confirm Password text field with show/hide toggle
- Sign Up button (full width)
- Loading indicator on button during submission
- "Already have an account? Sign in" link to Login

**Navigation:**
- Success: Navigate to Home (`/`)
- Back button: Navigate to Login (`/login`)

**Error Handling:**
- Display validation errors inline
- Display API errors in SnackBar
- Handle "user already exists" (409 Conflict) gracefully

---

### 5.4 Home Screen (Main Container with Tabs)

**File:** `lib/presentation/pages/main_container/main_container_page.dart`

**Purpose:** Main app navigation with bottom tabs

**State Requirements:**
- Current tab index
- No complex state (delegates to child screens)

**Tabs:**
| Index | Tab | Screen |
|-------|-----|--------|
| 0 | Home | HomePage (Feed with recent projects and links) |
| 1 | Projects | ProjectsListPage |
| 2 | Profile | ProfilePage |

**UI Components:**
- Scaffold with BottomNavigationBar
- IndexedStack to preserve tab state
- Dynamic body based on selected tab

**Navigation:**
- Tab 0: Home/Feed (default) - shows recent projects and links
- Tab 1: Projects list
- Tab 2: Profile

---

### 5.5 Home/Feed Screen

**File:** `lib/presentation/pages/home/home_page.dart`

**Purpose:** Display recent projects and links as a dashboard

**State Requirements (via Riverpod):**
- List of recent projects
- List of recent links
- Loading states

**API Integration:**
- Load projects: `ProjectService.getProjects()` on screen load
- Load links: `LinkService.getLinks()` on screen load

**UI Components:**
- AppBar with "Home" title
- Add Link button in AppBar actions
- ScrollView with:
  - Recent Projects section (horizontal scrollable list)
  - Recent Links section (vertical list)

**Navigation:**
- Add Link button: Navigate to Add Link (`/add-link`)
- Project tap: Navigate to Project Details (`/projects/:id`)
- Link tap: Navigate to Link Details (`/links/:id`)

---

### 5.6 Profile Screen

**File:** `lib/presentation/pages/profile/profile_page.dart`

**Purpose:** Display user info and app settings

**State Requirements (via Riverpod):**
- Current user data from auth state
- Loading state

**API Integration:**
- Load user from auth state (already authenticated)
- Logout clears tokens and navigates to Login

**UI Components:**
- CircleAvatar with user initial
- User name (headline)
- User email (subtitle)
- Menu items (placeholder for Phase 2):
  - Settings
  - Help & Support
  - About
- Log Out button with confirmation dialog

**Navigation:**
- Logout: Confirm dialog, clear auth state, redirect to Login (`/login`)
- Menu items: Placeholder for Phase 2

---

### 5.7 Projects List Screen

**File:** `lib/presentation/pages/projects/projects_list_page.dart`

**Purpose:** Display all user projects

**State Requirements (via Riverpod):**
- List of projects
- Loading state
- Error message
- Refresh state (pull-to-refresh)

**API Integration:**
- Call `ProjectService.getProjects()` on screen load
- Pull-to-refresh triggers reload

**UI Components:**
- App bar with "Projects" title
- ListView of project cards using `ProjectCard` widget
- Empty state: "No Projects Yet" with hint "Create a project while adding a new link"
- Loading indicator during fetch
- Pull-to-refresh (RefreshIndicator)

**Project Card:**
- Reusable `ProjectCard` widget
- Project name (title)
- Description (subtitle, truncated)
- Link count badge
- Created date
- Chevron trailing icon

**Navigation:**
- Tap project: Navigate to Project Details (`/projects/:id`)

**Empty State:**
- Icon (folder_outlined)
- "No Projects Yet" message
- "Create a project while adding a new link" hint

---

### 5.7.5 Create Project (Inline from Add Link)

**Note:** For MVP simplicity, project creation is integrated into the Add Link screen. Users can create a new project by typing a new project name in the project autocomplete field while adding a link.

**File:** `lib/presentation/pages/links/add_link_page.dart` (Project creation logic)

**Purpose:** Create a new learning project inline while adding a link

**Flow:**
1. User navigates to Add Link screen
2. In the Project autocomplete field, user types a new project name
3. If no existing project matches, a "New project" indicator appears
4. When the link is saved, the new project is created first
5. The link is then associated with the newly created project

**API Integration:**
- Check existing projects: `ProjectService.getProjects()`
- Create project: `ProjectService.createProject(name)` when user saves link with new project name
- On success: Project created, link saved with projectId
- On failure: Display error message

**UI Components:**
- Autocomplete text field for project selection
- "New project" indicator when typing unknown name
- Inline creation happens automatically on link save

---

### 5.8 Project Details Screen

**File:** `lib/presentation/pages/projects/project_detail_page.dart`

**Purpose:** Display project info, associated links, and trigger course generation

**State Requirements (via Riverpod):**
- Project data (from `projectByIdProvider`)
- List of links for this project (from `projectLinksProvider`)
- Loading state
- Course generation loading state

**API Integration:**
- Load project: `ProjectRepository.getProject(projectId)`
- Load links: `ProjectLinksProvider` (filtered by projectId)
- Generate course: `ProjectRepository.generateCourse(projectId)`
- Delete project: `ProjectRepository.deleteProject(projectId)`

**UI Components:**
- App bar with project name
- Edit button (app bar action) - Navigate to Edit Project
- Delete button (app bar action) - Show confirmation dialog

**Sections:**

1. **Project Info Card:**
   - Project name (headline)
   - Description (body text, if available)
   - Created date with icon

2. **Generate Course Card:**
   - Icon (school) + "AI Course Generation" title
   - Description ("Generate a structured course from all links in this project")
   - Generate Course button (full width)
   - Loading state during generation
   - Success message with job ID

3. **Links Section:**
   - Section title with link count (e.g., "Links (5)")
   - List of `LinkCard` widgets
   - Empty state if no links

**Link Card (in project):**
- Reusable `LinkCard` widget
- Status icon (pending/processing/completed/failed)
- Link title/domain
- Summary preview (truncated)
- Chevron trailing

**Navigation:**
- Edit: Navigate to Edit Project (`/projects/:projectId/edit`)
- Delete: Show confirmation dialog, delete, then pop to Projects List
- Link tap: Navigate to Link Details (`/links/:id`)
- Generate Course: Show success SnackBar with job ID

**Empty Links State:**
- Icon (link_off)
- "No links yet" message
- "Add links to this project from the links page" hint

**Error Handling:**
- Display API errors in SnackBar
- Show failed link status in list

---

### 5.9 Links List Screen

**File:** `lib/presentation/pages/links/links_list_page.dart`

**Purpose:** Display all user links with filtering and search options

**State Requirements (via Riverpod):**
- List of links
- Loading state
- Error message
- Current tag filter (selected tags)
- Search query
- All available tags (for filter chips)

**API Integration:**
- Call `LinkService.getLinks()` on screen load
- Pull-to-refresh triggers reload

**UI Components:**
- App bar with "My Links" title
- Search button in app bar actions
- Tags filter section (horizontal scrollable chips)
- ListView of link cards using `LinkCard` widget
- Empty state: "No links yet" with hint
- Loading indicator during fetch
- Pull-to-refresh (RefreshIndicator)

**Tags Filter:**
- Horizontal scrollable list of FilterChip widgets
- Shows all unique tags from user's links
- Selected tags filter the links list
- "Clear" chip to reset filters when tags are selected

**Search:**
- Search icon in app bar opens search overlay
- Real-time filtering as user types
- Clear button to reset search
- Shows "No results found" when empty

**Link Card:**
- Reusable `LinkCard` widget
- Status icon (color-coded: pending=orange, processing=blue, completed=green, failed=red)
- Link title/domain (title)
- Summary preview or tags (subtitle)
- Chevron trailing icon

**Navigation:**
- Tap link: Navigate to Link Details (`/links/:id`)
- Search: Opens search overlay

**Empty States:**
- No links: Icon (bookmark_outline), "No links yet", "Tap + to save your first link"
- No search results: Icon (search_off), "No matching links"
- Error: Error icon, error message, Retry button

---

### 5.10 Add Link Screen

**File:** `lib/presentation/pages/links/add_link_page.dart`

**Purpose:** Save a new link to L2L

**State Requirements:**
- URL input (required)
- Title input (optional)
- Selected project (optional, via autocomplete)
- Tags input (optional, comma-separated)
- Loading state
- Error message
- List of projects (for autocomplete)

**API Integration:**
- Load projects: `ProjectService.getProjects()` (for autocomplete)
- Create project (if new name typed): `ProjectService.createProject(name)`
- Create link: `LinkService.createLink(url, projectId, title, tags)`
- On success: Navigate back with success message
- On failure: Display error message

**Form Validation:**
- URL: Required, valid URL format
- Title: Optional
- Project: Optional (can create new by typing new name)
- Tags: Optional, comma-separated

**UI Components:**
- AppBar with "Add Link" title and close button
- URL text field (required)
- Title text field (optional)
- Tags text field (optional, with helper text "Separate tags with commas")
- Project autocomplete field with:
  - Search functionality
  - Display of existing projects with link count
  - "New project" indicator when typing unknown name
- Save button (full width) with loading indicator

**Project Autocomplete Behavior:**
- Shows all projects when empty
- Filters projects by search text
- When user types a new name (no match), shows "New project" indicator
- On save, creates new project if needed, then saves link with projectId

**Navigation:**
- Presentation: Full-screen page
- Success: Pop back to previous screen with success message
- Close button: Pop without saving

**Error Handling:**
- Display validation errors inline
- Display API errors in SnackBar
- Handle invalid URLs gracefully

**MVP Simplification:**
- Only URL is required
- Title, project, and tags are optional enhancements
- Project creation is inline (no separate create project screen)

---

### 5.11 Link Details Screen

**File:** `lib/presentation/pages/links/link_details_page.dart`

**Purpose:** Display link info, AI summary, and flashcards

**State Requirements (via Riverpod):**
- Link data
- Loading state
- Error message

**API Integration:**
- Load link: `LinkService.getLinkById(linkId)`

**UI Components:**
- App bar with link title/domain
- External link button (app bar action) - Opens URL in browser
- Status banner (if processing/failed)

**Sections:**

1. **Link Info Card:**
   - Original URL (copyable, truncated)
   - Project tag (if assigned)
   - Tags chips (if any)
   - Created date
   - Status badge

2. **Summary Card (when completed):**
   - Section title "Summary"
   - Main argument (body text)
   - Key points (bulleted list)
   - Takeaways (bulleted list)

3. **Flashcards Card (when completed):**
   - Section title "Flashcards"
   - Card counter (e.g., "10 flashcards")
   - Expandable list of flashcards
   - Each flashcard: Question (visible), Answer (tap to reveal)

**Status States:**

- **Pending:** "Waiting to be processed..." with spinner
- **Processing:** "AI is analyzing content..."
- **Completed:** Show full summary and flashcards
- **Failed:** Show error message with retry option

**Navigation:**
- External link: Launch URL in browser (url_launcher)
- Back: Pop to previous screen

**Empty/Loading States:**
- Show skeleton loaders while fetching
- Show "Processing..." state with progress indicator
- Show error state with retry button if failed

---

## 6. State Management Patterns

### 6.1 Riverpod Provider Structure

**Pattern:** StateNotifier for complex state, Provider for services

**Auth Providers:**
```
authRepositoryProvider → Provider<AuthRepository>
authProvider → StateNotifierProvider<AuthNotifier, AuthState>
isAuthenticatedProvider → Provider<bool> (derived)
currentUserProvider → Provider<UserModel?> (derived)
authLoadingProvider → Provider<bool> (derived)
authErrorProvider → Provider<String?> (derived)
```

**Project Providers:**
```
projectServiceProvider → Provider<ProjectService>
projectsProvider → StateNotifierProvider<ProjectsNotifier, ProjectsState>
projectByIdProvider → Provider.family<ProjectModel?, String> (derived)
selectedProjectProvider → Provider<ProjectModel?> (derived)
```

**Link Providers:**
```
linkServiceProvider → Provider<LinkService>
linksProvider → StateNotifierProvider<LinksNotifier, LinksState>
linkByIdProvider → Provider.family<LinkModel?, String> (derived)
```

### 6.2 State Class Pattern

**Structure:**
```
class [Feature]State {
  final List<[Model]> items;
  final bool isLoading;
  final String? error;
  final [AdditionalState] selected[Item];

  [Feature]State({
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.selected[Item],
  });

  [Feature]State copyWith({
    List<[Model]>? items,
    bool? isLoading,
    String? error,
    [AdditionalState]? selected[Item],
  }) {
    return [Feature]State(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selected[Item]: selected[Item] ?? this.selected[Item],
    );
  }
}
```

### 6.3 StateNotifier Pattern

**Structure:**
```
class [Feature]Notifier extends StateNotifier<[Feature]State> {
  final [Feature]Service _service;

  [Feature]Notifier(this._service) : super([Feature]State()) {
    _initialize();
  }

  Future<void> load[Items]() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final items = await _service.getItems();
      state = [Feature]State(items: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        items: state.items,
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<[Model]?> create[Item]({...params}) async {
    try {
      final newItem = await _service.createItem(...params);
      state = state.copyWith(items: [...state.items, newItem]);
      return newItem;
    } catch (e) {
      state = state.copyWith(error: e.toString().replaceAll('Exception: ', ''));
      return null;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
```

### 6.4 Usage in Screens

**Pattern:**
```dart
class [Screen] extends ConsumerStatefulWidget {
  @override
  ConsumerState<[Screen]> createState() => _[Screen]State();
}

class _[Screen]State extends ConsumerState<[Screen]> {
  @override
  void initState() {
    super.initState();
    // Trigger data loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read([feature]Provider.notifier).load[Items]();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch([feature]Provider);
    final notifier = ref.read([feature]Provider.notifier);

    if (state.isLoading) return LoadingWidget();
    if (state.error != null) return ErrorWidget(message: state.error!);
    if (state.items.isEmpty) return EmptyStateWidget();

    return // Main content using state.items
  }
}
```

---

## 7. API Integration

### 7.1 Service Layer Pattern

**File:** `lib/data/services/[feature]_service.dart`

**Responsibilities:**
- Direct HTTP calls via DioClient
- Request/response mapping
- Error handling and transformation
- No business logic (pure API calls)

**Pattern:**
```dart
class [Feature]Service {
  final DioClient _dioClient = DioClient.instance;

  Future<[Model]> getItem(String id) async {
    try {
      final response = await _dioClient.dio.get('/[feature]/$id');
      if (response.statusCode == 200) {
        return [Model].fromJson(response.data['data']);
      }
      throw Exception('Failed to fetch [item]');
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }

  Future<List<[Model]>> getItems({...params}) async {
    try {
      final response = await _dioClient.dio.get(
        '/[feature]',
        queryParameters: {...params},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => [Model].fromJson(json)).toList();
      }
      throw Exception('Failed to fetch [items]');
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }

  Future<[Model]> createItem({...params}) async {
    try {
      final response = await _dioClient.dio.post(
        '/[feature]',
        data: {...params},
      );
      if (response.statusCode == 201) {
        return [Model].fromJson(response.data['data']);
      }
      throw Exception('Failed to create [item]');
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }
}
```

### 7.2 Repository Layer Pattern

**File:** `lib/data/repositories/[feature]_repository.dart`

**Responsibilities:**
- Business logic
- Multiple service coordination
- Token management (for auth)
- Data transformation

**Pattern (Auth Repository):**
```dart
class AuthRepository {
  final AuthService _authService = AuthService();
  final SecureStorage _storage = SecureStorage();

  Future<UserModel?> initializeAuth() async {
    final accessToken = await _storage.getAccessToken();
    if (accessToken != null) {
      try {
        // Validate token by fetching user
        final user = await _authService.getCurrentUser();
        return user;
      } catch (e) {
        // Token expired, try refresh
        final refreshed = await refreshAuthToken();
        if (refreshed) {
          return await _authService.getCurrentUser();
        }
      }
    }
    return null;
  }

  Future<AuthResult> login(String email, String password) async {
    try {
      final response = await _authService.login(email, password);
      await _storage.saveTokens(response.accessToken, response.refreshToken);
      return AuthResult(success: true, user: response.user);
    } catch (e) {
      return AuthResult(success: false, error: e.toString());
    }
  }

  Future<bool> refreshAuthToken() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _authService.refreshToken(refreshToken);
      await _storage.saveTokens(response.accessToken, response.refreshToken);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.clearTokens();
  }
}
```

### 7.3 API Endpoint Mapping

| Screen | Action | Method | Endpoint | Service |
|--------|--------|--------|----------|---------|
| Login | Authenticate | POST | /auth/login | AuthService |
| Signup | Register | POST | /auth/register | AuthService |
| Profile | Get current user | GET | /auth/me | AuthService |
| Projects List | Fetch projects | GET | /projects | ProjectService |
| Create Project | Create project | POST | /projects | ProjectService |
| Project Details | Get project | GET | /projects/:id | ProjectService |
| Project Details | Generate course | POST | /projects/:id/generate-course | ProjectService |
| Links List | Fetch links | GET | /links | LinkService |
| Add Link | Create link | POST | /links | LinkService |
| Link Details | Get link | GET | /links/:id | LinkService |
| Jobs | Check job status | GET | /jobs/:jobId | JobService |

### 7.4 Response Format

**Backend Response Structure:**
```json
{
  "success": true,
  "data": { ... },
  "message": "Optional message"
}
```

**Error Response Structure:**
```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable message"
  }
}
```

**Parsing Pattern:**
```dart
// Success
if (response.data['success'] == true) {
  return Model.fromJson(response.data['data']);
}

// Error
final error = response.data['error'];
throw Exception(error['message'] ?? 'Unknown error');
```

---

## 8. Navigation & Routing

### 8.1 GoRouter Configuration

**File:** `lib/core/router/app_router.dart`

**Route Definitions:**

| Path | Name | Screen | Auth Required |
|------|------|--------|---------------|
| /splash | splash | SplashPage | No |
| /login | login | LoginPage | No |
| /register | register | RegisterPage | No |
| / | home | MainContainerPage (Home tab) | Yes |
| /links | links | LinksListPage | Yes |
| /links/:id | link_details | LinkDetailsPage | Yes |
| /add-link | add_link | AddLinkPage | Yes |
| /profile | profile | MainContainerPage (Profile tab) | Yes |
| /projects | projects | MainContainerPage (Projects tab) | Yes |
| /projects/:projectId | project_detail | ProjectDetailPage | Yes |
| /projects/:projectId/edit | edit_project | EditProjectPage | Yes |

**Bottom Navigation Structure:**
```
┌─────────────────────────────────────────────┐
│  Home  │  Projects  │  Profile             │
├─────────────────────────────────────────────┤
```

**Main Container Pages:**
- Home tab (index 0): `HomePage` - Shows recent projects and links
- Projects tab (index 1): `ProjectsListPage` - Shows all projects
- Profile tab (index 2): `ProfilePage` - Shows user info

### 8.2 Auth Redirect Logic

**Redirect Rules:**
1. **Initializing:** Stay on splash while checking auth
2. **Unauthenticated + Protected Route:** Redirect to /login
3. **Authenticated + Auth Route:** Redirect to /
4. **Authenticated + Protected Route:** Allow access

**Implementation:**
```dart
redirect: (context, state) {
  final isInitializing = authState.isLoading && authState.user == null;
  final isAuthenticated = authState.isAuthenticated;
  final isLoggingIn = state.matchedLocation == '/login' ||
                      state.matchedLocation == '/register';
  final isSplash = state.matchedLocation == '/splash';

  if (isSplash) {
    if (!isInitializing) {
      return isAuthenticated ? '/' : '/login';
    }
    return null;
  }

  if (!isAuthenticated && !isLoggingIn) {
    return '/login';
  }

  if (isAuthenticated && isLoggingIn) {
    return '/';
  }

  return null;
}
```

### 8.3 Navigation Patterns

**Programmatic Navigation:**
```dart
// Push (add to stack)
context.push('/projects/$projectId');

// Go (replace current)
context.go('/');

// Pop
context.pop();

// With result
final result = await context.push<bool>('/add-link');
if (result == true) {
  // Refresh list
}
```

**Named Routes:**
```dart
context.pushNamed('project_detail', pathParameters: {'projectId': projectId});
context.goNamed('home');
```

---

## 9. MVP Verification Checklist

### Phase 1: Foundation

- [ ] Project runs on iOS simulator/emulator
- [ ] Project runs on Chrome (web)
- [ ] All dependencies resolved
- [ ] Environment configuration loads correctly
- [ ] DioClient connects to backend
- [ ] SecureStorage saves/retrieves tokens
- [ ] Router navigates between screens

### Phase 2: Authentication

- [ ] User can register with valid email/password
- [ ] User can login with registered credentials
- [ ] Invalid credentials show error message
- [ ] Auth state persists across app restarts
- [ ] Logout clears tokens and redirects to login
- [ ] Protected routes redirect unauthenticated users

### Phase 3: Projects

- [ ] User can view list of projects from Projects tab
- [ ] Project list shows empty state with helpful message
- [ ] User can view project details
- [ ] Empty state displays when no projects exist
- [ ] Pull-to-refresh works on projects list

### Phase 4: Links

- [ ] User can view list of links from Links page
- [ ] User can add new link via URL from Home screen FAB
- [ ] Link shows processing status (pending/processing/completed/failed)
- [ ] Completed links display AI summary
- [ ] Completed links display flashcards
- [ ] Links can be filtered by tags
- [ ] Links can be searched
- [ ] Empty state displays when no links exist
- [ ] Pull-to-refresh works on links list

### Phase 5: Integration

- [ ] Link can be assigned to project on creation
- [ ] New project can be created inline while adding a link
- [ ] Project details show associated links
- [ ] User can trigger course generation
- [ ] Course generation shows success message with job ID
- [ ] End-to-end flow: Register → Add Link (with new project) → View Summary

### Phase 6: Polish

- [ ] All loading states display correctly
- [ ] All error states display user-friendly messages
- [ ] Pull-to-refresh works on list screens
- [ ] Navigation back buttons work correctly
- [ ] App handles network errors gracefully
- [ ] App handles API errors gracefully

---

## Appendix A: Backend API Reference

### Authentication

| Method | Endpoint | Auth | Request Body | Response |
|--------|----------|------|--------------|----------|
| POST | /auth/register | No | { email, password, name, username, firstName, lastName } | { user, accessToken, refreshToken } |
| POST | /auth/login | No | { email, password } | { user, accessToken, refreshToken } |
| POST | /auth/refresh | No | { refreshToken } | { accessToken, refreshToken } |
| GET | /auth/me | Yes | - | { user } |

### Projects

| Method | Endpoint | Auth | Request Body | Response |
|--------|----------|------|--------------|----------|
| GET | /projects | Yes | - | { projects: [Project] } |
| POST | /projects | Yes | { name, description } | { project } |
| GET | /projects/:id | Yes | - | { project } |
| PUT | /projects/:id | Yes | { name?, description? } | { project } |
| DELETE | /projects/:id | Yes | - | { success: true } |
| POST | /projects/:id/generate-course | Yes | - | { jobId } |

### Links

| Method | Endpoint | Auth | Request Body | Response |
|--------|----------|------|--------------|----------|
| GET | /links | Yes | - | { links: [Link] } |
| GET | /links?projectId=:id | Yes | - | { links: [Link] } |
| POST | /links | Yes | { url, projectId?, tags? } | { link, jobId } |
| GET | /links/:id | Yes | - | { link } |
| PUT | /links/:id | Yes | { title?, tags? } | { link } |
| DELETE | /links/:id | Yes | - | { success: true } |

### Jobs

| Method | Endpoint | Auth | Response |
|--------|----------|------|----------|
| GET | /jobs/:jobId | Yes | { job } |

---

## Appendix B: Data Model JSON Examples

### User
```json
{
  "_id": "507f1f77bcf86cd799439011",
  "email": "user@example.com",
  "name": "John Doe",
  "createdAt": "2026-03-26T10:00:00.000Z",
  "updatedAt": "2026-03-26T10:00:00.000Z"
}
```

### Project
```json
{
  "_id": "507f1f77bcf86cd799439012",
  "userId": "507f1f77bcf86cd799439011",
  "name": "React Mastery",
  "description": "Learn React from scratch",
  "aiOutputId": null,
  "linkIds": [],
  "createdAt": "2026-03-26T10:00:00.000Z",
  "updatedAt": "2026-03-26T10:00:00.000Z"
}
```

### Link (Pending)
```json
{
  "_id": "507f1f77bcf86cd799439013",
  "userId": "507f1f77bcf86cd799439011",
  "url": "https://react.dev/learn",
  "projectId": "507f1f77bcf86cd799439012",
  "title": "Learn React - Official Docs",
  "aiOutputId": null,
  "tags": ["react", "frontend"],
  "status": "pending",
  "statusMessage": null,
  "createdAt": "2026-03-26T10:00:00.000Z",
  "updatedAt": "2026-03-26T10:00:00.000Z"
}
```

### Link (Completed)
```json
{
  "_id": "507f1f77bcf86cd799439013",
  "userId": "507f1f77bcf86cd799439011",
  "url": "https://react.dev/learn",
  "projectId": "507f1f77bcf86cd799439012",
  "title": "Learn React - Official Docs",
  "aiOutputId": "507f1f77bcf86cd799439020",
  "tags": ["react", "frontend"],
  "status": "completed",
  "statusMessage": null,
  "summary": {
    "keyPoints": ["Components are the building blocks", "Props pass data down", "State manages dynamic data"],
    "mainArgument": "React is a library for building user interfaces using components",
    "takeaways": ["Learn component composition", "Master props and state", "Understand the virtual DOM"]
  },
  "flashcards": {
    "flashcards": [
      {
        "question": "What is a component in React?",
        "answer": "A reusable piece of UI that can manage its own state and props",
        "difficulty": "easy"
      }
    ]
  },
  "createdAt": "2026-03-26T10:00:00.000Z",
  "updatedAt": "2026-03-26T10:05:00.000Z"
}
```

---

**Document End**
