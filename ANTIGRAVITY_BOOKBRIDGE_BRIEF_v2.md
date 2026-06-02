# 🤖 Antigravity 2.0 — BookBridge Development Agent Brief (v2)
> Feed this entire document as your starting prompt into Antigravity 2.0.
> NOTE: You have already pulled the latest repo and analyzed its state.
> Issue #14 (APK download link) is confirmed fixed in commit `a0a4b7a`.
> Begin from Issue #15 (screenshot overflow) and Issue #9 (Terms & Conditions),
> then proceed through Priorities 2–7 in order.

---

## 🎯 YOUR MISSION

You are a senior Flutter/Dart engineer resuming development on **BookBridge** — a peer-to-peer textbook marketplace for Cameroonian students. The lead developer (Mr. DCT) has been away from this repo for ~2 months. Your job is to pick up exactly where he left off and execute the next development sprint based on both the existing roadmap and the strategic recommendations document below.

**Repository:** https://github.com/DCT-Berinyuy/book-bridge
**Active Branch:** `dev`
**Current Version:** v1.4.0+4
**Tech Stack:** Flutter 3.10.7+ / Dart, Supabase (PostgreSQL + Auth + Storage + Realtime), Provider, GetIt, go_router, dartz, Fapshi (payments)

---

## 📦 REPO STATE (Already Confirmed)

- ✅ `dev` and `main` are fully synced, clean, no conflicts
- ✅ Issue #14 (APK link) fixed in commit `a0a4b7a`
- ✅ Fapshi webhook phone formatting fixed (issues #20/#21)
- ✅ Default light theme set
- ✅ 135 commits, 5 releases, 47 Dart files, ~15,000 LOC

**Read these files before writing any code:**
- `GEMINI.md` — full AI context with architectural decisions
- `lib/injection_container.dart` — all registered dependencies
- `lib/config/router.dart` — all routes
- `lib/features/listings/data/datasources/supabase_listings_datasource.dart` — datasource pattern
- `pubspec.yaml` — current dependencies

---

## 🏗️ ARCHITECTURE OVERVIEW

### Clean Architecture — 3 Layers
```
lib/
├── core/               # Errors, theme, base use cases, shared widgets
├── features/
│   ├── auth/           # 11 files — Supabase Auth, sign in/up, profile
│   ├── listings/       # 22 files — Browse, sell, search, listing details
│   └── notifications/  # Placeholder only
├── config/             # app_config.dart, router.dart
├── injection_container.dart
└── main.dart
```

### Key Patterns
- **State:** `Provider` + `ChangeNotifier` ViewModels
- **DI:** `GetIt` service locator (30+ registered deps)
- **Navigation:** `go_router` with `StatefulShellRoute`
- **Error handling:** `Either<Failure, Success>` via `dartz`
- **DB:** Supabase PostgreSQL with RLS on all tables

### Brand Identity: "Knowledge & Trust"
- Scholar Blue: `#1A4D8C` (primary)
- Bridge Orange: `#F2994A` (secondary)
- Growth Green: `#27AE60` (tertiary)
- Font: Montserrat (headings), Inter (body)

---

## ✅ ALREADY BUILT — DO NOT REBUILD

- User authentication (email/password via Supabase)
- Browse listings (grid, infinite scroll, 50/page)
- Full-text search (PostgreSQL tsvector)
- Sell books (image upload, form validation)
- Profile management
- WhatsApp seller contact
- Category filtering
- Fapshi payments (MTN MoMo + Orange Money) — v1.4.0
- Multi-language support (EN/FR)
- SvelteKit landing page (book-bridge-three.vercel.app)
- Clean Architecture with 0 flutter analyze issues

---

## 🚧 DEVELOPMENT SPRINT — PRIORITY ORDER

Work through these in strict order. Complete and commit each before moving to the next.

---

### PRIORITY 1 — Fix Remaining Open Issues

**Issue #15:** Screenshot overflow on landing page phone widget
- File: `landingPage/` (SvelteKit)
- Find the phone mockup component and fix CSS overflow/clipping on the screenshot images

**Issue #9:** Missing Terms & Conditions page
- Create `lib/features/auth/presentation/screens/terms_screen.dart`
- Add route `/terms` in `config/router.dart`
- Link from Sign Up screen with checkbox: "I agree to the Terms & Conditions"
- Content to include:
  - User responsibilities (accurate listings, honest condition grading)
  - Prohibited items (counterfeit, stolen books)
  - Payment policy (Fapshi terms, refund conditions)
  - Safety guidelines for in-person meetups
  - Data privacy statement
  - Platform commission disclosure (5–15% success fee)

---

### PRIORITY 2 — Standardized Book Condition Grading System

**Goal:** Reduce buyer/seller disputes by standardizing how book conditions are described and displayed. Directly addresses the #1 complaint on global platforms like Better World Books.

**Implementation:**

1. Update the `condition` field display throughout the app with color-coded badges:
   - `new` → Green `#27AE60`
   - `like_new` → Teal `#1ABC9C`
   - `good` → Scholar Blue `#1A4D8C`
   - `fair` → Bridge Orange `#F2994A`
   - `poor` → Red `#E74C3C`

2. Create `lib/core/widgets/condition_badge.dart` — reusable badge widget used on ListingCard and ListingDetailsScreen

3. Add a **Condition Guide Modal** — tappable info icon on SellScreen and ListingDetailsScreen:
   - Create `lib/core/widgets/condition_guide_modal.dart`
   - Each condition shows: name, color, description, what to expect
   - Content:
     ```
     NEW: Unused, unopened, original packaging if applicable
     LIKE NEW: Read once, no markings, minimal wear
     GOOD: Some highlighting/notes, intact binding, all pages present
     FAIR: Heavy use, significant markings, may have creases
     POOR: Functional but heavily worn, all content readable
     ```

4. On SellScreen, replace plain condition dropdown with visual condition selector cards showing color + description

---

### PRIORITY 3 — Offline Cache with sqflite

**Goal:** Users can browse listings without active internet — critical for Cameroonian low-bandwidth context.

**Dependencies to add in pubspec.yaml:**
```yaml
sqflite: ^2.3.0
path: ^1.9.0
```

**Files to create:**
- `lib/core/local_db/local_database.dart` — SQLite setup and schema
- `lib/features/listings/data/datasources/local_listings_datasource.dart`

**Schema:**
```sql
CREATE TABLE cached_listings (
  id TEXT PRIMARY KEY,
  title TEXT,
  author TEXT,
  price_fcfa INTEGER,
  condition TEXT,
  image_url TEXT,
  description TEXT,
  seller_id TEXT,
  status TEXT,
  category TEXT,
  cached_at INTEGER
);
```

**Modify `ListingsRepositoryImpl` to:**
- On successful fetch → cache results to SQLite
- On network failure → serve from cache with `OfflineBanner` widget
- Cache TTL: 24 hours (check `cached_at` Unix timestamp)

**Add `OfflineBanner` widget:**
- Yellow banner at top of HomeScreen: "You're offline — showing saved results"
- Only visible when serving from cache

**Register `SqfliteCacheService` in `injection_container.dart`**

---

### PRIORITY 4 — Social Impact Tracker (Book-for-Book Model)

**Goal:** Formalize BookBridge's social mission with measurable impact metrics. Based on Better World Books' model — every transaction generates trackable social good. Critical for investor pitch at PROMOTE 2026.

**Database — Add to Supabase:**
```sql
CREATE TABLE impact_metrics (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  metric_type TEXT NOT NULL CHECK (metric_type IN (
    'book_circulated',
    'money_saved',
    'co2_avoided',
    'student_reached'
  )),
  value FLOAT NOT NULL,
  transaction_id UUID,
  recorded_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE platform_stats (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  total_books_circulated INTEGER DEFAULT 0,
  total_students_reached INTEGER DEFAULT 0,
  total_money_saved_fcfa BIGINT DEFAULT 0,
  total_co2_avoided_kg FLOAT DEFAULT 0,
  updated_at TIMESTAMP DEFAULT NOW()
);
```

**Calculation logic:**
- `money_saved` = average new book price (15,000 FCFA) − sale price
- `co2_avoided` = 2.7kg CO2 per book reused (industry standard)
- `student_reached` = unique buyers + unique sellers

**Flutter implementation:**
1. Create `lib/features/impact/` feature
2. `ImpactStatsWidget` — displayed on HomeScreen below the featured carousel:
   ```
   📚 1,247 books circulated
   💰 18.7M FCFA saved by students
   🌱 3.4 tonnes CO2 avoided
   ```
3. Stats fetched from `platform_stats` table (cached locally, updated on each transaction)
4. Animated number counters on first load (use `CountUp` animation)
5. Update `platform_stats` via Supabase trigger after each completed transaction

---

### PRIORITY 5 — Seller Ratings & Trust System

**Goal:** Verified post-transaction ratings. Only buyers who completed a purchase can rate sellers. Core trust mechanism for investor pitch.

**Database:**
```sql
CREATE TABLE ratings (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  listing_id UUID REFERENCES listings(id) ON DELETE CASCADE,
  buyer_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  seller_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  score INTEGER CHECK (score BETWEEN 1 AND 5),
  comment TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(listing_id, buyer_id)
);

ALTER TABLE profiles ADD COLUMN rating_score FLOAT DEFAULT 0;
ALTER TABLE profiles ADD COLUMN rating_count INTEGER DEFAULT 0;
```

**Bayesian Rating Formula:**
```
adjusted_rating = (v / (v + m)) * R + (m / (v + m)) * C
where: v = rating_count, R = raw average, m = 5, C = global average
```

**Flutter:**
1. Create `lib/features/ratings/` feature (domain/data/presentation)
2. `RatingEntity`, `SubmitRatingUseCase`, `GetSellerRatingsUseCase`
3. `RatingViewModel` with Provider
4. `SubmitRatingSheet` — bottom sheet with 5-star selector + optional comment
5. Seller rating badge on `ListingDetailsScreen` and `ProfileScreen`
6. Trigger rating prompt after Fapshi transaction marked complete

---

### PRIORITY 6 — Safety Guidelines & Campus Meetup Zones

**Goal:** Increase trust and safety for in-person book exchanges. Based on P2P marketplace best practices — explicit safety infrastructure reduces fraud and increases platform confidence.

**Flutter:**
1. Create `lib/features/safety/presentation/screens/safety_guidelines_screen.dart`
2. Add route `/safety` accessible from ListingDetailsScreen ("Arrange Meetup" section)
3. Content sections:
   - **Safe Meetup Locations**: Public campus areas, library entrances, student union buildings
   - **What to Check**: Verify book condition before paying, match ISBN if possible
   - **Payment Safety**: Always use in-app Fapshi payment, never send money in advance via WhatsApp
   - **Report Issues**: Link to report form
4. Add `MeetupTipsCard` widget on `ListingDetailsScreen` below the WhatsApp contact button
5. Create a `campus_zones` table in Supabase for verified safe exchange points:
```sql
CREATE TABLE campus_zones (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name TEXT NOT NULL,
  university TEXT NOT NULL,
  city TEXT NOT NULL,
  description TEXT,
  latitude FLOAT,
  longitude FLOAT,
  is_verified BOOLEAN DEFAULT FALSE
);
```
Pre-populate with known ICT University, University of Yaoundé I, University of Buea locations.

---

### PRIORITY 7 — Push Notifications (FCM)

**Goal:** Notify users about payment confirmations, new listings matching their interests, and listing inquiries.

**Dependencies:**
```yaml
firebase_messaging: ^14.0.0
flutter_local_notifications: ^17.0.0
```

**Database:**
```sql
CREATE TABLE notifications (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  type TEXT NOT NULL,
  title TEXT NOT NULL,
  body TEXT,
  data JSONB,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW()
);
```

**Notification types:**
- `payment_confirmed` — Fapshi payment success
- `new_inquiry` — Someone contacted about your listing
- `new_listing_match` — New book in a category you've browsed
- `impact_milestone` — "BookBridge just circulated its 500th book! 🎉"

**Implementation:**
1. Create `lib/core/notifications/notification_service.dart`
2. Update `NotificationsScreen` (currently placeholder) with real notification list
3. Unread badge on bottom nav Notifications icon
4. Impact milestone notifications tie into Priority 4's impact tracker

---

### PRIORITY 8 — Wishlist / Favorites

**Database:**
```sql
CREATE TABLE wishlists (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  listing_id UUID REFERENCES listings(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user_id, listing_id)
);
```

**Flutter:**
1. Create `lib/features/wishlist/` feature
2. Heart icon on `ListingCard` and `ListingDetailsScreen`
3. `WishlistScreen` accessible from Profile tab
4. Optimistic UI updates (toggle immediately, sync to Supabase)
5. `WishlistViewModel` with Provider

---

### PRIORITY 9 — Escrow Payment Flow

**Goal:** Trust layer on top of existing Fapshi integration.

**Flow:**
```
Buyer pays → Funds held in escrow →
Buyer confirms receipt (or 48h auto-release) →
Funds released to seller → Rating prompt shown → Impact metrics updated
```

**Database:**
```sql
CREATE TABLE escrow_transactions (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  listing_id UUID REFERENCES listings(id),
  buyer_id UUID REFERENCES profiles(id),
  seller_id UUID REFERENCES profiles(id),
  amount_fcfa INTEGER NOT NULL,
  fapshi_transaction_id TEXT,
  status TEXT DEFAULT 'held' CHECK (
    status IN ('held', 'released', 'refunded', 'disputed')
  ),
  held_at TIMESTAMP DEFAULT NOW(),
  released_at TIMESTAMP,
  release_deadline TIMESTAMP
);
```

**Steps:**
1. Modify Fapshi payment flow to route through escrow
2. "Confirm Receipt" button on buyer's transaction history
3. Supabase Edge Function for auto-release after 48h
4. Dispute flow: "There's a problem" → manual review queue
5. On release → trigger rating prompt (Priority 5) + update impact metrics (Priority 4)

---

## 🎨 UI/UX IMPROVEMENTS (Implement Alongside Above)

- **Shimmer skeleton loaders** on HomeScreen grid — replace `CircularProgressIndicator`
- **Image compression** before upload — max 800px width, 80% quality using `flutter_image_compress`
- **Empty state illustrations** — custom SVG for empty search, empty wishlist, empty profile
- **Book swap badge** on listings — sellers can optionally mark a book as "Swap Available" in addition to sale price
- **Featured listings carousel** refinement — ensure impact stats widget sits cleanly below it

---

## 📋 CODING STANDARDS — NON-NEGOTIABLE

1. **Zero flutter analyze issues** — run before every commit
2. **Clean Architecture** — every new feature: domain/data/presentation layers
3. **Either pattern** — all repository methods return `Either<Failure, T>`
4. **Provider for state** — new ViewModels extend `ChangeNotifier`
5. **Register in GetIt** — all new services/repos/use cases in `injection_container.dart`
6. **Before every commit:**
   ```bash
   dart fix --apply
   flutter analyze
   dart format .
   ```
7. **Branch naming:** `feature/condition-grading`, `feature/offline-cache`, `feature/impact-tracker`, etc.
8. **Commit messages:** Conventional commits — `feat:`, `fix:`, `refactor:`, `docs:`

---

## 🏆 CONTEXT: WHY THIS MATTERS

BookBridge is a candidate for **PROMOTE 2026** — an investor showcase at Palais des Congrès, Yaoundé (June 15–21, 2026). ICT University will present 5 student projects to 200+ investors. **Pre-selection deadline: June 1, 2026.**

**Features investors will care about most (in order):**
1. **Impact metrics** — books circulated, money saved, CO2 avoided (Priority 4)
2. **Seller ratings** — trust = monetization potential (Priority 5)
3. **Escrow payments** — fraud prevention = scale (Priority 9)
4. **Offline cache** — African market fit = TAM story (Priority 3)
5. **Safety infrastructure** — platform maturity signal (Priority 6)

The social mission framing (book-for-book model, SDG alignment, B-Corp direction) is what differentiates BookBridge from a generic marketplace. Every feature should reinforce that story.

Build like investors are watching. 🚀

---

## 📊 STRATEGIC CONTEXT (From Analysis Document)

BookBridge should model itself after these global platforms while staying African-first:

| Platform | Key Lesson for BookBridge |
|---|---|
| Better World Books | Book-for-book donations, impact reporting, B-Corp mission |
| World of Books (Wob) | Author revenue sharing, zero-waste pledge, library sourcing |
| Bookshop.org | 80% margin to local ecosystem partners |
| ThriftBooks | Standardized condition grading, tiered loyalty |
| Kenya's Text Book Centre | Curriculum-aligned inventory, East African market proof |

**Target metrics to display at PROMOTE 2026:**
- Books circulated: track from day 1
- Students reached: unique active users
- Money saved: (avg new price − sale price) × transactions
- CO2 avoided: 2.7kg × books reused

---

*Brief v2 prepared by Claude (Anthropic) for Mr. DCT / DevSafe*
*BookBridge v1.4.0 → v2.0.0 sprint | PROMOTE 2026 ready*
