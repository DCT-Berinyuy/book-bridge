# BookBridge Implementation Plan

This document outlines the phased implementation plan for building the BookBridge application.

## Journal

### Phase 1 - Initial Setup (January 25, 2026)

*   **Action:** Initialized a new Flutter project in `/home/dct/Desktop/Projects/book_bridge` using `create_project`.
*   **Action:** Added `supabase_flutter`, `provider`, `go_router`, `intl`, `image_picker`, `url_launcher`, `equatable`, `get_it`, `dartz` dependencies to `pubspec.yaml`.
*   **Action:** Updated `pubspec.yaml` description.
*   **Action:** Removed `test/` directory.
*   **Action:** Replaced boilerplate code in `lib/main.dart` with minimal structure.
*   **Action:** Created placeholder `README.md`.
*   **Action:** Created `CHANGELOG.md`.
*   **Action:** Committed initial setup to `main` branch.
*   **Learning:** Encountered persistent "No such file or directory" error when attempting to launch the app via `launch_app` tool on both `linux` and `chrome` devices. This appears to be an environmental issue with the `flutter` command invocation itself, rather than a problem with the project or device selection. I am currently unable to automatically launch the app.

### Phase 2 - Core Architecture and Theming (January 25, 2026)

*   **Action:** Created complete directory structure for Clean Architecture with core and features layers.
*   **Action:** Implemented error handling with Failure and Exception classes in `lib/core/error/`.
*   **Action:** Created base UseCase classes (UseCase<ResultType, Params> and UseCaseNoParams<ResultType>) in `lib/core/usecases/`.
*   **Action:** Set up dependency injection framework with get_it in `lib/injection_container.dart`.
*   **Action:** Implemented comprehensive dark theme with AppTheme class in `lib/core/theme/app_theme.dart`.
*   **Action:** Updated `lib/main.dart` to integrate the theme, async initialization, and DI setup.
*   **Action:** Ran `dart fix --apply` and fixed 2 deprecated member usage issues.
*   **Action:** Ran `flutter analyze` - verified 0 issues after fixes.
*   **Action:** Ran `dart format .` - all files properly formatted.

### Phase 3 - Authentication Feature (January 25, 2026)

*   **Action:** Implemented complete authentication domain layer:
    - Created User entity with equatable
    - Created AuthRepository interface with CRUD operations
    - Created use cases: SignUpUseCase, SignInUseCase, SignOutUseCase, GetCurrentUserUseCase
*   **Action:** Implemented complete authentication data layer:
    - Created UserModel DTO with JSON serialization
    - Created SupabaseAuthDataSource with all auth operations
    - Created AuthRepositoryImpl bridging domain and data layers
*   **Action:** Implemented authentication presentation layer:
    - Created AuthViewModel with state management (AuthState enum)
    - Created SignInScreen with form validation
    - Created SignUpScreen with form validation and password confirmation
*   **Action:** Set up navigation and routing:
    - Created app router using go_router with auth state redirection
    - Added SplashScreen and HomeScreen (placeholders)
    - Implemented automatic navigation based on auth state
*   **Action:** Updated dependency injection container with all auth feature dependencies
*   **Action:** Updated main.dart:
    - Integrated Supabase initialization
    - Set up MultiProvider for AuthViewModel
    - Configured MaterialApp.router with go_router
*   **Action:** Renamed AuthException to AuthAppException to avoid conflicts with supabase_flutter
*   **Action:** Ran `dart fix --apply` and `dart format .`
*   **Action:** Ran `flutter analyze` - verified 0 issues after fixes
*   **Commit:** `ad1f09c` - Phase 3 Authentication Feature

### Phase 4 - Listings, Home Feed, and Details (January 25, 2026)

*   **Action:** Implemented complete listings domain layer:
    - Created Listing entity with equatable (9 properties)
    - Created ListingRepository interface with CRUD operations
    - Created use cases: GetListingsUseCase, GetListingDetailsUseCase
*   **Action:** Implemented complete listings data layer:
    - Created ListingModel DTO with JSON serialization and entity conversion
    - Created SupabaseListingsDataSource with 4 query methods (getListings with pagination, getListingDetails, getListingsBySeller, searchListings)
    - Created ListingRepositoryImpl with exception-to-failure mapping
*   **Action:** Implemented listings presentation layer:
    - Created HomeViewModel with pagination state management (50-item page size, offset tracking, hasMoreListings flag)
    - Created ListingDetailsViewModel for single listing display
    - Created HomeScreen with GridView (2-column layout), infinite scroll pagination, pull-to-refresh, error handling
    - Created ListingDetailsScreen with book details, images, seller info, WhatsApp contact button
*   **Action:** Updated router configuration with new routes (/listing/:id and others)
*   **Action:** Updated dependency injection for listings feature
*   **Action:** Updated main.dart with ViewModels in MultiProvider
*   **Action:** Applied code quality fixes (dart fix, flutter analyze, dart format)
*   **Commit:** `0a11661` - Phase 4 Listings Feature with Home Feed and Details Screen

### Phase 5 - Sell and Profile Features (January 25, 2026)

*   **Action:** Extended domain layer:
    - Created CreateListingUseCase with CreateListingParams
    - Created DeleteListingUseCase with DeleteListingParams
    - Created GetUserListingsUseCase with GetUserListingsParams
    - Extended ListingRepository interface with createListing and deleteListing methods
*   **Action:** Extended data layer:
    - Implemented createListing in SupabaseListingsDataSource (inserts to listings table)
    - Implemented deleteListing in SupabaseListingsDataSource (deletes from listings table)
    - Updated ListingRepositoryImpl with new methods
*   **Action:** Implemented sell feature:
    - Created SellViewModel with form state management (title, author, price, condition, image, description)
    - Implemented form validation and listing creation flow
    - Created SellScreen with comprehensive form UI (text inputs, price input, condition dropdown, image placeholder, error display, loading states)
*   **Action:** Implemented profile feature:
    - Created ProfileViewModel for user profile and listings management
    - Implemented profile loading, listing fetching, and deletion
    - Created ProfileScreen with user profile card, active listings management, view/delete options, sign out functionality
*   **Action:** Updated router with /sell and /profile routes
*   **Action:** Updated dependency injection container with all new use cases and view models
*   **Action:** Updated main.dart with SellViewModel and ProfileViewModel in MultiProvider
*   **Action:** Applied code quality fixes (dart fix, flutter analyze, dart format)
*   **Commit:** `87d7adc` - Phase 5 Sell and Profile Features

---

## Phase 1: Project Initialization and Setup

In this phase, the goal is to create the Flutter project, clean up boilerplate, and establish a baseline for development.

- [x] Create a new empty Flutter package named `book_bridge` in the current directory (`/home/dct/Desktop/Projects/book_bridge`).
- [x] Add the following dependencies to `pubspec.yaml`:
  - `supabase_flutter`
  - `provider`
  - `go_router`
  - `intl` (for currency formatting)
  - `image_picker`
  - `url_launcher`
  - `equatable` (for model comparisons)
  - `get_it` (for dependency injection)
  - `dartz` (for functional programming, especially `Either`)
- [x] Update the description in `pubspec.yaml` to "A peer-to-peer marketplace for Cameroonian students to buy and sell used physical books." and set the version to `0.1.0`.
- [x] Remove the `test/` directory and any boilerplate code in `lib/main.dart`.
- [x] Create a placeholder `README.md` with a short description of the package.
- [x] Create a `CHANGELOG.md` file with an initial entry for version `0.1.0`.
- [x] Commit this empty version of the package to the `main` branch.
- [ ] After committing the change, start running the app with the `launch_app` tool on the user's preferred device. *(Blocked: See Journal for details)*

**End of Phase 1 Checklist:**

- [ ] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
- [ ] Run `dart fix --apply` to clean up the code.
- [ ] Run `flutter analyze` and fix any issues.
- [ ] Run `dart format .` to ensure correct formatting.
- [ ] Re-read the `IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
- [ ] Update the `IMPLEMENTATION.md` file with the current state in the Journal section. Check off completed tasks.
- [ ] Create a suitable commit message for the changes and present it for approval.
- [ ] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.

---

## Phase 2: Core Architecture and Theming

In this phase, the goal is to establish the core architectural layers (Clean Architecture), set up dependency injection, and implement the application's dark theme.

- [x] Create the directory structure for Clean Architecture: `lib/core`, `lib/features`.
- [x] Create the directory structure for the `auth` feature: `lib/features/auth/data`, `lib/features/auth/domain`, `lib/features/auth/presentation`.
- [x] Create the directory structure for the `listings` feature: `lib/features/listings/data`, `lib/features/listings/domain`, `lib/features/listings/presentation`.
- [x] Implement the core error handling classes (`Failure`, `Exception`) in `lib/core/error/`.
- [x] Implement the base `UseCase` class in `lib/core/usecases/`.
- [x] Set up dependency injection using `get_it` in a `lib/injection_container.dart` file.
- [x] Implement the dark theme using `ThemeData` and `ColorScheme` in a dedicated `lib/core/theme/` directory.
- [x] Configure `main.dart` to use the theme and set up the `MaterialApp`.

**End of Phase 2 Checklist:**

- [x] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
- [x] Run `dart fix --apply`.
- [x] Run `flutter analyze`.
- [x] Run `dart format .`.
- [x] Re-read `IMPLEMENTATION.md` for any changes.
- [x] Update `IMPLEMENTATION.md` with progress.
- [ ] Create a commit message for approval.
- [ ] Wait for approval.
- [ ] After committing, use `hot_reload` if the app is running.

---

## Phase 3: Authentication Feature

In this phase, the goal is to implement the complete authentication flow, including sign-up, sign-in, and session management.

- [x] **Domain Layer:** Define `AuthRepository` interface, `User` entity, and `SignUp`, `SignIn`, `SignOut`, `GetCurrentUser` use cases.
- [x] **Data Layer:** Implement `AuthRepository` with `SupabaseAuthDataSource`. Implement `UserModel` (DTO).
- [x] **Presentation Layer:**
    - Create `AuthViewModel` (`ChangeNotifier`) to manage auth state.
    - Create `SignInScreen` and `SignUpScreen` widgets.
    - Implement navigation logic using `go_router` to handle authenticated and unauthenticated states.
    - Connect the UI to the `AuthViewModel`.
- [ ] **Supabase Setup:** Configure Supabase Auth with email/password and set up the `profiles` table with a trigger to create a new profile on user sign-up.

**End of Phase 3 Checklist:**

- [ ] Create/modify unit tests for the auth feature.
- [x] Run `dart fix --apply`.
- [x] Run `flutter analyze`.
- [ ] Run any tests to make sure they all pass.
- [x] Run `dart format .`.
- [x] Re-read `IMPLEMENTATION.md` for any changes.
- [x] Update `IMPLEMENTATION.md` with progress.
- [x] Create a commit message for approval.
- [x] Wait for approval.
- [ ] After committing, use `hot_reload`.

---

## Phase 4: Listings, Home Feed, and Details

In this phase, the goal is to implement the core functionality of viewing book listings.

- [x] **Domain Layer:** Define `ListingRepository` interface, `Listing` entity, and `GetListings`, `GetListingDetails` use cases.
- [x] **Data Layer:** Implement `ListingRepository` with `SupabasePostgresDataSource`. Implement `ListingModel` (DTO).
- [x] **Presentation Layer:**
    - Create `HomeViewModel` to manage the state of the home feed.
    - Create `HomeScreen` with a grid of book cards.
    - Create `ListingDetailsViewModel` for the book details screen.
    - Create `ListingDetailsScreen`.
    - Implement navigation from `HomeScreen` to `ListingDetailsScreen`.
- [ ] **Supabase Setup:** Set up the `listings` table in Supabase with appropriate RLS policies.

**End of Phase 4 Checklist:**

- [ ] Create/modify unit tests for the listings feature.
- [x] Run `dart fix --apply`.
- [x] Run `flutter analyze`.
- [ ] Run tests.
- [x] Run `dart format .`.
- [x] Re-read `IMPLEMENTATION.md` for any changes.
- [x] Update `IMPLEMENTATION.md` with progress.
- [x] Create a commit message for approval.
- [x] Wait for approval.
- [ ] After committing, use `hot_reload`.

---

## Phase 5: Sell and Profile Features

In this phase, the goal is to allow users to create and manage their own listings.

- [x] **Domain Layer:** Define `CreateListing`, `DeleteListing`, `GetUserListings` use cases.
- [x] **Data Layer:** Add `createListing`, `deleteListing` methods to `ListingRepository` and implement them in the data source.
- [x] **Presentation Layer:**
    - Create `SellViewModel` and `SellScreen` with a form for creating new listings.
    - [ ] Implement image picking using `image_picker` and upload to Supabase Storage. *(Partial: Image picker not yet implemented)*
    - Create `ProfileViewModel` and `ProfileScreen` to display user information and their listings.
    - Add functionality to delete listings from the profile screen.

**End of Phase 5 Checklist:**

- [ ] Create/modify unit tests for sell and profile features.
- [x] Run `dart fix --apply`.
- [x] Run `flutter analyze`.
- [ ] Run tests.
- [x] Run `dart format .`.
- [x] Re-read `IMPLEMENTATION.md` for any changes.
- [x] Update `IMPLEMENTATION.md` with progress.
- [x] Create a commit message for approval.
- [x] Wait for approval.
- [ ] After committing, use `hot_reload`.

---

## Phase 6: Search and Finalization

In this phase, the goal is to implement the search functionality and finalize the application for the MVP release.

- [ ] **Domain Layer:** Define `SearchListings` use case.
- [ ] **Data Layer:** Add `searchListings` method to `ListingRepository` and implement it in the data source.
- [ ] **Presentation Layer:**
    - Create `SearchViewModel` and `SearchScreen` with a search bar and category filters.
- [ ] Create a comprehensive `README.md` file for the package.
- [ ] Create a `GEMINI.md` file in the project directory that describes the app, its purpose, and implementation details of the application and the layout of the files.
- [ ] Ask the user to inspect the app and the code and say if they are satisfied with it, or if any modifications are needed.

**End of Phase 6 Checklist:**

- [ ] Create/modify unit tests for the search feature.
- [ ] Run `dart fix --apply`.
- [ ] Run `flutter analyze`.
- [ ] Run all tests.
- [ ] Run `dart format .`.
- [ ] Re-read `IMPLEMENTATION.md` for any changes.
- [ ] Update `IMPLEMENTATION.md` with progress.
- [ ] Create a commit message for approval.
- [ ] Wait for approval.

---
*After completing a task, if you added any TODOs to the code or didn't fully implement anything, make sure to add new tasks so that you can come back and complete them later.*
