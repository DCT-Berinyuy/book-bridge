import 'package:book_bridge/core/providers/locale_provider.dart';
import 'package:book_bridge/features/auth/data/datasources/supabase_auth_data_source.dart';
import 'package:book_bridge/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:book_bridge/features/auth/domain/repositories/auth_repository.dart';
import 'package:book_bridge/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:book_bridge/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:book_bridge/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:book_bridge/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:book_bridge/features/auth/domain/usecases/send_password_reset_email_usecase.dart';
import 'package:book_bridge/features/auth/domain/usecases/update_user_usecase.dart';
import 'package:book_bridge/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:book_bridge/features/listings/data/datasources/supabase_listings_data_source.dart';
import 'package:book_bridge/features/listings/data/datasources/supabase_storage_data_source.dart';
import 'package:book_bridge/features/listings/data/repositories/listing_repository_impl.dart';
import 'package:book_bridge/features/listings/domain/repositories/listing_repository.dart';
import 'package:book_bridge/features/listings/domain/usecases/get_listings_usecase.dart';
import 'package:book_bridge/features/listings/domain/usecases/get_listing_details_usecase.dart';
import 'package:book_bridge/features/listings/domain/usecases/create_listing_usecase.dart';
import 'package:book_bridge/features/listings/domain/usecases/delete_listing_usecase.dart';
import 'package:book_bridge/features/listings/domain/usecases/get_user_listings_usecase.dart';
import 'package:book_bridge/features/listings/domain/usecases/search_listings_usecase.dart';
import 'package:book_bridge/features/listings/presentation/viewmodels/home_viewmodel.dart';
import 'package:book_bridge/features/listings/presentation/viewmodels/listing_details_viewmodel.dart';
import 'package:book_bridge/features/listings/presentation/viewmodels/sell_viewmodel.dart';
import 'package:book_bridge/features/listings/presentation/viewmodels/profile_viewmodel.dart';
import 'package:book_bridge/features/listings/presentation/viewmodels/search_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service locator for dependency injection.
///
/// This singleton is responsible for managing the lifecycle of all
/// dependencies used throughout the application.
final getIt = GetIt.instance;

/// Initializes all dependencies for the application.
///
/// This function should be called in main.dart during app initialization
/// to set up the dependency injection container.
///
/// The dependencies are organized by layers:
/// - Core dependencies (error handling, usecases, theme)
/// - Feature-specific dependencies (auth, listings)
Future<void> setupDependencyInjection() async {
  // Core Providers
  getIt.registerSingleton<LocaleProvider>(LocaleProvider());

  // Initialize Supabase (must be done before other setup)
  final supabase = Supabase.instance.client;
  getIt.registerSingleton<SupabaseClient>(supabase);

  // Auth Feature - Data Layer
  getIt.registerSingleton<SupabaseAuthDataSource>(
    SupabaseAuthDataSource(supabaseClient: getIt<SupabaseClient>()),
  );

  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(dataSource: getIt<SupabaseAuthDataSource>()),
  );

  // Auth Feature - Domain Layer (Use Cases)
  getIt.registerSingleton<SignUpUseCase>(
    SignUpUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerSingleton<SignInUseCase>(
    SignInUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerSingleton<SignOutUseCase>(
    SignOutUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerSingleton<GetCurrentUserUseCase>(
    GetCurrentUserUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerSingleton<SendPasswordResetEmailUseCase>(
    SendPasswordResetEmailUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerSingleton<UpdateUserUseCase>(
    UpdateUserUseCase(repository: getIt<AuthRepository>()),
  );

  // Auth Feature - Presentation Layer (ViewModels)
  getIt.registerSingleton<AuthViewModel>(
    AuthViewModel(
      signUpUseCase: getIt<SignUpUseCase>(),
      signInUseCase: getIt<SignInUseCase>(),
      signOutUseCase: getIt<SignOutUseCase>(),
      getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
      sendPasswordResetEmailUseCase: getIt<SendPasswordResetEmailUseCase>(),
      repository: getIt<AuthRepository>(),
    ),
  );

  // Listings Feature - Data Layer
  getIt.registerSingleton<SupabaseStorageDataSource>(
    SupabaseStorageDataSource(supabaseClient: getIt<SupabaseClient>()),
  );

  getIt.registerSingleton<SupabaseListingsDataSource>(
    SupabaseListingsDataSource(
      supabaseClient: getIt<SupabaseClient>(),
      storageDataSource: getIt<SupabaseStorageDataSource>(),
    ),
  );

  getIt.registerSingleton<ListingRepository>(
    ListingRepositoryImpl(dataSource: getIt<SupabaseListingsDataSource>()),
  );

  // Listings Feature - Domain Layer (Use Cases)
  getIt.registerSingleton<GetListingsUseCase>(
    GetListingsUseCase(repository: getIt<ListingRepository>()),
  );

  getIt.registerSingleton<GetListingDetailsUseCase>(
    GetListingDetailsUseCase(repository: getIt<ListingRepository>()),
  );

  getIt.registerSingleton<CreateListingUseCase>(
    CreateListingUseCase(repository: getIt<ListingRepository>()),
  );

  getIt.registerSingleton<DeleteListingUseCase>(
    DeleteListingUseCase(repository: getIt<ListingRepository>()),
  );

  getIt.registerSingleton<GetUserListingsUseCase>(
    GetUserListingsUseCase(repository: getIt<ListingRepository>()),
  );

  getIt.registerSingleton<SearchListingsUseCase>(
    SearchListingsUseCase(repository: getIt<ListingRepository>()),
  );

  // Listings Feature - Presentation Layer (ViewModels)
  getIt.registerSingleton<HomeViewModel>(
    HomeViewModel(getListingsUseCase: getIt<GetListingsUseCase>()),
  );

  getIt.registerSingleton<ListingDetailsViewModel>(
    ListingDetailsViewModel(
      getListingDetailsUseCase: getIt<GetListingDetailsUseCase>(),
    ),
  );

  getIt.registerSingleton<SellViewModel>(
    SellViewModel(
      createListingUseCase: getIt<CreateListingUseCase>(),
      repository: getIt<ListingRepository>(),
    ),
  );

  getIt.registerSingleton<ProfileViewModel>(
    ProfileViewModel(
      getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
      getUserListingsUseCase: getIt<GetUserListingsUseCase>(),
      deleteListingUseCase: getIt<DeleteListingUseCase>(),
      updateUserUseCase: getIt<UpdateUserUseCase>(),
    ),
  );

  getIt.registerSingleton<SearchViewModel>(
    SearchViewModel(searchListingsUseCase: getIt<SearchListingsUseCase>()),
  );
}
