# BookBridge 📚

[![Flutter](https://img.shields.io/badge/Flutter-3.10.7+-blue)](https://flutter.dev/)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-orange)](https://supabase.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-android%20%7C%20ios%20%7C%20web-green)](https://flutter.dev/)
[![Version](https://img.shields.io/badge/version-1.1.0-brightgreen)](https://github.com/DCT-Berinyuy/book-bridge)

> **A Social Venture to End Learning Poverty**

A peer-to-peer marketplace for Cameroonian students to buy and sell used physical books. Built with Flutter and powered by Supabase, BookBridge connects students locally to simplify the process of finding affordable books and monetizing used collections.

**Mission**: To democratize access to affordable books and educational materials in Cameroon and beyond, addressing the crisis where **72% of children** cannot read and understand simple text by age 10.

---

## 📸 Screenshots

Here are some screenshots of the BookBridge app:

<div align="center">
  <img src="assets/sreenshots/screenshot1.png" alt="Screenshot 1" width="30%">
  <img src="assets/sreenshots/screenshot2.png" alt="Screenshot 2" width="30%">
  <img src="assets/sreenshots/screenshot3.png" alt="Screenshot 3" width="30%">
</div>

---

## 🌟 Features

### Core Functionality

- ✅ **User Authentication**: Secure email/password signup and signin via Supabase Auth
- ✅ **Browse Listings**: Discover available books in a responsive grid layout with infinite scroll pagination (50 items/page)
- ✅ **Smart Search**: Full-text search across book titles and authors using PostgreSQL tsvector
- ✅ **Detailed Listings**: View comprehensive information including images, pricing, seller contact info, and book condition
- ✅ **Sell Books**: Create listings with image upload to Supabase Storage, custom pricing, and condition selection
- ✅ **Profile Management**: Edit profile, manage your listings, delete listings with confirmation
- ✅ **Direct Communication**: Contact sellers directly via WhatsApp for seamless transactions
- ✅ **Category Filtering**: Browse books by category (textbooks, novels, reference, etc.)
- ✅ **Pull-to-Refresh**: Refresh listings on home screen
- ✅ **Password Reset**: Recover account via email

### Technical Highlights

- **Clean Architecture**: 3-layer architecture (Domain, Data, Presentation) with clear separation of concerns across 47 Dart files
- **State Management**: Provider pattern with ChangeNotifier for efficient, reactive state handling
- **Dependency Injection**: GetIt service locator pattern with 30+ registered dependencies
- **Navigation**: go_router with auth state-based redirection and StatefulShellRoute for bottom navigation
- **Error Handling**: Either<Failure, Success> pattern using dartz for robust, functional error management
- **UI/UX**: Material Design 3 with "Knowledge & Trust" brand identity (Scholar Blue, Bridge Orange, Growth Green)
- **Typography**: Google Fonts integration (Montserrat for headings, Inter for body text)
- **Responsive Design**: Works seamlessly across all screen sizes and orientations
- **Image Management**: Supabase Storage integration with user-specific folders
- **Security**: Row Level Security (RLS) policies on all database tables

---

## 🏗️ Architecture

The application follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                      # Core functionality shared across features
│   ├── error/                # Error handling (Failures, Exceptions)
│   ├── theme/                # Application theming (Material Design 3)
│   ├── usecases/             # Base UseCase classes
│   └── presentation/         # Shared widgets (ScaffoldWithNavBar)
├── features/                 # Feature modules (47 files)
│   ├── auth/                 # Authentication feature (11 files)
│   │   ├── domain/          # Business logic (entities, repositories, use cases)
│   │   ├── data/            # Data sources and repositories (Supabase)
│   │   └── presentation/    # UI and state management (screens, view models)
│   ├── listings/            # Listings feature (22 files)
│   │   ├── domain/          # Listing entity, repository, 6 use cases
│   │   ├── data/            # Supabase integration, image upload
│   │   └── presentation/    # 5 screens, 5 view models
│   └── notifications/       # Notifications (placeholder)
├── config/                   # App-wide configuration
│   ├── app_config.dart      # Environment variables
│   └── router.dart          # Navigation setup (go_router)
├── injection_container.dart  # Dependency injection setup (GetIt)
└── main.dart                # App entry point
```

### Architecture Layers

#### Domain Layer (Business Logic)

- Pure Dart classes with no external dependencies
- Entities: `User`, `Listing` (with Equatable for value equality)
- Repository interfaces: Abstract contracts
- Use Cases: Single-responsibility operations (12 total)

#### Data Layer (Implementation)

- Models: DTOs with JSON serialization
- Data Sources: `SupabaseAuthDataSource`, `SupabaseListingsDataSource`, `SupabaseStorageDataSource`
- Repository Implementations: Error mapping (Exceptions → Failures)

#### Presentation Layer (UI)

- Screens: 9 screens (Sign In, Sign Up, Home, Search, Sell, Profile, Listing Details, Edit Profile, Notifications)
- ViewModels: 6 ChangeNotifiers managing state
- Provider integration for dependency injection

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.10.7 or higher
- **Dart SDK**: Included with Flutter
- **Supabase Account**: Free tier available at [supabase.com](https://supabase.com)
- **Android Studio / VS Code**: With Flutter extensions

### Installation

1. **Clone the repository**:

```bash
git clone https://github.com/DCT-Berinyuy/book-bridge.git
cd book-bridge
```

2. **Install dependencies**:

```bash
flutter pub get
```

3. **Configure Supabase**:

   Follow the comprehensive [SUPABASE_SETUP.md](SUPABASE_SETUP.md) guide (665 lines) to:
   - Create a Supabase project
   - Set up database tables (`profiles`, `listings`)
   - Configure Row Level Security policies
   - Create storage bucket (`book_images`)
   - Set up full-text search function
   - Configure authentication

4. **Set up environment variables**:

   Create a `.env` file in the project root:

   ```env
   SUPABASE_URL=your_supabase_project_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

   > **Note**: The `.env` file is in `.gitignore` and will not be committed to version control

5. **Run the app**:

   **Option A**: Using environment variables from `.env`:

   ```bash
   flutter run --dart-define=SUPABASE_URL=$(grep SUPABASE_URL .env | cut -d'=' -f2) --dart-define=SUPABASE_ANON_KEY=$(grep SUPABASE_ANON_KEY .env | cut -d'=' -f2)
   ```

   **Option B**: Direct environment variables:

   ```bash
   flutter run --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key
   ```

### Building for Production

**Android APK**:

```bash
flutter build apk --release
```

**Android App Bundle**:

```bash
flutter build appbundle --release
```

**iOS**:

```bash
flutter build ios --release
```

---

## 📊 Database Schema

### Tables

#### `profiles` Table

Stores user profile information, automatically created via database trigger on signup.

```sql
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users (id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  locality TEXT,
  whatsapp_number TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

**RLS Policies**:

- ✅ Authenticated users can view all profiles (for seller information)
- ✅ Users can update their own profile
- ✅ Insert allowed during signup

#### `listings` Table

Stores book listing information with support for social venture features.

```sql
CREATE TABLE listings (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  title TEXT NOT NULL,
  author TEXT NOT NULL,
  price_fcfa INTEGER NOT NULL,
  condition TEXT NOT NULL CHECK (condition IN ('new', 'like_new', 'good', 'fair', 'poor')),
  image_url TEXT,
  description TEXT,
  seller_id UUID NOT NULL REFERENCES profiles (id) ON DELETE CASCADE,
  status TEXT DEFAULT 'available' CHECK (status IN ('available', 'sold', 'pending')),
  category TEXT,
  seller_type TEXT DEFAULT 'individual',
  is_buy_back_eligible BOOLEAN DEFAULT FALSE,
  stock_count INTEGER DEFAULT 1,
  is_featured BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  tsv TSVECTOR -- Full-text search vector
);
```

**RLS Policies**:

- ✅ Anyone can view available listings
- ✅ Users can view their own listings (all statuses)
- ✅ Users can create, update, and delete their own listings

**Indexes**:

- `listings_seller_id_idx` - Fast seller queries
- `listings_status_idx` - Fast status filtering
- `listings_created_at_idx` - Ordered by newest

### Storage

**Bucket**: `book_images` (public)

**Structure**: `book_images/{user_id}/{timestamp}_{random}.jpg`

**RLS Policies**:

- ✅ Authenticated users can upload to their own folder
- ✅ Public read access for all images
- ✅ Users can delete their own images

### Database Functions

#### `handle_new_user()`

Automatically creates a profile when a user signs up via Supabase Auth.

#### `search_listings(query, limit, offset)`

Full-text search function using PostgreSQL tsvector with relevance ranking.

---

## 🧭 Navigation

The app uses **go_router** for navigation with auth state-based redirection:

### Route Structure

| Route            | Screen               | Auth Required | Description                              |
| ---------------- | -------------------- | ------------- | ---------------------------------------- |
| `/`              | SplashScreen         | No            | Initial loading, redirects based on auth |
| `/sign-in`       | SignInScreen         | No            | Email/password login                     |
| `/sign-up`       | SignUpScreen         | No            | User registration                        |
| `/home`          | HomeScreen           | Yes           | Main feed with listings grid             |
| `/search`        | SearchScreen         | Yes           | Search listings                          |
| `/sell`          | SellScreen           | Yes           | Create new listing                       |
| `/profile`       | ProfileScreen        | Yes           | User profile and listings                |
| `/listing/:id`   | ListingDetailsScreen | Yes           | Single listing details                   |
| `/edit-profile`  | EditProfileScreen    | Yes           | Edit user profile                        |
| `/notifications` | NotificationsScreen  | Yes           | Notifications (placeholder)              |

### Bottom Navigation

The app uses `StatefulShellRoute` for persistent bottom navigation:

- 🏠 **Home** - Browse listings
- 🔍 **Search** - Find books
- ➕ **Sell** - Create listing
- 👤 **Profile** - Manage account

---

## 💡 State Management

The app uses **Provider** with **ChangeNotifier** pattern for state management:

### ViewModels

| ViewModel                   | Responsibility                     | States                                                  |
| --------------------------- | ---------------------------------- | ------------------------------------------------------- |
| **AuthViewModel**           | Authentication state, user session | initial, loading, authenticated, unauthenticated, error |
| **HomeViewModel**           | Home feed listings, pagination     | initial, loading, loaded, error                         |
| **ListingDetailsViewModel** | Single listing details             | loading, loaded, error                                  |
| **SellViewModel**           | Listing creation form, validation  | idle, loading, success, error                           |
| **ProfileViewModel**        | User profile, listings management  | loading, loaded, error                                  |
| **SearchViewModel**         | Search functionality, results      | initial, loading, success, error, empty                 |

### State Flow

```
User Action → ViewModel → Use Case → Repository → Data Source → Supabase
                ↓
         notifyListeners()
                ↓
           UI Rebuild
```

---

## ⚠️ Error Handling

Errors are handled using a **functional approach** with the `Either` pattern from **dartz**:

```dart
// Example: Either<Failure, Success>
final result = await someUseCase(params);
result.fold(
  (failure) => handleError(failure.message),
  (success) => handleSuccess(success),
);
```

### Error Types

| Failure Type              | Description           | Example                                   |
| ------------------------- | --------------------- | ----------------------------------------- |
| `AuthFailure`             | Authentication errors | Invalid credentials, email already exists |
| `ServerFailure`           | Server/network errors | Connection timeout, Supabase errors       |
| `UnknownFailure`          | Unexpected errors     | Unhandled exceptions                      |
| `NotAuthenticatedFailure` | User not logged in    | Accessing protected resources             |

### Exception Types

| Exception           | Description                       |
| ------------------- | --------------------------------- |
| `AuthException`     | Authentication-related exceptions |
| `ServerException`   | Server communication errors       |
| `NotFoundException` | Resource not found (404)          |

---

## 🎨 Design System

### Brand Identity: "Knowledge & Trust"

**Color Palette**:

- **Scholar Blue** (`#1A4D8C`) - Primary color, trust, stability
- **Bridge Orange** (`#F2994A`) - Secondary color, action, energy
- **Growth Green** (`#27AE60`) - Tertiary color, impact, growth
- **Paper White** (`#F9F9F9`) - Background, clean, accessible
- **Ink Black** (`#2D3436`) - Text, readability

**Typography**:

- **Headings**: Montserrat (bold, 700)
- **Body Text**: Inter (regular, 400)
- **Buttons**: Montserrat (bold, 700)

**Design Principles**:

- Material Design 3 components
- 12px border radius for cards and buttons
- 8px spacing grid
- Consistent elevation shadows
- Color-coded condition indicators

---

## 🛠️ Development

### Code Quality Standards

The project maintains **zero-issue** code quality:

```bash
# Run automated fixes
dart fix --apply

# Check for issues (currently 0 issues)
flutter analyze

# Format code
dart format .
```

### Project Statistics

- **Total Dart Files**: 47
- **Lines of Code**: ~15,000+
- **Documentation**: 1,000+ lines across 7 markdown files
- **Dependencies**: 11 packages
- **Dev Dependencies**: 3 packages

### Development Workflow

1. Create feature branch
2. Implement changes following Clean Architecture
3. Run `dart fix --apply`
4. Run `flutter analyze` (ensure 0 issues)
5. Run `dart format .`
6. Test on device/emulator
7. Create pull request

---

## ✅ Implementation Status

### Completed Features (100%)

#### Phase 1: Project Initialization ✅

- Flutter project setup with all required dependencies
- Boilerplate cleanup
- Documentation and changelog creation

#### Phase 2: Core Architecture and Theming ✅

- Clean Architecture directory structure
- Error handling system with Failure and Exception classes
- Base UseCase classes
- Dependency injection framework with GetIt
- Material Design 3 theme with brand identity
- App initialization and routing setup

#### Phase 3: Authentication Feature ✅

- Domain layer: User entity, AuthRepository interface, 6 use cases
- Data layer: Supabase Auth integration, UserModel DTO, AuthRepositoryImpl
- Presentation layer: AuthViewModel, SignInScreen, SignUpScreen, EditProfileScreen
- go_router configuration with auth state-based redirection
- Automatic profile creation via database trigger
- Password reset functionality

#### Phase 4: Listings Feature - Browse and View ✅

- Domain layer: Listing entity (14 properties), ListingRepository, use cases
- Data layer: Supabase PostgreSQL integration, ListingModel, pagination support
- Presentation layer: HomeViewModel, HomeScreen with GridView, ListingDetailsScreen
- Pagination with 50-item pages and infinite scroll
- Pull-to-refresh functionality
- Category filtering with chips
- Featured listings carousel
- Condition indicators and verified badges

#### Phase 5: Sell and Profile Features ✅

- Domain layer: CreateListing, DeleteListing, GetUserListings use cases
- Data layer: Image upload to Supabase Storage, createListing and deleteListing methods
- Presentation layer: SellViewModel and SellScreen with form validation
- Profile screen: ProfileViewModel and ProfileScreen for managing user listings
- Delete listings functionality with confirmation dialogs
- Image picker integration
- Form validation (title, author, price, condition, image)

#### Phase 6: Search and Finalization ✅

- Domain layer: SearchListingsUseCase for full-text search
- Data layer: PostgreSQL tsvector-based search with ranking
- Presentation layer: SearchViewModel, SearchScreen with search results grid
- Full-text search across book titles, authors, and descriptions
- Multiple search states (initial, loading, success, error, empty)
- Real-time search results

#### Phase 7: Polish and Production ✅

- Custom app launcher icon
- Android adaptive icons
- Production APK build and testing
- WhatsApp integration
- Comprehensive documentation

---

## 🚧 Future Enhancements

### Short-term Roadmap

- [ ] **Testing**: Unit tests, widget tests, integration tests
- [ ] **Error Logging**: Sentry or Firebase Crashlytics integration
- [ ] **Analytics**: User behavior tracking (Firebase Analytics)
- [ ] **Offline Support**: Local caching with SQLite
- [ ] **Image Compression**: Optimize before upload
- [ ] **Advanced Filters**: Location-based, price range, multiple conditions
- [ ] **Wishlist/Favorites**: Save listings for later
- [ ] **Push Notifications**: New listings, price drops
- [ ] **Multi-language Support**: English/French localization

### Long-term Vision: The "Amazon for Books" in Cameroon

BookBridge aims to move beyond a peer-to-peer app to become a vital piece of national social infrastructure.

#### Professional Vendor Ecosystem

- **Dedicated Storefronts**: Profile pages for established bookshops (e.g., Presbook, Messenger) to display their full inventory
- **Bulk Inventory Tools**: Professional tools for shops and authors to manage large catalogs via CSV/Excel
- **Verification System**: Trust badges for verified local businesses and authors
- **Analytics Dashboard**: Sales tracking, inventory management, customer insights

#### Integrated Financial Infrastructure

- **Mobile Money (MTN/Orange)**: Seamless in-app payments to move beyond the "WhatsApp struggle"
- **Automated Commission**: Automated processing of the 5-15% success fee to ensure venture sustainability
- **Escrow System**: Protecting both buyer and seller until delivery is confirmed
- **Multi-currency Support**: FCFA, USD, EUR

#### Logistics & "Last-Mile" Solutions

- **Moto-Taxi Partnerships**: Integrating local transport networks to provide affordable, reliable delivery directly through the app
- **Centralized Hubs**: Strategic pickup points in major student hubs like Molyko, Yaoundé I, and Dschang
- **Delivery Tracking**: Real-time tracking of book shipments
- **Pickup Scheduling**: Coordinate convenient pickup times

#### The Circular Book Economy (SDG 12)

- **In-App Buy-Back**: Automated "Trade-In" system where students can sell books back into the cycle with one tap
- **Digital Book Support**: Potential expansion into affordable e-books and PDFs for remote areas
- **Book Condition Assessment**: AI-powered condition grading
- **Sustainability Metrics**: Track environmental impact

#### Hyper-Local Geolocation Engine

- **Proximity Search**: Real-time filtering to show the nearest buyers and sellers, reducing transport costs
- **Map Integration**: Visualizing pickup points and book density across neighborhoods
- **Regional Analytics**: Tracking book demand by specific university campuses
- **Campus-specific Feeds**: Tailored listings for each university

#### AI-Powered Intelligence

- **Smart Recommendations**: A personalized discovery engine that learns your reading habits and academic needs
- **AI Listing Assistant**: Automatically generating book descriptions and estimating fair market prices from a photo
- **Educational Copilot**: An AI-driven tutor integrated into the platform to answer questions about the books being sold
- **Price Prediction**: ML-based pricing suggestions

#### Data-as-a-Service

- Providing publishers and government bodies with demand-side data to prevent textbook shortages and optimize local printing
- Market insights for educational institutions
- Trend analysis for curriculum planning

---

## 🌍 Social Impact

### Alignment with UN Sustainable Development Goals

- **SDG 4: Quality Education** - Making books accessible and affordable to combat learning poverty
- **SDG 8: Decent Work and Economic Growth** - Empowering local bookshops, authors, and micro-entrepreneurs
- **SDG 12: Responsible Consumption** - Circular book economy through buy-back and trade-in systems

### Impact Metrics (Planned)

- Number of books circulated
- Students reached
- Money saved by students
- Local businesses empowered
- CO2 emissions avoided through book reuse

---

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/AmazingFeature`
3. **Make your changes** following Clean Architecture principles
4. **Add tests** if applicable (unit, widget, integration)
5. **Run code quality checks**:
   ```bash
   dart fix --apply
   flutter analyze
   dart format .
   ```
6. **Commit your changes**: `git commit -m 'Add some AmazingFeature'`
7. **Push to the branch**: `git push origin feature/AmazingFeature`
8. **Open a Pull Request** with a clear description

### Development Guidelines

- Follow Clean Architecture patterns
- Write meaningful commit messages
- Document complex logic
- Maintain zero `flutter analyze` issues
- Use Provider for state management
- Follow Material Design 3 guidelines

---

## 📚 Documentation

### Comprehensive Guides

- **[README.md](README.md)** - This file, project overview
- **[SUPABASE_SETUP.md](SUPABASE_SETUP.md)** - 665-line step-by-step Supabase setup guide
- **[IMPLEMENTATION.md](IMPLEMENTATION.md)** - Phased implementation plan and development journal
- **[CHANGELOG.md](CHANGELOG.md)** - Version history and release notes
- **[GEMINI.md](GEMINI.md)** - Project context for AI assistants
- **[Brand Identity Guide](Brand%20Identity%20Guide_%20The%20Visual%20Language%20of%20BookBridge.md)** - Visual design language
- **[Social Venture Vision](BookBridge_%20A%20Social%20Venture%20to%20End%20Learning%20Poverty.md)** - Mission and impact strategy

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **Flutter and Dart communities** for excellent frameworks and packages
- **Supabase** for backend infrastructure and developer-friendly tools
- **Material Design 3** for design guidelines and components
- **Provider package** for state management patterns
- **Google Fonts** for beautiful typography
- **All contributors** who help make BookBridge better
- **Cameroonian students** who inspire this mission

---

## 📞 Contact & Support

For support, questions, or feedback:

- **Issues**: Open an issue on [GitHub](https://github.com/DCT-Berinyuy/book-bridge/issues)
- **Documentation**: Check our comprehensive guides above
- **Email**: Contact the development team
- **Community**: Join our discussions

---

## 🚀 Quick Links

- [Getting Started](#-getting-started)
- [Supabase Setup Guide](SUPABASE_SETUP.md)
- [Architecture Overview](#️-architecture)
- [Contributing Guidelines](#-contributing)
- [Future Roadmap](#-future-enhancements)

---

<div align="center">

**Made with ❤️ for Cameroonian students**

_Democratizing access to knowledge, one book at a time._

[⭐ Star this repo](https://github.com/DCT-Berinyuy/book-bridge) | [🐛 Report Bug](https://github.com/DCT-Berinyuy/book-bridge/issues) | [💡 Request Feature](https://github.com/DCT-Berinyuy/book-bridge/issues)

</div>
