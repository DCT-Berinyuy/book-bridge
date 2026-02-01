Here is a comprehensive prompt for another AI agent (e.g., Qwen Coder CLI) to take over the remaining work on the BookBridge Flutter application.

**Project Overview:**
The BookBridge app is a Flutter-based peer-to-peer marketplace for students to buy and sell used books in Cameroon. Its backend is powered by Supabase. The application follows a Clean Architecture pattern, separating concerns into Domain, Data, and Presentation layers.

**Current Project State (as of commit `d8a9ddd`):**
*   **Authentication & User Profiles (Phase 1 Complete):**
    *   Sign-up, Sign-in, and Forgot Password functionalities are fully implemented, including UI feedback with `SnackBar`s.
    *   User profile management (display, update, sign-out) is implemented.
    *   Supabase backend integration for authentication and profile data (`profiles` table) is complete.
    *   SQL setup for `handle_new_user` trigger and RLS policies for `profiles` has been provided in `SUPABASE_SETUP.md`.
*   **Listings & Core Functionality (Phase 2 Complete):**
    *   Basic listing creation and image upload to Supabase Storage are implemented.
    *   User-specific folder structure for image uploads (`book_images/<user_id>/<filename>`) is handled.
    *   Image deletion functionality from Supabase Storage is implemented.
    *   Fetching of real listings (including seller information via joins) for the Home and Listing Details screens is implemented.
    *   Full-text search using a Supabase RPC function (`search_listings`) is implemented.
    *   SQL setup for `book_images` bucket creation, Storage RLS policies, `search_listings` RPC, `tsv` column, and related trigger for `listings` has been provided in `SUPABASE_SETUP.md`.
    *   RLS policies for the `listings` table (create, read all, update own, delete own) have been provided in `SUPABASE_SETUP.md`.
*   **Code Quality:** The project was in a clean state (no analyzer errors or warnings) after the end of Phase 2.

**Urgent Pre-Requisite Action for This Agent:**
1.  **Revert to last good commit:** Before proceeding with any new tasks, please ensure the working directory is clean and consistent with the state at the end of Phase 2. To do this, execute the following command in the terminal:
    ```bash
    git reset --hard d8a9ddd
    ```
    This will undo any partial or erroneous changes made after Phase 2 and bring the codebase to a stable state.

**Remaining Tasks (from `IMPLEMENTATION_PLAN.md` - Phase 3: Final Polishing):**

```markdown
## Phase 3: Final Polishing

- [ ] **Task 3.1: Category Filtering**
  - [ ] Add a `category` column to the `listings` table and provide the `ALTER TABLE` SQL.
  - [ ] Implement the filtering logic in the `HomeViewModel` and data source when a category chip is selected.

- [ ] **Task 3.2: Notifications (UI Placeholder)**
  - [ ] Create a basic, empty notifications screen to make the app bar icon functional.

- [ ] **Task 3.3: Code Cleanup and Final Review**
  - [ ] Remove any remaining mock data or hardcoded values.
  - [ ] Run `flutter analyze` and `dart format .` to ensure code quality.
  - [ ] Review the entire app for any UI/UX inconsistencies.

- [ ] **Git Commit: `fix(app): Final polishing and feature completion`**
```

**Instructions for the New Agent:**
*   You are taking over development of the BookBridge Flutter application.
*   Your primary goal is to bring the app to a production-ready state, as outlined in the `IMPLEMENTATION_PLAN.md`.
*   **Crucially, start by executing the `git reset --hard d8a9ddd` command to resolve any existing inconsistencies or errors in the codebase.**
*   Then, meticulously re-implement and complete the tasks in Phase 3 of the `IMPLEMENTATION_PLAN.md`.
*   **Important Note on Phase 3 Tasks:**
    *   **Task 3.1 (Category Filtering):** This task was partially attempted. Please re-implement it from scratch, including:
        1.  Adding the `category` column to the `listings` table (SQL provided in `SUPABASE_SETUP.md`).
        2.  Updating `Listing` entity, `ListingModel`, `CreateListingParams`.
        3.  Modifying `SupabaseListingsDataSource.getListings` for category filtering.
        4.  Updating `GetListingsUseCase` to accept `category`.
        5.  Updating `HomeViewModel` to manage `selectedCategory`.
        6.  Updating `home_screen.dart` to pass the `selectedCategory`.
    *   **Task 3.2 (Notifications UI Placeholder):** This task was also partially attempted. Please re-implement it from scratch, including:
        1.  Creating `notifications_screen.dart`.
        2.  Adding its route to `lib/config/router.dart`.
        3.  Connecting the `onPressed` of the notification icon in `home_screen.dart`.
    *   **Task 3.3 (Code Cleanup and Final Review):** The hardcoded stats in `profile_screen.dart` were *partially* addressed but might need re-doing after the revert. Ensure all mock data is removed and thorough code review is performed.
*   After completing **each sub-task**, update the `IMPLEMENTATION_PLAN.md` by changing `[ ]` to `[x]`.
*   After completing **each main Phase (e.g., Phase 3)**, commit the changes to git using the specified commit message.
*   For any Supabase SQL code required, it has already been provided in `SUPABASE_SETUP.md`. Please direct the user to run the relevant SQL from that file.
*   Use `flutter analyze` and `dart format .` regularly to maintain code quality.
*   Always explain your steps and rationale clearly to the user.

**Files for Reference (Please read these in full):**
*   `IMPLEMENTATION_PLAN.md`
*   `SUPABASE_SETUP.md`
*   All files within `lib/features` related to auth and listings.
*   `lib/config/router.dart`
*   `lib/injection_container.dart`

This prompt encapsulates all the necessary information for the new agent to seamlessly continue the development process.
