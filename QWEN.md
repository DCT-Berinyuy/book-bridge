# BookBridge - Comprehensive Project Guide

## Project Overview

BookBridge is a Flutter-based peer-to-peer marketplace for Cameroonian students to buy and sell used physical books. The app provides a minimalist, dark-themed user interface that prioritizes ease of use and accessibility. It connects students directly to facilitate book transactions in FCFA (Central African CFA franc), the local currency.

## Architecture & Technologies

### Core Architecture
- **Clean Architecture**: Clear separation of concerns with Domain → Data → Presentation layers
- **MVVM Pattern**: Model-View-ViewModel for presentation layer
- **Dependency Injection**: Using `get_it` for service location
- **State Management**: Provider pattern with ChangeNotifier

### Technology Stack
- **Framework**: Flutter 3.0+ with Dart SDK
- **Backend**: Supabase (PostgreSQL database + Authentication)
- **State Management**: Provider package
- **Navigation**: go_router for routing and deep linking
- **Functional Programming**: dartz for Either<Failure, Success> pattern
- **UI Design**: Material Design 3 with dark theme
- **Utilities**: intl for localization, url_launcher for WhatsApp integration, image_picker for images

## Key Features

### Authentication
- Email/password sign-up and sign-in via Supabase
- User profile management with full name, locality, and WhatsApp number
- Session management with automatic state persistence

### Book Listings
- Browse available books in a grid layout with infinite scroll pagination
- Detailed book information including title, author, price, condition, and description
- Seller contact information with direct WhatsApp integration

### Search Functionality
- Full-text search across book titles and authors
- Multiple search states (initial, loading, success, error, empty)

### Selling Books
- Create new listings with title, author, price, condition, and description
- Form validation for all required fields
- Image upload functionality (planned)

### Profile Management
- View and manage user profile information
- Access to user's active listings
- Ability to delete own listings

## Project Structure

```
lib/
├── core/                      # Core functionality shared across features
│   ├── error/                # Error handling (Failures, Exceptions)
│   ├── theme/                # Application theming
│   └── usecases/             # Base UseCase classes
├── features/                 # Feature modules
│   ├── auth/                 # Authentication feature
│   │   ├── domain/          # Business logic (entities, repositories, use cases)
│   │   ├── data/            # Data sources and repositories (Supabase)
│   │   └── presentation/    # UI and state management (screens, view models)
│   └── listings/            # Listings feature
│       ├── domain/
│       ├── data/
│       └── presentation/
├── config/                   # App-wide configuration (routing, DI)
├── injection_container.dart  # Dependency injection setup
└── main.dart                # App entry point
```

## Building and Running

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK (included with Flutter)
- A Supabase project account

### Installation Steps
1. Clone the repository:
```bash
git clone https://github.com/DCT-Berinyuy/book-bridge.git
cd book-bridge
```

2. Get dependencies:
```bash
flutter pub get
```

3. Configure Supabase:
   - Update the Supabase URL and API key in `lib/main.dart`
   - Ensure the following tables exist in your Supabase database:
     - `profiles`: User profile information
     - `listings`: Book listings with seller and book details

4. Run the app:
```bash
flutter run
```

### Database Schema
#### profiles table
```sql
- id (UUID, primary key)
- email (text)
- full_name (text)
- locality (text, nullable)
- whatsapp_number (text, nullable)
- created_at (timestamp)
```

#### listings table
```sql
- id (UUID, primary key)
- title (text)
- author (text)
- price_fcfa (integer)
- condition (text: 'new', 'like_new', 'good', 'fair', 'poor')
- image_url (text)
- description (text, nullable)
- seller_id (UUID, foreign key to profiles)
- status (text: 'available', 'sold', 'pending')
- created_at (timestamp)
```

## Navigation Structure

The app uses go_router for navigation with auth state-based redirection:
- `/`: Splash screen (redirects based on auth state)
- `/sign-in`: Sign in screen
- `/sign-up`: Sign up screen
- `/home`: Home feed with listings grid
- `/listing/:id`: Listing details screen
- `/search`: Search listings
- `/sell`: Create new listing
- `/profile`: User profile and listings management

## State Management

The app uses Provider with ChangeNotifier pattern for state management:
- **AuthViewModel**: Manages authentication state and user session
- **HomeViewModel**: Manages home feed listings with pagination
- **ListingDetailsViewModel**: Manages single listing details display
- **SellViewModel**: Manages listing creation form and validation
- **ProfileViewModel**: Manages user profile and listings management
- **SearchViewModel**: Manages search functionality and results

## Error Handling

Errors are handled using a functional approach with the Either pattern from dartz:
```dart
// Example: Either<Failure, Success>
final result = await someUseCase(params);
result.fold(
  (failure) => handleError(failure.message),
  (success) => handleSuccess(success),
);
```

Error types:
- `AuthFailure`: Authentication-related errors
- `ServerFailure`: Server and network errors
- `UnknownFailure`: Unexpected errors
- `NotFoundException`: Resource not found

## Development Conventions

### Code Quality
- **dart fix --apply**: Automated code fixes
- **flutter analyze**: Linting and analysis (0 issues)
- **dart format**: Consistent code formatting

### Testing
- Manual testing of all features before commit
- UI testing of all screens and navigation flows
- Data layer testing with Supabase
- State management validation

## Future Enhancements

- [ ] Image picker integration for listing creation
- [ ] Image upload to Supabase Storage
- [ ] User ratings and reviews system
- [ ] Messaging system between buyers and sellers
- [ ] Advanced filters (location-based, price range, condition)
- [ ] Wishlist functionality
- [ ] Analytics and statistics
- [ ] Admin dashboard
- [ ] Multi-language support

## Version History

- **0.1.0** (January 25, 2026): Initial MVP release
  - Phase 1-6 complete
  - Core marketplace functionality implemented
  - Authentication and listings management
  - Search functionality

## Landing Page

The project includes a standalone landing page in the `landingPage/` directory with:
- Responsive HTML/CSS design
- Features showcase
- How-it-works section
- Student testimonials
- Call-to-action buttons

## Support & Documentation

For more information:
- See [README.md](README.md) for getting started
- See [IMPLEMENTATION.md](IMPLEMENTATION.md) for phase requirements
- See [GEMINI.md](GEMINI.md) for complete implementation details
- Check Git commit history for phase-by-phase implementation details