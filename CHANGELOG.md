# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.0] - 2026-02-01

### Added
- Custom App Launcher Icon: Beautiful BookBridge logo with intricate patterns on an open book design
- App Icon Assets: Added `assets/app_icon.png` to project resources
- Adaptive Icons: Configured adaptive icons for Android with black background

### Changed
- Updated `pubspec.yaml` to include app icon configuration
- Integrated `flutter_launcher_icons` package for icon generation

## [1.0.0] - 2026-01-xx

### Added
- Authentication system with email/password sign-up and sign-in via Supabase Auth
- User profile creation with full name and locality
- Password reset functionality
- Automatic profile creation via database trigger
- Auth state-based navigation
- Browse available book listings in grid layout
- Infinite scroll pagination (50 items per page)
- Create new listings with image upload
- Image upload to Supabase Storage (`book_images` bucket)
- Delete own listings with confirmation
- View listing details with seller information
- Full-text search across book titles and authors
- PostgreSQL tsvector-based search with ranking
- Real-time search results
- View and edit user profile
- Manage user's own listings
- WhatsApp contact integration
- Sign out functionality
- Material Design 3 implementation
- "Knowledge & Trust" visual identity with Scholar Blue, Bridge Orange, and Growth Green colors
- Google Fonts integration (Montserrat, Inter)
- Bottom navigation bar (Home, Search, Sell, Profile)
- Pull-to-refresh on home screen
- Loading states and error handling
- Empty states with helpful messages

### Changed
- Implemented Clean Architecture with Domain/Data/Presentation layers
- Used Provider state management with ChangeNotifier
- Implemented dependency injection with GetIt
- Used Navigation with go_router and auth-based redirection
- Implemented Error handling with Either<Failure, Success> pattern (dartz)
- Set up PostgreSQL tables: `profiles`, `listings`
- Configured Row Level Security (RLS) policies
- Added full-text search function
- Created automatic profile creation trigger
- Added indexes for optimized queries
- Set up Supabase Storage for book images
- Configured public bucket with RLS policies
- Implemented user-specific folder structure

### Documentation
- Added comprehensive README with architecture overview
- Included detailed Supabase setup guide (665 lines)
- Added implementation documentation
- Created brand identity guide
- Developed social venture vision document

## [0.1.0] - 2026-01-xx

### Added
- Initial release of BookBridge application
- Flutter project setup with Clean Architecture and MVVM
- Supabase integration planned for Auth, PostgreSQL, and Storage
- Dark theme applied
- Core features (Auth, Home Feed, Search, Sell, Profile, Book Details) outlined
