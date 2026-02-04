import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @aVerifiedLocalBookshopSupportingTheCommunityPeriod.
  ///
  /// In en, this message translates to:
  /// **'A verified local bookshop supporting the community.'**
  String get aVerifiedLocalBookshopSupportingTheCommunityPeriod;

  /// No description provided for @academicCategories.
  ///
  /// In en, this message translates to:
  /// **'Academic Categories'**
  String get academicCategories;

  /// No description provided for @addBookPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add book photos'**
  String get addBookPhotos;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @author.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get author;

  /// No description provided for @availableStock.
  ///
  /// In en, this message translates to:
  /// **'Available Stock'**
  String get availableStock;

  /// No description provided for @beTheFirstToListABookInYourAreaExclamation_mark.
  ///
  /// In en, this message translates to:
  /// **'Be the first to list a book in your area!'**
  String get beTheFirstToListABookInYourAreaExclamation_mark;

  /// No description provided for @bookCondition.
  ///
  /// In en, this message translates to:
  /// **'Book Condition'**
  String get bookCondition;

  /// No description provided for @bookDetails.
  ///
  /// In en, this message translates to:
  /// **'Book Details'**
  String get bookDetails;

  /// No description provided for @bookTitle.
  ///
  /// In en, this message translates to:
  /// **'Book Title'**
  String get bookTitle;

  /// No description provided for @bookbridge.
  ///
  /// In en, this message translates to:
  /// **'BookBridge'**
  String get bookbridge;

  /// No description provided for @bookbridgeColonSocialVenture.
  ///
  /// In en, this message translates to:
  /// **'BookBridge: Social Venture'**
  String get bookbridgeColonSocialVenture;

  /// No description provided for @buyHyphenBackEligible.
  ///
  /// In en, this message translates to:
  /// **'Buy-Back Eligible'**
  String get buyHyphenBackEligible;

  /// No description provided for @callSeller.
  ///
  /// In en, this message translates to:
  /// **'Call Seller'**
  String get callSeller;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @contactSellerViaWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Contact Seller via WhatsApp'**
  String get contactSellerViaWhatsapp;

  /// No description provided for @couldNotLaunchWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Could not launch WhatsApp'**
  String get couldNotLaunchWhatsapp;

  /// No description provided for @createYourFirstListingToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Create your first listing to get started'**
  String get createYourFirstListingToGetStarted;

  /// No description provided for @criminalProcedureCode.
  ///
  /// In en, this message translates to:
  /// **'Criminal Procedure Code'**
  String get criminalProcedureCode;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **' days ago'**
  String get daysAgo;

  /// No description provided for @describeTheBookOpen_parenthesisEditionCommaLanguageCommaEtcPeriodClose_parenthesis.
  ///
  /// In en, this message translates to:
  /// **'Describe the book (edition, language, etc.)'**
  String
  get describeTheBookOpen_parenthesisEditionCommaLanguageCommaEtcPeriodClose_parenthesis;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @directFromTheAuthorPeriodSupportingLocalCreativityPeriod.
  ///
  /// In en, this message translates to:
  /// **'Direct from the author. Supporting local creativity.'**
  String get directFromTheAuthorPeriodSupportingLocalCreativityPeriod;

  /// No description provided for @ePeriodGPeriod10.
  ///
  /// In en, this message translates to:
  /// **'e.g. 10'**
  String get ePeriodGPeriod10;

  /// No description provided for @ePeriodGPeriodNelkonAmpersandParker.
  ///
  /// In en, this message translates to:
  /// **'e.g. Nelkon & Parker'**
  String get ePeriodGPeriodNelkonAmpersandParker;

  /// No description provided for @ePeriodGPeriodPurePhysics.
  ///
  /// In en, this message translates to:
  /// **'e.g. Pure Physics'**
  String get ePeriodGPeriodPurePhysics;

  /// No description provided for @economics.
  ///
  /// In en, this message translates to:
  /// **'Economics'**
  String get economics;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @ehlwo.
  ///
  /// In en, this message translates to:
  /// **'ehlwo'**
  String get ehlwo;

  /// No description provided for @eligibleForBuyHyphenBack.
  ///
  /// In en, this message translates to:
  /// **'Eligible for Buy-Back'**
  String get eligibleForBuyHyphenBack;

  /// No description provided for @engineering.
  ///
  /// In en, this message translates to:
  /// **'Engineering'**
  String get engineering;

  /// No description provided for @failedToCreateUser.
  ///
  /// In en, this message translates to:
  /// **'Failed to create user'**
  String get failedToCreateUser;

  /// No description provided for @failedToLoadListing.
  ///
  /// In en, this message translates to:
  /// **'Failed to load listing'**
  String get failedToLoadListing;

  /// No description provided for @failedToLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get failedToLoadProfile;

  /// No description provided for @failedToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Failed to sign in'**
  String get failedToSignIn;

  /// No description provided for @failedToSignOutColon.
  ///
  /// In en, this message translates to:
  /// **'Failed to sign out: '**
  String get failedToSignOutColon;

  /// No description provided for @failedToUpdateProfilePeriod.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile.'**
  String get failedToUpdateProfilePeriod;

  /// No description provided for @fair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get fair;

  /// No description provided for @featureComingSoonExclamation_mark.
  ///
  /// In en, this message translates to:
  /// **'Feature coming soon!'**
  String get featureComingSoonExclamation_mark;

  /// No description provided for @featuredBooks.
  ///
  /// In en, this message translates to:
  /// **'Featured Books'**
  String get featuredBooks;

  /// No description provided for @fiction.
  ///
  /// In en, this message translates to:
  /// **'Fiction'**
  String get fiction;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @gce.
  ///
  /// In en, this message translates to:
  /// **'GCE'**
  String get gce;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @hiCommaIAmInterestedInYourBookListingExclamation_mark.
  ///
  /// In en, this message translates to:
  /// **'Hi, I am interested in your book listing!'**
  String get hiCommaIAmInterestedInYourBookListingExclamation_mark;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @individualStudent.
  ///
  /// In en, this message translates to:
  /// **'Individual Student'**
  String get individualStudent;

  /// No description provided for @introductionToMacroeconomics.
  ///
  /// In en, this message translates to:
  /// **'Introduction to Macroeconomics'**
  String get introductionToMacroeconomics;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @law.
  ///
  /// In en, this message translates to:
  /// **'Law'**
  String get law;

  /// No description provided for @likeNew.
  ///
  /// In en, this message translates to:
  /// **'Like New'**
  String get likeNew;

  /// No description provided for @listed.
  ///
  /// In en, this message translates to:
  /// **'Listed '**
  String get listed;

  /// No description provided for @listingCreatedSuccessfullyExclamation_mark.
  ///
  /// In en, this message translates to:
  /// **'Listing created successfully!'**
  String get listingCreatedSuccessfullyExclamation_mark;

  /// No description provided for @listingWillBeVisibleInYourCurrentRegion.
  ///
  /// In en, this message translates to:
  /// **'Listing will be visible in your current region'**
  String get listingWillBeVisibleInYourCurrentRegion;

  /// No description provided for @localAuthor.
  ///
  /// In en, this message translates to:
  /// **'Local Author'**
  String get localAuthor;

  /// No description provided for @localityForward_slashNeighborhood.
  ///
  /// In en, this message translates to:
  /// **'Locality / Neighborhood'**
  String get localityForward_slashNeighborhood;

  /// No description provided for @mathematics.
  ///
  /// In en, this message translates to:
  /// **'Mathematics'**
  String get mathematics;

  /// No description provided for @medicine.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get medicine;

  /// No description provided for @myActiveBooks.
  ///
  /// In en, this message translates to:
  /// **'My Active Books'**
  String get myActiveBooks;

  /// No description provided for @new_.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get new_;

  /// No description provided for @noBooksFound.
  ///
  /// In en, this message translates to:
  /// **'No Books Found'**
  String get noBooksFound;

  /// No description provided for @noDescriptionProvidedPeriod.
  ///
  /// In en, this message translates to:
  /// **'No description provided.'**
  String get noDescriptionProvidedPeriod;

  /// No description provided for @noListingFound.
  ///
  /// In en, this message translates to:
  /// **'No listing found'**
  String get noListingFound;

  /// No description provided for @noListingsYet.
  ///
  /// In en, this message translates to:
  /// **'No listings yet'**
  String get noListingsYet;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No Notifications Yet'**
  String get noNotificationsYet;

  /// No description provided for @noUserIsCurrentlyAuthenticated.
  ///
  /// In en, this message translates to:
  /// **'No user is currently authenticated'**
  String get noUserIsCurrentlyAuthenticated;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @oopsExclamation_markSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Oops! Something Went Wrong'**
  String get oopsExclamation_markSomethingWentWrong;

  /// No description provided for @organicChemistryVolPeriod2.
  ///
  /// In en, this message translates to:
  /// **'Organic Chemistry Vol. 2'**
  String get organicChemistryVolPeriod2;

  /// No description provided for @permitStudentsToSellThisBookBackWhenFinishedPeriod.
  ///
  /// In en, this message translates to:
  /// **'Permit students to sell this book back when finished.'**
  String get permitStudentsToSellThisBookBackWhenFinishedPeriod;

  /// No description provided for @pleaseCheckYourConnectionPeriod.
  ///
  /// In en, this message translates to:
  /// **'Please check your connection.'**
  String get pleaseCheckYourConnectionPeriod;

  /// No description provided for @pleaseEnterAPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter a price'**
  String get pleaseEnterAPrice;

  /// No description provided for @pleaseEnterATitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get pleaseEnterATitle;

  /// No description provided for @pleaseEnterAValidPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid price'**
  String get pleaseEnterAValidPrice;

  /// No description provided for @pleaseEnterAnAuthor.
  ///
  /// In en, this message translates to:
  /// **'Please enter an author'**
  String get pleaseEnterAnAuthor;

  /// No description provided for @pleaseEnterYourFullName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get pleaseEnterYourFullName;

  /// No description provided for @polytechnique.
  ///
  /// In en, this message translates to:
  /// **'Polytechnique'**
  String get polytechnique;

  /// No description provided for @poor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get poor;

  /// No description provided for @postListing.
  ///
  /// In en, this message translates to:
  /// **'Post Listing'**
  String get postListing;

  /// No description provided for @priceOpen_parenthesisFcfaClose_parenthesis.
  ///
  /// In en, this message translates to:
  /// **'Price (FCFA)'**
  String get priceOpen_parenthesisFcfaClose_parenthesis;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profileCreationTimedOut.
  ///
  /// In en, this message translates to:
  /// **'Profile creation timed out'**
  String get profileCreationTimedOut;

  /// No description provided for @profileUpdatedSuccessfullyExclamation_mark.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdatedSuccessfullyExclamation_mark;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'RATING'**
  String get rating;

  /// No description provided for @recentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get recentSearches;

  /// No description provided for @recentlyAdded.
  ///
  /// In en, this message translates to:
  /// **'Recently Added'**
  String get recentlyAdded;

  /// No description provided for @resultOpen_parenthesisSClose_parenthesisFound.
  ///
  /// In en, this message translates to:
  /// **' result(s) found'**
  String get resultOpen_parenthesisSClose_parenthesisFound;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'SAVED'**
  String get saved;

  /// No description provided for @science.
  ///
  /// In en, this message translates to:
  /// **'Science'**
  String get science;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchByTitleOrAuthorPeriodPeriodPeriod.
  ///
  /// In en, this message translates to:
  /// **'Search by title or author...'**
  String get searchByTitleOrAuthorPeriodPeriodPeriod;

  /// No description provided for @searchTitleCommaAuthorCommaOrIsbnPeriodPeriodPeriod.
  ///
  /// In en, this message translates to:
  /// **'Search title, author, or ISBN...'**
  String get searchTitleCommaAuthorCommaOrIsbnPeriodPeriodPeriod;

  /// No description provided for @selectACategory.
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get selectACategory;

  /// No description provided for @selectImageSource.
  ///
  /// In en, this message translates to:
  /// **'Select Image Source'**
  String get selectImageSource;

  /// No description provided for @sell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get sell;

  /// No description provided for @sellABook.
  ///
  /// In en, this message translates to:
  /// **'Sell a Book'**
  String get sellABook;

  /// No description provided for @sellNew.
  ///
  /// In en, this message translates to:
  /// **'Sell New'**
  String get sellNew;

  /// No description provided for @sellThisBookBackToThePlatformWhenYouBackslashApostropheReDonePeriod.
  ///
  /// In en, this message translates to:
  /// **'Sell this book back to the platform when you\\\'re done.'**
  String
  get sellThisBookBackToThePlatformWhenYouBackslashApostropheReDonePeriod;

  /// No description provided for @sellerInformation.
  ///
  /// In en, this message translates to:
  /// **'SELLER INFORMATION'**
  String get sellerInformation;

  /// No description provided for @sellerType.
  ///
  /// In en, this message translates to:
  /// **'Seller Type'**
  String get sellerType;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @socialVentureFeatures.
  ///
  /// In en, this message translates to:
  /// **'Social Venture Features'**
  String get socialVentureFeatures;

  /// No description provided for @sold.
  ///
  /// In en, this message translates to:
  /// **'SOLD'**
  String get sold;

  /// No description provided for @supportingLocalAuthorsFostersAVibrantCultureOfLearningPeriod.
  ///
  /// In en, this message translates to:
  /// **'Supporting local authors fosters a vibrant culture of learning.'**
  String get supportingLocalAuthorsFostersAVibrantCultureOfLearningPeriod;

  /// No description provided for @supportingLocalBusinessesDemocratizesAccessToKnowledgePeriod.
  ///
  /// In en, this message translates to:
  /// **'Supporting local businesses democratizes access to knowledge.'**
  String get supportingLocalBusinessesDemocratizesAccessToKnowledgePeriod;

  /// No description provided for @textbooks.
  ///
  /// In en, this message translates to:
  /// **'Textbooks'**
  String get textbooks;

  /// No description provided for @thisListingIsNoLongerAvailablePeriod.
  ///
  /// In en, this message translates to:
  /// **'This listing is no longer available.'**
  String get thisListingIsNoLongerAvailablePeriod;

  /// No description provided for @thisStudentIsSellingToFundTheirNextSemesterPeriod.
  ///
  /// In en, this message translates to:
  /// **'This student is selling to fund their next semester.'**
  String get thisStudentIsSellingToFundTheirNextSemesterPeriod;

  /// No description provided for @tooManyAttemptsPeriodPleaseCheckYourEmailInboxOrWaitAMinuteBeforeTryingAgainPeriod.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please check your email inbox or wait a minute before trying again.'**
  String
  get tooManyAttemptsPeriodPleaseCheckYourEmailInboxOrWaitAMinuteBeforeTryingAgainPeriod;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @universityOfBueaStudent.
  ///
  /// In en, this message translates to:
  /// **'University of Buea Student'**
  String get universityOfBueaStudent;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// No description provided for @unknownLocation.
  ///
  /// In en, this message translates to:
  /// **'Unknown Location'**
  String get unknownLocation;

  /// No description provided for @unknownSeller.
  ///
  /// In en, this message translates to:
  /// **'Unknown Seller'**
  String get unknownSeller;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get userNotFound;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'VERIFIED'**
  String get verified;

  /// No description provided for @verifiedBookshop.
  ///
  /// In en, this message translates to:
  /// **'Verified Bookshop'**
  String get verifiedBookshop;

  /// No description provided for @whatsappNumber.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp Number'**
  String get whatsappNumber;

  /// No description provided for @youBackslashApostropheLlSeeAlertsAboutYourListingsCommaMessagesCommaAndActivityHerePeriod.
  ///
  /// In en, this message translates to:
  /// **'You\\\'ll see alerts about your listings, messages, and activity here.'**
  String
  get youBackslashApostropheLlSeeAlertsAboutYourListingsCommaMessagesCommaAndActivityHerePeriod;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
