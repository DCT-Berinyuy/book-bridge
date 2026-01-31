# BookBridge Supabase Setup Guide

This guide will walk you through creating a Supabase project and integrating it with the BookBridge Flutter application step-by-step.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Step 1: Create Supabase Account](#step-1-create-supabase-account)
3. [Step 2: Create a New Project](#step-2-create-a-new-project)
4. [Step 3: Set Up Database Tables](#step-3-set-up-database-tables)
5. [Step 4: Configure Authentication](#step-4-configure-authentication)
6. [Step 5: Get API Credentials](#step-5-get-api-credentials)
7. [Step 6: Integrate with Flutter App](#step-6-integrate-with-flutter-app)
8. [Step 7: Test the Integration](#step-7-test-the-integration)
9. [Troubleshooting](#troubleshooting)

---

## Prerequisites

Before you start, make sure you have:
- A Google or GitHub account (for signing up to Supabase)
- The BookBridge Flutter app downloaded/cloned
- Flutter SDK installed on your machine
- A code editor (VS Code recommended)

---

## Step 1: Create Supabase Account

### 1.1 Navigate to Supabase
1. Open your web browser and go to https://supabase.com
2. Click the **"Start your project"** or **"Sign In"** button in the top right

### 1.2 Sign Up
1. Click **"Sign up"** (or if you already have an account, click "Sign In")
2. Choose **"Continue with Google"** or **"Continue with GitHub"**
3. Follow the authentication flow and authorize Supabase
4. Complete your account setup

### 1.3 Verify Your Account
- Check your email for a verification link (if required)
- Click the verification link to confirm your email address

**Result**: You now have a Supabase account ✅

---

## Step 2: Create a New Project

### 2.1 Access the Dashboard
1. After signing in, you'll be on the Supabase Dashboard
2. You should see an option to **"Create a new project"** or a **"New Project"** button

### 2.2 Create Project
1. Click **"New Project"** or **"Create a new project"**
2. Fill in the project details:
   - **Project Name**: `book_bridge` (or any name you prefer)
   - **Database Password**: Create a strong password (save this - you'll need it!)
   - **Region**: Select a region closest to you or where your users are
     - For Cameroon: Europe (eu-west-1) or Africa (Africa - Cape Town) if available
   - **Pricing Plan**: Select "Free" for development

### 2.3 Create the Project
1. Click **"Create new project"**
2. Wait for the project to be created (this takes 2-3 minutes)
3. You'll see a loading screen - this is normal, wait for it to complete

### 2.4 Project Created
- You'll see your project dashboard with options for Database, Authentication, Storage, etc.

**Result**: Your Supabase project is created ✅

---

## Step 3: Set Up Database Tables

Now we'll create the two tables needed for BookBridge: `profiles` and `listings`

### 3.1 Create the Profiles Table

The profiles table stores user information.

#### Method A: Using Supabase SQL Editor (Recommended for learning)

1. In the left sidebar, click **"SQL Editor"**
2. Click **"New Query"**
3. Copy and paste the following SQL code:

```sql
-- Create profiles table
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users (id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  locality TEXT,
  whatsapp_number TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Create RLS policy: Authenticated users can view all profiles (for listings info)
CREATE POLICY "Authenticated users can view all profiles"
  ON profiles FOR SELECT
  USING (auth.role() = 'authenticated');

-- Create RLS policy: Users can update their own profile
CREATE POLICY "Users can update their own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);

-- Create RLS policy: Allow insert during signup
CREATE POLICY "Enable insert for authentication"
  ON profiles FOR INSERT
  WITH CHECK (auth.uid() = id);
```

4. Click **"Run"** or press Ctrl+Enter
5. You should see a success message

#### Method B: Using Table Editor (Visual approach)

1. In the left sidebar, click **"Table Editor"**
2. Click **"Create a new table"**
3. Fill in:
   - **Table Name**: `profiles`
   - **Description**: User profile information
4. Add columns by clicking **"Add column"**:

   | Column Name | Type | Required | Default |
   |---|---|---|---|
   | id | uuid | ✓ | (leave empty) |
   | email | text | ✓ | (leave empty) |
   | full_name | text | ✗ | (leave empty) |
   | locality | text | ✗ | (leave empty) |
   | whatsapp_number | text | ✗ | (leave empty) |
   | created_at | timestamp | ✗ | now() |
   | updated_at | timestamp | ✗ | now() |

5. Click **"Create table"**

**Note**: After creating visually, you still need to enable RLS and create policies (use the SQL from Method A)

### 3.2 Create the Listings Table

The listings table stores book listing information.

1. In SQL Editor, click **"New Query"**
2. Copy and paste:

```sql
-- Create listings table
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
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE listings ENABLE ROW LEVEL SECURITY;

-- Create RLS policy: Anyone can view available listings
CREATE POLICY "Anyone can view available listings"
  ON listings FOR SELECT
  USING (status = 'available');

-- Create RLS policy: Users can view their own listings (including sold/pending)
CREATE POLICY "Users can view their own listings"
  ON listings FOR SELECT
  USING (auth.uid() = seller_id);

-- Create RLS policy: Users can create listings
CREATE POLICY "Users can create listings"
  ON listings FOR INSERT
  WITH CHECK (auth.uid() = seller_id);

-- Create RLS policy: Users can update their own listings
CREATE POLICY "Users can update their own listings"
  ON listings FOR UPDATE
  USING (auth.uid() = seller_id);

-- Create RLS policy: Users can delete their own listings
CREATE POLICY "Users can delete their own listings"
  ON listings FOR DELETE
  USING (auth.uid() = seller_id);

-- Create indexes for better query performance
CREATE INDEX listings_seller_id_idx ON listings(seller_id);
CREATE INDEX listings_status_idx ON listings(status);
CREATE INDEX listings_created_at_idx ON listings(created_at DESC);
```

3. Click **"Run"**
4. You should see a success message

### 3.3 Verify Tables Created

1. Click **"Table Editor"** in the left sidebar
2. You should see two tables listed:
   - `profiles`
   - `listings`

**Result**: Database tables are set up ✅

---

## Step 4: Configure Authentication

### 4.1 Set Up Email/Password Authentication

1. In the left sidebar, click **"Authentication"**
2. You'll see the "Auth Providers" section
3. By default, Email/Password should be enabled (look for a green checkmark)

### 4.2 Verify Email Provider is Enabled

1. Look for **"Email"** in the providers list
2. It should show "Enabled" with a green checkmark
3. If not, click on it and toggle to enable

### 4.3 Email Templates (Optional but Recommended)

1. Scroll down to **"Email Templates"**
2. You can customize confirmation and recovery emails here
3. For now, the defaults are fine

### 4.4 User Management

1. Click the **"Users"** tab at the top
2. This is where you'll see all registered users after they sign up

**Result**: Authentication is configured ✅

---

## Step 5: Get API Credentials

These credentials will connect your Flutter app to Supabase.

### 5.1 Find Your Project Settings

1. In the left sidebar, scroll down and click **"Settings"** (gear icon)
2. Select **"API"** from the submenu

### 5.2 Get Supabase URL

1. You should see **"Project URL"** section
2. Find the **"Supabase URL"** field
3. Copy the URL (it looks like: `https://xxxxxxxxxxxxx.supabase.co`)
4. **Save this in a safe place** - you'll need it for Flutter

### 5.3 Get Supabase Anon Key

1. In the same API section, find **"Project API keys"**
2. Look for **"Anon (public)"** key
3. Copy the key (it's a long string starting with `eyJ...`)
4. **Save this in a safe place** - you'll need it for Flutter

**⚠️ Important Security Note**: 
- Keep your API keys safe
- The Anon key can be public (it's used in the Flutter app)
- Never share your Service Role key

**Result**: You have your API credentials ✅

---

## Step 6: Integrate with Flutter App

Now let's connect the BookBridge app to your Supabase project.

### 6.1 Update main.dart

1. Open the Flutter project in your code editor
2. Navigate to `lib/main.dart`
3. Find the line that initializes Supabase (should look something like this):

```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_SUPABASE_ANON_KEY',
);
```

4. Replace the placeholders with your credentials:
   - Replace `YOUR_SUPABASE_URL` with your Supabase URL from Step 5.2
   - Replace `YOUR_SUPABASE_ANON_KEY` with your Anon key from Step 5.3

**Example** (with fake credentials):
```dart
await Supabase.initialize(
  url: 'https://abcdefghijkl.supabase.co',
  anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
);
```

### 6.2 Verify the Update

1. Save the file (Ctrl+S or Cmd+S)
2. The file should auto-format if you have Dart formatting enabled
3. Check for any errors in the VS Code Problems panel

**Result**: Flutter app is configured with Supabase ✅

---

## Step 7: Test the Integration

### 7.1 Run the Flutter App

1. Open a terminal in your project directory
2. Run the following command:

```bash
flutter run
```

3. Wait for the app to compile and launch on your emulator/device

### 7.2 Test Sign Up

1. On the sign-up screen, enter:
   - **Email**: test@example.com
   - **Password**: TestPassword123!
   - **Full Name**: Test User

2. Click **"Sign Up"**
3. You should see a success message and be redirected to the home screen

### 7.3 Verify in Supabase

1. Go back to your Supabase dashboard
2. Click **"Authentication"** → **"Users"**
3. You should see your test user with the email you registered

### 7.4 Check Database

1. Click **"Table Editor"**
2. Select the **"profiles"** table
3. You should see a row with your test user's information

**Result**: Integration is working ✅

### 7.5 Test Sign In

1. Sign out from the app or force close and reopen it
2. Go to the Sign In screen
3. Enter your test email and password
4. Click **"Sign In"**
5. You should be logged in and see the home screen

---

## Advanced: Create Sample Listings (Optional)

To test your app without uploading images, you can manually add some test listings to the database.

### Option A: Using SQL Editor

1. Go to **"SQL Editor"** in Supabase
2. Click **"New Query"**
3. Run this SQL to add a sample listing:

```sql
INSERT INTO listings (
  title,
  author,
  price_fcfa,
  condition,
  image_url,
  description,
  seller_id,
  status
) VALUES (
  'Introduction to Algorithms',
  'Cormen, Leiserson, Rivest, Stein',
  15000,
  'good',
  'https://via.placeholder.com/200x300?text=Algorithms',
  'Slightly used, pages are clean. Missing dust cover.',
  'SELECT id FROM profiles LIMIT 1',
  'available'
);
```

**Note**: Replace the `seller_id` with an actual profile ID from your database

### Option B: Using Table Editor

1. Go to **"Table Editor"**
2. Click on the **"listings"** table
3. Click **"Insert row"** or **"+"**
4. Fill in the values manually:
   - title: "Introduction to Algorithms"
   - author: "Cormen, Leiserson, Rivest, Stein"
   - price_fcfa: 15000
   - condition: "good"
   - image_url: "https://via.placeholder.com/200x300?text=Algorithms"
   - seller_id: (select your user's ID from the profiles table)
   - status: "available"

5. Click **"Save"**

### 7.6 Test Home Screen

1. In your app, navigate to the Home screen
2. You should see your sample listings displayed in a grid
3. Click on a listing to see the details

---

## Troubleshooting

### Issue: "Connection refused" or "Cannot connect to Supabase"

**Solution**:
1. Check your Supabase URL and Anon key in `main.dart`
2. Make sure there are no extra spaces or typos
3. Verify the URL starts with `https://`
4. Try closing and reopening the app

### Issue: Sign Up Works but User Doesn't Appear in Dashboard

**Solution**:
1. Refresh the Supabase dashboard in your browser
2. Check the **"Users"** tab under Authentication
3. Make sure the user's email is correct
4. Try signing up with a different email

### Issue: Listings Don't Appear on Home Screen

**Solution**:
1. Verify listings exist in the database:
   - Go to **"Table Editor"** → **"listings"**
   - Check if any rows exist
2. Check that listings have `status = 'available'`
3. Try adding a sample listing manually
4. Restart the Flutter app (hot restart may not be enough)

### Issue: RLS (Row Level Security) Errors

**Error message**: "new row violates row-level security policy"

**Solution**:
1. This means the RLS policies aren't set up correctly
2. Go to **"SQL Editor"** and run all the SQL from Step 3 again
3. Verify all policies were created successfully

### Issue: Image URLs Show Placeholder

**Current State**: The app currently uses placeholder images

**Solution for Future**:
1. In Phase 7, implement image upload to Supabase Storage
2. For now, use external image URLs (like placeholder.com)
3. You can update the `image_url` field manually in the database

### Issue: WhatsApp Integration Not Working

**Solution**:
1. Verify the `whatsapp_number` is stored in the profiles table
2. Make sure the phone number includes country code (e.g., +237 for Cameroon)
3. Format: `+237XXXXXXXXX` (where X are digits)

---

## Security Best Practices

### 1. Never Commit Credentials to Git

⚠️ **IMPORTANT**: Your Supabase URL and Anon key should NOT be hardcoded in production.

**Best Practice for Development**:
- Use environment variables
- Create a `.env` file (don't commit it)
- Use a package like `flutter_dotenv` to load from `.env`

**Example setup** (for future):
```dart
// main.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

await Supabase.initialize(
  url: dotenv.env['SUPABASE_URL']!,
  anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
);
```

### 2. Row Level Security (RLS)

- ✅ We've enabled RLS on both tables
- ✅ Users can only see/modify their own data
- ✅ Anyone can view available listings

### 3. Password Security

- Supabase handles password hashing automatically
- Never send passwords in plain text (HTTPS is used)
- Encourage strong passwords in your app validation

### 4. Backup Your Database

- Supabase provides automated backups on paid plans
- For free tier, manually export data regularly
- Go to **"Settings"** → **"Backups"** to manage backups

---

## Next Steps

After integration is complete:

1. **Test All Features**: Try signing up, signing in, creating listings
2. **Add More Test Data**: Create multiple test accounts and listings
3. **Test Edge Cases**: Try invalid inputs, network errors, etc.
4. **Review RLS Policies**: Ensure your data is secure
5. **Plan Phase 7**: Image upload to Supabase Storage

---

## Useful Supabase Documentation Links

- [Supabase Official Documentation](https://supabase.com/docs)
- [Flutter + Supabase Guide](https://supabase.com/docs/guides/getting-started/quickstarts/flutter)
- [Row Level Security (RLS)](https://supabase.com/docs/guides/auth/row-level-security)
- [Database Functions](https://supabase.com/docs/guides/database/functions)

---

## Additional Resources

### Using Supabase Studio

Supabase Studio is the web-based IDE for managing your project:
- **Table Editor**: Visual way to manage tables and data
- **SQL Editor**: Write and run SQL queries
- **Authentication**: Manage users and auth providers
- **API Docs**: Auto-generated documentation for your API

### Common SQL Commands

```sql
-- View all users in profiles table
SELECT * FROM profiles;

-- View all available listings
SELECT * FROM listings WHERE status = 'available';

-- View a user's listings
SELECT * FROM listings WHERE seller_id = 'USER_ID_HERE';

-- Update a listing status
UPDATE listings SET status = 'sold' WHERE id = 'LISTING_ID_HERE';

-- Delete a listing
DELETE FROM listings WHERE id = 'LISTING_ID_HERE' AND seller_id = 'USER_ID_HERE';
```

---

## Support

If you encounter any issues:

1. Check the [Troubleshooting](#troubleshooting) section above
2. Review the Supabase documentation
3. Check your internet connection
4. Try clearing Flutter build cache: `flutter clean && flutter pub get`
5. Restart your device/emulator

---

**Last Updated**: January 25, 2026
**Status**: Ready for Integration ✅

Good luck with your BookBridge integration! 🚀
\n## Automatic Profile Creation on Sign-Up (Production Setup)\n\nThis SQL code creates a trigger that automatically adds a new user to the `profiles` table whenever they sign up through Supabase Authentication. This is crucial for the app to function correctly.\n\nPlease run this in your Supabase SQL Editor:\n\n```sql\n-- Function to create a profile for a new user\ncreate function public.handle_new_user()\nreturns trigger\nlanguage plpgsql\nsecurity definer set search_path = public\nas $$\nbegin\n  insert into public.profiles (id, full_name, email, locality, whatsapp_number)\n  values (\n    new.id,\n    new.raw_user_meta_data->>'full_name',\n    new.email,\n    new.raw_user_meta_data->>'locality',\n    new.raw_user_meta_data->>'whatsapp_number'\n  );\n  return new;\nend;\n$$\n\n-- Trigger to run the function after a new user is created\ncreate or replace trigger on_auth_user_created\n  after insert on auth.users\n  for each row execute procedure public.handle_new_user();\n```\n
