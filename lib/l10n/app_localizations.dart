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

  /// No description provided for @aVerifiedLocalBookshopSupportingTheCommunity_period_.
  ///
  /// In en, this message translates to:
  /// **'A verified local bookshop supporting the community.'**
  String get aVerifiedLocalBookshopSupportingTheCommunity_period_;

  /// No description provided for @aboutBookbridge.
  ///
  /// In en, this message translates to:
  /// **'About BookBridge'**
  String get aboutBookbridge;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @academicCategories.
  ///
  /// In en, this message translates to:
  /// **'Academic Categories'**
  String get academicCategories;

  /// No description provided for @activeBooks.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE BOOKS'**
  String get activeBooks;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @alreadyHaveAnAccountQuestion_mark.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAnAccountQuestion_mark;

  /// No description provided for @anErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get anErrorOccurred;

  /// No description provided for @anUnknownErrorOccurredPeriod.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred.'**
  String get anUnknownErrorOccurredPeriod;

  /// No description provided for @areYouSureYouWantToDeleteApostropheOpen_braceListingtitleClose_braceApostropheQuestion_markThisActionCannotBeUndonePeriod.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \'{listingTitle}\'? This action cannot be undone.'**
  String
  areYouSureYouWantToDeleteApostropheOpen_braceListingtitleClose_braceApostropheQuestion_markThisActionCannotBeUndonePeriod(
    String listingTitle,
  );

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

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

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

  /// No description provided for @bookbridgeColonForAll.
  ///
  /// In en, this message translates to:
  /// **'BookBridge: for All'**
  String get bookbridgeColonForAll;

  /// No description provided for @bookbridgeIsAPeerHyphenToHyphenPeerMarketplaceDesignedForStudentsInCameroonPeriodOurMissionIsToMakeEducationalResourcesAccessibleAndAffordableByConnectingStudentsWhoWantToSellTheirUsedBooksWithThoseWhoNeedThemPeriod.
  ///
  /// In en, this message translates to:
  /// **'BookBridge is a peer-to-peer marketplace designed for students in Cameroon. Our mission is to make educational resources accessible and affordable by connecting students who want to sell their used books with those who need them.'**
  String
  get bookbridgeIsAPeerHyphenToHyphenPeerMarketplaceDesignedForStudentsInCameroonPeriodOurMissionIsToMakeEducationalResourcesAccessibleAndAffordableByConnectingStudentsWhoWantToSellTheirUsedBooksWithThoseWhoNeedThemPeriod;

  /// No description provided for @buy_hyphen_BackEligible.
  ///
  /// In en, this message translates to:
  /// **'Buy-Back Eligible'**
  String get buy_hyphen_BackEligible;

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

  /// No description provided for @cameroon.
  ///
  /// In en, this message translates to:
  /// **'Cameroon'**
  String get cameroon;

  /// No description provided for @cameroonChar_2022Fcfa.
  ///
  /// In en, this message translates to:
  /// **'CAMEROON • FCFA'**
  String get cameroonChar_2022Fcfa;

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

  /// No description provided for @char_a9Open_braceYearClose_braceDctHyphenBerinyuyPeriodAllRightsReservedPeriod.
  ///
  /// In en, this message translates to:
  /// **'© {year} DCT-Berinyuy. All rights reserved.'**
  String
  char_a9Open_braceYearClose_braceDctHyphenBerinyuyPeriodAllRightsReservedPeriod(
    String year,
  );

  /// No description provided for @checkOutThisBookOnBookbridgeColonChar_1f4daOpen_braceTitleClose_braceByOpen_braceAuthorClose_braceCommaAtChar_1f4b0Open_bracePriceClose_braceFcfaPeriodChar_1f50dConditionColonOpen_braceConditionClose_bracePeriodDownloadBookbridgeToViewMoreDetailsExclamation_mark.
  ///
  /// In en, this message translates to:
  /// **'Check out this book on BookBridge: 📚 {title} by {author}, at 💰 {price} FCFA. 🔍 Condition: {condition}. Download BookBridge to view more details!'**
  String
  checkOutThisBookOnBookbridgeColonChar_1f4daOpen_braceTitleClose_braceByOpen_braceAuthorClose_braceCommaAtChar_1f4b0Open_bracePriceClose_braceFcfaPeriodChar_1f50dConditionColonOpen_braceConditionClose_bracePeriodDownloadBookbridgeToViewMoreDetailsExclamation_mark(
    String author,
    String condition,
    String price,
    String title,
  );

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @completeSetup.
  ///
  /// In en, this message translates to:
  /// **'Complete Setup'**
  String get completeSetup;

  /// No description provided for @completeYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete Your Profile'**
  String get completeYourProfile;

  /// No description provided for @connectWithTheAuthor.
  ///
  /// In en, this message translates to:
  /// **'Connect with the Author'**
  String get connectWithTheAuthor;

  /// No description provided for @connectingStudentsCommaAuthorsCommaAndBookshopsToEndLearningPovertyPeriod.
  ///
  /// In en, this message translates to:
  /// **'Connecting students, authors, and bookshops to end learning poverty.'**
  String
  get connectingStudentsCommaAuthorsCommaAndBookshopsToEndLearningPovertyPeriod;

  /// No description provided for @contactSellerViaWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Contact Seller via WhatsApp'**
  String get contactSellerViaWhatsapp;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @couldNotLaunchDialer.
  ///
  /// In en, this message translates to:
  /// **'Could not launch dialer'**
  String get couldNotLaunchDialer;

  /// No description provided for @couldNotLaunchOpen_braceUrlClose_brace.
  ///
  /// In en, this message translates to:
  /// **'Could not launch {url}'**
  String couldNotLaunchOpen_braceUrlClose_brace(String url);

  /// No description provided for @couldNotLaunchWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Could not launch WhatsApp'**
  String get couldNotLaunchWhatsapp;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @createYourFirstListingToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Create your first listing to get started'**
  String get createYourFirstListingToGetStarted;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteListing.
  ///
  /// In en, this message translates to:
  /// **'Delete Listing'**
  String get deleteListing;

  /// No description provided for @deleteListingQuestion_mark.
  ///
  /// In en, this message translates to:
  /// **'Delete Listing?'**
  String get deleteListingQuestion_mark;

  /// No description provided for @democratizingAccessToAffordableBooksInCameroonPeriod.
  ///
  /// In en, this message translates to:
  /// **'Democratizing access to affordable books in Cameroon.'**
  String get democratizingAccessToAffordableBooksInCameroonPeriod;

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

  /// No description provided for @directFromTheAuthor_period_SupportingLocalCreativity_period_.
  ///
  /// In en, this message translates to:
  /// **'Direct from the author. Supporting local creativity.'**
  String get directFromTheAuthor_period_SupportingLocalCreativity_period_;

  /// No description provided for @donApostropheTHaveAnAccountQuestion_mark.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get donApostropheTHaveAnAccountQuestion_mark;

  /// No description provided for @ePeriodGPeriodPurePhysics.
  ///
  /// In en, this message translates to:
  /// **'e.g. Pure Physics'**
  String get ePeriodGPeriodPurePhysics;

  /// No description provided for @editListing.
  ///
  /// In en, this message translates to:
  /// **'Edit Listing'**
  String get editListing;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @eligibleForBuyHyphenBack.
  ///
  /// In en, this message translates to:
  /// **'Eligible for Buy-Back'**
  String get eligibleForBuyHyphenBack;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @emailIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailIsRequired;

  /// No description provided for @engineering.
  ///
  /// In en, this message translates to:
  /// **'Engineering'**
  String get engineering;

  /// No description provided for @enterAValid9HyphenDigitNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 9-digit number'**
  String get enterAValid9HyphenDigitNumber;

  /// No description provided for @enterAValidEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get enterAValidEmailAddress;

  /// No description provided for @enterYourEmailAddressToReceiveAPasswordResetLinkPeriod.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address to receive a password reset link.'**
  String get enterYourEmailAddressToReceiveAPasswordResetLinkPeriod;

  /// No description provided for @errorColonOpen_braceErrorClose_brace.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorColonOpen_braceErrorClose_brace(String error);

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

  /// No description provided for @failedToUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get failedToUpdateProfile;

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

  /// No description provided for @featureComingSoon_exclamation_mark_.
  ///
  /// In en, this message translates to:
  /// **'Feature coming soon!'**
  String get featureComingSoon_exclamation_mark_;

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

  /// No description provided for @forgotPasswordQuestion_mark.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPasswordQuestion_mark;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @fullNameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameIsRequired;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @helloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello world'**
  String get helloWorld;

  /// No description provided for @hiCommaISawYourBookOnBookbridgeAndIAmInterestedExclamation_mark.
  ///
  /// In en, this message translates to:
  /// **'Hi, I saw your book on BookBridge and I am interested!'**
  String get hiCommaISawYourBookOnBookbridgeAndIAmInterestedExclamation_mark;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @individualStudent.
  ///
  /// In en, this message translates to:
  /// **'Individual Student'**
  String get individualStudent;

  /// No description provided for @justOneMoreStepExclamation_mark.
  ///
  /// In en, this message translates to:
  /// **'Just one more step!'**
  String get justOneMoreStepExclamation_mark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @less_thanNoCategoryGreater_than.
  ///
  /// In en, this message translates to:
  /// **'<no category>'**
  String get less_thanNoCategoryGreater_than;

  /// No description provided for @likeNew.
  ///
  /// In en, this message translates to:
  /// **'Like New'**
  String get likeNew;

  /// No description provided for @listedOpen_braceDateClose_braceDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'Listed {numdays, plural, =0{today} =1{yesterday} other{{numdays} days ago}}'**
  String listedOpen_braceDateClose_braceDaysAgo(num numdays, Object date);

  /// No description provided for @listingCreatedSuccessfullyExclamation_mark.
  ///
  /// In en, this message translates to:
  /// **'Listing created successfully!'**
  String get listingCreatedSuccessfullyExclamation_mark;

  /// No description provided for @listingUpdatedSuccessfullyExclamation_mark.
  ///
  /// In en, this message translates to:
  /// **'Listing updated successfully!'**
  String get listingUpdatedSuccessfullyExclamation_mark;

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

  /// No description provided for @localityIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Locality is required'**
  String get localityIsRequired;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

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

  /// No description provided for @memberSinceOpen_braceDataClose_brace.
  ///
  /// In en, this message translates to:
  /// **'Member since {data}'**
  String memberSinceOpen_braceDataClose_brace(String data);

  /// No description provided for @minPeriod6Characters.
  ///
  /// In en, this message translates to:
  /// **'Min. 6 characters'**
  String get minPeriod6Characters;

  /// No description provided for @myActiveBooks.
  ///
  /// In en, this message translates to:
  /// **'My Active Books'**
  String get myActiveBooks;

  /// No description provided for @noBooksFound.
  ///
  /// In en, this message translates to:
  /// **'No Books Found'**
  String get noBooksFound;

  /// No description provided for @noBooksInOpen_braceCategoryClose_brace.
  ///
  /// In en, this message translates to:
  /// **'No Books in {category}'**
  String noBooksInOpen_braceCategoryClose_brace(String category);

  /// No description provided for @noCategoriesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No categories available'**
  String get noCategoriesAvailable;

  /// No description provided for @noDescriptionProvided_period_.
  ///
  /// In en, this message translates to:
  /// **'No description provided.'**
  String get noDescriptionProvided_period_;

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

  /// No description provided for @noPhoneNumberAvailable.
  ///
  /// In en, this message translates to:
  /// **'No phone number available'**
  String get noPhoneNumberAvailable;

  /// No description provided for @noResultsFoundForApostropheOpen_braceSearchtextClose_braceApostrophe.
  ///
  /// In en, this message translates to:
  /// **'No results found for \'{searchtext}\''**
  String noResultsFoundForApostropheOpen_braceSearchtextClose_braceApostrophe(
    String searchtext,
  );

  /// No description provided for @noWhatsappNumberAvailable.
  ///
  /// In en, this message translates to:
  /// **'No WhatsApp number available'**
  String get noWhatsappNumberAvailable;

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

  /// No description provided for @numberIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Number is required'**
  String get numberIsRequired;

  /// No description provided for @officialWebsite.
  ///
  /// In en, this message translates to:
  /// **'Official Website'**
  String get officialWebsite;

  /// No description provided for @oopsExclamation_markSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Oops! Something Went Wrong'**
  String get oopsExclamation_markSomethingWentWrong;

  /// No description provided for @open_braceCountClose_braceResultOpen_parenthesisSClose_parenthesisFound.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{no result} =1{1 result} other{{count} results}}'**
  String
  open_braceCountClose_braceResultOpen_parenthesisSClose_parenthesisFound(
    num count,
  );

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordIsRequired;

  /// No description provided for @passwordMustBeAtLeast6Characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMustBeAtLeast6Characters;

  /// No description provided for @passwordResetLinkSentExclamation_mark.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent!'**
  String get passwordResetLinkSentExclamation_mark;

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

  /// No description provided for @pricesAreListedInFcfa.
  ///
  /// In en, this message translates to:
  /// **'PRICES ARE LISTED IN FCFA'**
  String get pricesAreListedInFcfa;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profileUpdatedSuccessfullyExclamation_mark.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdatedSuccessfullyExclamation_mark;

  /// No description provided for @projectSourceCode.
  ///
  /// In en, this message translates to:
  /// **'Project Source Code'**
  String get projectSourceCode;

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

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @schoolForward_slashPersonalEmail.
  ///
  /// In en, this message translates to:
  /// **'School/Personal Email'**
  String get schoolForward_slashPersonalEmail;

  /// No description provided for @science.
  ///
  /// In en, this message translates to:
  /// **'Science'**
  String get science;

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

  /// No description provided for @sellThisBookBackToThePlatformWhenYou_apostrophe_ReDone_period_.
  ///
  /// In en, this message translates to:
  /// **'Sell this book back to the platform when you\'re done.'**
  String get sellThisBookBackToThePlatformWhenYou_apostrophe_ReDone_period_;

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

  /// No description provided for @sendLink.
  ///
  /// In en, this message translates to:
  /// **'Send Link'**
  String get sendLink;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signUpSuccessfulExclamation_markWelcomePeriod.
  ///
  /// In en, this message translates to:
  /// **'Sign up successful! Welcome.'**
  String get signUpSuccessfulExclamation_markWelcomePeriod;

  /// No description provided for @socialVentureFeatures.
  ///
  /// In en, this message translates to:
  /// **'Social Venture Features'**
  String get socialVentureFeatures;

  /// No description provided for @supportingLocalAuthorsFostersAVibrantCultureOfLearning_period_.
  ///
  /// In en, this message translates to:
  /// **'Supporting local authors fosters a vibrant culture of learning.'**
  String get supportingLocalAuthorsFostersAVibrantCultureOfLearning_period_;

  /// No description provided for @supportingLocalBusinessesDemocratizesAccessToKnowledge_period_.
  ///
  /// In en, this message translates to:
  /// **'Supporting local businesses democratizes access to knowledge.'**
  String get supportingLocalBusinessesDemocratizesAccessToKnowledge_period_;

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

  /// No description provided for @thisStudentIsSellingToFundTheirNextSemester_period_.
  ///
  /// In en, this message translates to:
  /// **'This student is selling to fund their next semester.'**
  String get thisStudentIsSellingToFundTheirNextSemester_period_;

  /// No description provided for @toStartBuyingAndSellingCommaWeNeedAFewMoreDetailsToHelpOtherStudentsFindYouPeriod.
  ///
  /// In en, this message translates to:
  /// **'To start buying and selling, we need a few more details to help other students find you.'**
  String
  get toStartBuyingAndSellingCommaWeNeedAFewMoreDetailsToHelpOtherStudentsFindYouPeriod;

  /// No description provided for @totalValue.
  ///
  /// In en, this message translates to:
  /// **'TOTAL VALUE'**
  String get totalValue;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @tryAnotherCategoryOrClearTheFilterPeriod.
  ///
  /// In en, this message translates to:
  /// **'Try another category or clear the filter.'**
  String get tryAnotherCategoryOrClearTheFilterPeriod;

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

  /// No description provided for @updateListing.
  ///
  /// In en, this message translates to:
  /// **'Update Listing'**
  String get updateListing;

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

  /// No description provided for @versionOpen_braceVersionClose_brace.
  ///
  /// In en, this message translates to:
  /// **'Version  {version}'**
  String versionOpen_braceVersionClose_brace(String version);

  /// No description provided for @viewOnGithub.
  ///
  /// In en, this message translates to:
  /// **'View on GitHub'**
  String get viewOnGithub;

  /// No description provided for @visitOurWebPlatform.
  ///
  /// In en, this message translates to:
  /// **'Visit our web platform'**
  String get visitOurWebPlatform;

  /// No description provided for @whatsappNumber.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp Number'**
  String get whatsappNumber;

  /// No description provided for @whatsappNumberIsRequired.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp number is required'**
  String get whatsappNumberIsRequired;

  /// No description provided for @you_apostrophe_LlSeeAlertsAboutYourListings_comma_Messages_comma_AndActivityHere_period_.
  ///
  /// In en, this message translates to:
  /// **'You\'ll see alerts about your listings, messages, and activity here.'**
  String
  get you_apostrophe_LlSeeAlertsAboutYourListings_comma_Messages_comma_AndActivityHere_period_;
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
