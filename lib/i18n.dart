import 'package:flutter/material.dart';
import 'package:sparring_owner/I18n/messages_all.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class I18n {
  I18n(this.localeName);

  static Future<I18n> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      return I18n(localeName);
    });
  }

  static I18n of(BuildContext context) {
    return Localizations.of<I18n>(context, I18n);
  }

  final String localeName;

  String get hello {
    return Intl.message(
      'Hello, World',
      name: 'hello',
      desc: 'Hello world text',
      locale: localeName,
    );
  }

  String get title {
    return Intl.message(
      'Sparring Owner',
      name: 'title',
      desc: 'Title application',
      locale: localeName,
    );
  }

  String get bookingDetail {
    return Intl.message(
      'Booking details',
      name: 'bookingDetail',
      desc: 'booking details text',
      locale: localeName,
    );
  }

  String get bookingInfo {
    return Intl.message(
      'Booking info',
      name: 'bookingInfo',
      desc: 'booking info text',
      locale: localeName,
    );
  }

  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: 'name text',
      locale: localeName,
    );
  }

  String get phoneNumber {
    return Intl.message(
      'Phone number',
      name: 'phoneNumber',
      desc: 'phone number text',
      locale: localeName,
    );
  }

  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: 'address text',
      locale: localeName,
    );
  }

  String get paymentDetails {
    return Intl.message(
      'Payment details',
      name: 'paymentDetails',
      desc: 'payment details text',
      locale: localeName,
    );
  }

  String get paymentMethod {
    return Intl.message(
      'Payment method',
      name: 'paymentMethod',
      desc: 'payment method text',
      locale: localeName,
    );
  }

  String get totalPrice {
    return Intl.message(
      'Total price',
      name: 'totalPrice',
      desc: 'total price text',
      locale: localeName,
    );
  }

  String get upcomingText {
    return Intl.message(
      'Upcoming',
      name: 'upcomingText',
      desc: 'upcoming text on tab bar',
      locale: localeName,
    );
  }

  String get completedText {
    return Intl.message(
      'Completed',
      name: 'completedText',
      desc: 'competed text on tab bar',
      locale: localeName,
    );
  }

  String get cancelledText {
    return Intl.message(
      'Cancelled',
      name: 'cancelledText',
      desc: 'cancelled text on tab bar',
      locale: localeName,
    );
  }

  String get bookings {
    return Intl.message(
      'Bookings',
      name: 'bookings',
      desc: 'bookings text',
      locale: localeName,
    );
  }

  String get noBookingsText {
    return Intl.message(
      'No bookings',
      name: 'noBookingsText',
      desc: 'no booking text',
      locale: localeName,
    );
  }

  String get noCancelledBookingsText {
    return Intl.message(
      'No cancelled bookings available yet',
      name: 'noCancelledBookingsText',
      desc: 'no cancelled bookings text',
      locale: localeName,
    );
  }

  String get noCompletedBookingsText {
    return Intl.message(
      'No completed bookings available yet',
      name: 'noCompletedBookingsText',
      desc: 'no completed bookings text',
      locale: localeName,
    );
  }

  String get noUpcomingBookingsText {
    return Intl.message(
      'No upcoming bookings available yet',
      name: 'noUpcomingBookingsText',
      desc: 'no upcoming bookings text',
      locale: localeName,
    );
  }

  String get verifyYourAccount {
    return Intl.message(
      'Verify your account',
      name: 'verifyYourAccount',
      desc: 'verifyYourAccount text',
      locale: localeName,
    );
  }

  String get prepareIDCard {
    return Intl.message(
      'Prepare your ID Card (KTP)',
      name: 'prepareIDCard',
      desc: 'prepareIDCard text',
      locale: localeName,
    );
  }

  String get prepareIDCardDesc {
    return Intl.message(
      'We need to verify your identitiy using your ID Card. Please make sure the ID Card is yours.',
      name: 'prepareIDCardDesc',
      desc: 'prepareIDCardDesc text',
      locale: localeName,
    );
  }

  String get iamReady {
    return Intl.message(
      'I am ready, let\'s do it!',
      name: 'iamReady',
      desc: 'iamReady text',
      locale: localeName,
    );
  }

  String get step {
    return Intl.message(
      'Step',
      name: 'step',
      desc: 'step text',
      locale: localeName,
    );
  }

  String get yourIDCard {
    return Intl.message(
      'Your ID Card',
      name: 'yourIDCard',
      desc: 'yourIDCard text',
      locale: localeName,
    );
  }

  String get saveAndContinue {
    return Intl.message(
      'Save and continue',
      name: 'saveAndContinue',
      desc: 'saveAndContinue text',
      locale: localeName,
    );
  }

  String get yourPhoto {
    return Intl.message(
      'Your photo',
      name: 'yourPhoto',
      desc: 'Your photo text',
      locale: localeName,
    );
  }

  String get resutlSelfieWithID {
    return Intl.message(
      'Result your selfie with ID',
      name: 'resutlSelfieWithID',
      desc: 'resutlSelfieWithID text',
      locale: localeName,
    );
  }

  String get finish {
    return Intl.message(
      'Finish',
      name: 'finish',
      desc: 'finish text',
      locale: localeName,
    );
  }

  String get congratulation {
    return Intl.message(
      'Congratulations!',
      name: 'congratulation',
      desc: 'congratulation text',
      locale: localeName,
    );
  }

  String get nowRegistered {
    return Intl.message(
      'Now you are registered',
      name: 'nowRegistered',
      desc: 'nowRegistered text',
      locale: localeName,
    );
  }

  String get pleaseWait {
    return Intl.message(
      "Please wait our admin to verify your information. It'\s takes 1-3 work days.",
      name: 'pleaseWait',
      desc: 'pleaseWait text',
      locale: localeName,
    );
  }

  String get okGotIt {
    return Intl.message(
      'Ok, I got it',
      name: 'okGotIt',
      desc: 'okGotIt text',
      locale: localeName,
    );
  }

  String get finishing {
    return Intl.message(
      'Finishing...',
      name: 'finishing',
      desc: 'finishing text',
      locale: localeName,
    );
  }

  String get takeIdCard {
    return Intl.message(
      'Take a picture of your ID card',
      name: 'takeIdCard',
      desc: 'takeIdCard text',
      locale: localeName,
    );
  }

  String get takeSelfie {
    return Intl.message(
      'Take a picture of your self (selfie)',
      name: 'takeSelfie',
      desc: 'takeSelfie text',
      locale: localeName,
    );
  }

  String get loading {
    return Intl.message(
      'Loading',
      name: 'loading',
      desc: 'loading text',
      locale: localeName,
    );
  }

  String get selfieWIthID {
    return Intl.message(
      'Selfie with ID Card',
      name: 'selfieWIthID',
      desc: 'selfieWIthID text',
      locale: localeName,
    );
  }

  String get totalIncome {
    return Intl.message(
      'Total income',
      name: 'totalIncome',
      desc: 'totalIncome text',
      locale: localeName,
    );
  }

  String get court {
    return Intl.message(
      'Court',
      name: 'court',
      desc: 'court text',
      locale: localeName,
    );
  }

  String get yourCourt {
    return Intl.message(
      'Your court',
      name: 'yourCourt',
      desc: 'yourCourt text',
      locale: localeName,
    );
  }

  String get more {
    return Intl.message(
      'More',
      name: 'more',
      desc: 'more text',
      locale: localeName,
    );
  }

  String get dontHaveCourtText {
    return Intl.message(
      'You don\'t have any court yet!',
      name: 'dontHaveCourtText',
      desc: 'dontHaveCourt text',
      locale: localeName,
    );
  }

  String get pleaseAddCourt {
    return Intl.message(
      'Please add to see your court here',
      name: 'pleaseAddCourt',
      desc: 'pleaseAddCourt text',
      locale: localeName,
    );
  }

  String get verifiedTitle {
    return Intl.message(
      'Horray your account is verified!',
      name: 'verifiedTitle',
      desc: 'verifiedTitle text',
      locale: localeName,
    );
  }

  String get verifiedSubtitle {
    return Intl.message(
      'Now you can using full feature of our app. Take a adventure of it!',
      name: 'verifiedSubtitle',
      desc: 'verifiedSubtitle text',
      locale: localeName,
    );
  }

  String get processTitle {
    return Intl.message(
      'Yeeyy your account under review!',
      name: 'processTitle',
      desc: 'processTitle text',
      locale: localeName,
    );
  }

  String get processSubtitle {
    return Intl.message(
      "Please wait our team to verify your information. It'\s takes 1-3 work days.",
      name: 'processSubtitle',
      desc: 'processSubtitle text',
      locale: localeName,
    );
  }

  String get notTitle {
    return Intl.message(
      'Oh no! Your account not verified yet!',
      name: 'notTitle',
      desc: 'notTitle text',
      locale: localeName,
    );
  }

  String get notSubtitle {
    return Intl.message(
      'Verify now to freely access our feature!',
      name: 'notSubtitle',
      desc: 'notSubtitle text',
      locale: localeName,
    );
  }

  String get verifyNow {
    return Intl.message(
      'Verify now!',
      name: 'verifyNow',
      desc: 'verifyNow text',
      locale: localeName,
    );
  }

  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: 'back text',
      locale: localeName,
    );
  }

  String get loginSuccessText {
    return Intl.message(
      'Login successfully!',
      name: 'loginSuccessText',
      desc: 'login success text',
      locale: localeName,
    );
  }

  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: 'login text',
      locale: localeName,
    );
  }

  String get orText {
    return Intl.message(
      'or',
      name: 'orText',
      desc: 'or text',
      locale: localeName,
    );
  }

  String get questionAccountText {
    return Intl.message(
      'Don\'t have an account?',
      name: 'questionAccountText',
      desc: 'question account text',
      locale: localeName,
    );
  }

  String get registerText {
    return Intl.message(
      'Register now',
      name: 'registerText',
      desc: 'register text',
      locale: localeName,
    );
  }

  String get emailText {
    return Intl.message(
      'Email',
      name: 'emailText',
      desc: 'email label text',
      locale: localeName,
    );
  }

  String get passwordText {
    return Intl.message(
      'Password',
      name: 'passwordText',
      desc: 'password text text',
      locale: localeName,
    );
  }

  String get passwordEmptyWarningText {
    return Intl.message(
      'Password can\'t be empty!',
      name: 'passwordEmptyWarningText',
      desc: 'password empty warning text',
      locale: localeName,
    );
  }

  String get emailEmptyWarningText {
    return Intl.message(
      'Email can\'t be empty!',
      name: 'emailEmptyWarningText',
      desc: 'email empty warning text',
      locale: localeName,
    );
  }

  String get registerSuccessText {
    return Intl.message(
      'Register successfully!',
      name: 'registerSuccessText',
      desc: 'register success text',
      locale: localeName,
    );
  }

  String get descRegisterSuccessText {
    return Intl.message(
      'Please login to access your account',
      name: 'descRegisterSuccessText',
      desc: 'desc register success text',
      locale: localeName,
    );
  }

  String get questionHaveAccountText {
    return Intl.message(
      'Already have an account?',
      name: 'questionHaveAccountText',
      desc: 'question have account text',
      locale: localeName,
    );
  }

  String get fullNameText {
    return Intl.message(
      'Full name',
      name: 'fullNameText',
      desc: 'full name text label',
      locale: localeName,
    );
  }

  String get fullNameEmptyWarningText {
    return Intl.message(
      'Full name can\'t be empty!',
      name: 'fullNameEmptyWarningText',
      desc: 'fullName empty warning text',
      locale: localeName,
    );
  }

  String get pickCourtImages {
    return Intl.message(
      'Pick court images',
      name: 'pickCourtImages',
      desc: 'pickCourtImages text',
      locale: localeName,
    );
  }

  String get allPhotos {
    return Intl.message(
      'All Photos',
      name: 'allPhotos',
      desc: 'allPhotos text',
      locale: localeName,
    );
  }

  String get addCourt {
    return Intl.message(
      'Add court',
      name: 'addCourt',
      desc: 'addCourt text',
      locale: localeName,
    );
  }

  String get phoneMustNumeric {
    return Intl.message(
      'Phone number must be a numeric!',
      name: 'phoneMustNumeric',
      desc: 'phoneMustNumeric text',
      locale: localeName,
    );
  }

  String get openDayText {
    return Intl.message(
      'Open day',
      name: 'openDayText',
      desc: 'open day text',
      locale: localeName,
    );
  }

  String get closedDayText {
    return Intl.message(
      'Closed day',
      name: 'closedDayText',
      desc: 'closed day text',
      locale: localeName,
    );
  }

  String get openHourText {
    return Intl.message(
      'Open hour',
      name: 'openHourText',
      desc: 'open hour text',
      locale: localeName,
    );
  }

  String get closedHourText {
    return Intl.message(
      'Closed hour',
      name: 'closedHourText',
      desc: 'closed hour text',
      locale: localeName,
    );
  }

  String get selectOpenDay {
    return Intl.message(
      'Select open day',
      name: 'selectOpenDay',
      desc: 'selectOpenDay text',
      locale: localeName,
    );
  }

  String get selectClosedDay {
    return Intl.message(
      'Select closed day',
      name: 'selectClosedDay',
      desc: 'selectClosedDay text',
      locale: localeName,
    );
  }

  String get selectOpenHour {
    return Intl.message(
      'Select open hour',
      name: 'selectOpenHour',
      desc: 'selectOpenHour text',
      locale: localeName,
    );
  }

  String get selectClosedHour {
    return Intl.message(
      'Select closed hour',
      name: 'selectClosedHour',
      desc: 'selectClosedHour text',
      locale: localeName,
    );
  }

  String get pricePerHour {
    return Intl.message(
      'Price per hour',
      name: 'pricePerHour',
      desc: 'pricePerHour text',
      locale: localeName,
    );
  }

  String get priceMustNumeric {
    return Intl.message(
      'Price must be a numeric!',
      name: 'priceMustNumeric',
      desc: 'priceMustNumeric text',
      locale: localeName,
    );
  }

  String get latitudeMustNumeric {
    return Intl.message(
      'Latitude must be a numeric!',
      name: 'latitudeMustNumeric',
      desc: 'latitudeMustNumeric text',
      locale: localeName,
    );
  }

  String get longitudeMustNumeric {
    return Intl.message(
      'Longitude must be a numeric!',
      name: 'longitudeMustNumeric',
      desc: 'longitudeMustNumeric text',
      locale: localeName,
    );
  }

  String get selectCourtFacility {
    return Intl.message(
      'Select court facility',
      name: 'selectCourtFacility',
      desc: 'selectCourtFacility text',
      locale: localeName,
    );
  }

  String get courtImages {
    return Intl.message(
      'Court images',
      name: 'courtImages',
      desc: 'courtImages text',
      locale: localeName,
    );
  }

  String get courtSaved {
    return Intl.message(
      'Court saved!',
      name: 'courtSaved',
      desc: 'courtSaved text',
      locale: localeName,
    );
  }

  String get saveText {
    return Intl.message(
      'Save',
      name: 'saveText',
      desc: 'save text',
      locale: localeName,
    );
  }

  String get savingCourt {
    return Intl.message(
      'Saving court..',
      name: 'savingCourt',
      desc: 'savingCourt text',
      locale: localeName,
    );
  }

  String get verfiyToAddCourt {
    return Intl.message(
      'Verify now to add court!',
      name: 'verfiyToAddCourt',
      desc: 'verfiyToAddCourt text',
      locale: localeName,
    );
  }

  String get addCourtToManage {
    return Intl.message(
      'Add your court to manage',
      name: 'addCourtToManage',
      desc: 'addCourtToManage text',
      locale: localeName,
    );
  }

  String get descAppText {
    return Intl.message(
      'application for find futsal court and opponents',
      name: 'descAppText',
      desc: 'desc app text',
      locale: localeName,
    );
  }

  String get withText {
    return Intl.message(
      'with',
      name: 'withText',
      desc: 'with text',
      locale: localeName,
    );
  }

  String get appVersionText {
    return Intl.message(
      'App Version',
      name: 'appVersionText',
      desc: 'app version text',
      locale: localeName,
    );
  }

  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: 'account text',
      locale: localeName,
    );
  }

  String get myInfoText {
    return Intl.message(
      'My Information',
      name: 'myInfoText',
      desc: 'my info text',
      locale: localeName,
    );
  }

  String get myCourt {
    return Intl.message(
      'My Court',
      name: 'myCourt',
      desc: 'myCourt text',
      locale: localeName,
    );
  }

  String get aboutUsText {
    return Intl.message(
      'About Us',
      name: 'aboutUsText',
      desc: 'about us text',
      locale: localeName,
    );
  }

  String get logoutSuccessText {
    return Intl.message(
      'Logout successfully!',
      name: 'logoutSuccessText',
      desc: 'logout success text',
      locale: localeName,
    );
  }

  String get logoutText {
    return Intl.message(
      'Logout',
      name: 'logoutText',
      desc: 'logout text',
      locale: localeName,
    );
  }

  String get profileText {
    return Intl.message(
      'Profile',
      name: 'profileText',
      desc: 'profile text',
      locale: localeName,
    );
  }

  String get phoneNumberEmptyWarningText {
    return Intl.message(
      'Phone number can\'t be empty!',
      name: 'phoneNumberEmptyWarningText',
      desc: 'phoneNumber empty warning text',
      locale: localeName,
    );
  }

  String get addressEmptyWarningText {
    return Intl.message(
      'Address can\'t be empty!',
      name: 'addressEmptyWarningText',
      desc: 'address empty warning text',
      locale: localeName,
    );
  }

  String get joinedText {
    return Intl.message(
      'Joined',
      name: 'joinedText',
      desc: 'joined text',
      locale: localeName,
    );
  }

  String get dataSavedText {
    return Intl.message(
      'Data saved!',
      name: 'dataSavedText',
      desc: 'data saved text',
      locale: localeName,
    );
  }

  String get savingChangesText {
    return Intl.message(
      'Saving changes..',
      name: 'savingChangesText',
      desc: 'saving changes text',
      locale: localeName,
    );
  }

  String get genderText {
    return Intl.message(
      'Gender',
      name: 'genderText',
      desc: 'gender text',
      locale: localeName,
    );
  }

  String get notification {
    return Intl.message(
      'Notification',
      name: 'notification',
      desc: 'notification text on bottom nav bar',
      locale: localeName,
    );
  }
}

class I18nDelegate extends LocalizationsDelegate<I18n> {
  const I18nDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'id'].contains(locale.languageCode);

  @override
  Future<I18n> load(Locale locale) => I18n.load(locale);

  @override
  bool shouldReload(I18nDelegate old) => false;
}
