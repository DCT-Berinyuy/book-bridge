# BookBridge: Production-Ready Implementation Plan

This document outlines the steps to transform the BookBridge app from a prototype with mock data into a production-ready application with full backend integration. I will update this file to mark tasks as complete.

## Phase 1: Authentication and User Profiles

- [x] **Task 1.1: Refine Sign-Up Screen & Logic**
  - [x] Ensure the UI provides clear feedback on success or failure (e.g., using `ScaffoldMessenger`).
  - [x] On successful sign-up with Supabase Auth, create a corresponding entry in the `profiles` table.
  - [x] Add form validation for password strength (e.g., min 6 characters) and email format.

- [x] **Task 1.2: Refine Sign-In Screen & Logic**
  - [x] Implement robust error handling for incorrect credentials, unverified emails, etc.
  - [x] Add a "Forgot Password" functionality (UI and logic using Supabase's password reset).

- [x] **Task 1.3: Enhance Profile Screen**
  - [x] Fetch and display the current user's profile information (`full_name`, `email`, etc.) from the `profiles` table.
  - [x] Allow users to update their profile information.
  - [x] Implement a "Sign Out" button that clears the user session.

- [x] **Task 1.4: Secure `profiles` Table**
  - [x] Provide SQL for Row Level Security (RLS) policies.

- [ ] **Git Commit: `feat(auth): Complete auth and user profile implementation`**

## Phase 2: Listings and Core Functionality

- [x] **Task 2.1: Implement Image Upload for Sell Screen**
  - [x] Integrate `image_picker` to allow users to select an image from their gallery or camera.
  - [x] Upload the selected image to a Supabase Storage bucket named `book_images`.
  - [x] On successful upload, retrieve the public URL of the image.

- [x] **Task 2.2: Implement "Sell a Book" Logic**
  - [x] On form submission, create a new record in the `listings` table with all book details and the public image URL.
  - [x] The `seller_id` must be the ID of the currently logged-in user.
  - [x] Provide clear user feedback on success or failure.

- [x] **Task 2.3: Real-time Data for Home and Details**
  - [x] Ensure the Home Screen (`home_screen.dart`) fetches real listings from the `listings` table, including seller information via a table join.
  - [x] Ensure the Listing Details screen fetches all data for a specific listing.

- [x] **Task 2.4: Implement Search Functionality**
  - [x] Connect the Search Screen UI to a Supabase RPC (Remote Procedure Call) for full-text search on the `listings` table.
  - [x] Provide the SQL to create the `search_listings` function.

- [x] **Task 2.5: Secure `listings` and `book_images`**
  - [x] Provide SQL for RLS policies for the `listings` table (users can create listings, read all, and update/delete their own).
  - [x] Provide SQL for Storage policies for the `book_images` bucket (users can upload, all can read).

- [ ] **Git Commit: `feat(listings): Implement complete CRUD and search for listings`**

## Phase 3: Final Polishing

- [x] **Task 3.1: Category Filtering**
  - [x] Add a `category` column to the `listings` table and provide the `ALTER TABLE` SQL.
  - [x] Implement the filtering logic in the `HomeViewModel` and data source when a category chip is selected.

- [x] **Task 3.2: Notifications (UI Placeholder)**
  - [x] Create a basic, empty notifications screen to make the app bar icon functional.

- [x] **Task 3.3: Code Cleanup and Final Review**
  - [x] Remove any remaining mock data or hardcoded values.
  - [x] Run `flutter analyze` and `dart format .` to ensure code quality.
  - [x] Review the entire app for any UI/UX inconsistencies.

- [ ] **Git Commit: `fix(app): Final polishing and feature completion`**
