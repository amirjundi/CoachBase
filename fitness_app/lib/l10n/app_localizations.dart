import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';

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
  static const List<Locale> supportedLocales = <Locale>[Locale('ar')];

  /// No description provided for @appTitle.
  ///
  /// In ar, this message translates to:
  /// **'CoachBase'**
  String get appTitle;

  /// No description provided for @welcomeBack.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بعودتك'**
  String get welcomeBack;

  /// No description provided for @signInToContinue.
  ///
  /// In ar, this message translates to:
  /// **'سجل الدخول للمتابعة'**
  String get signInToContinue;

  /// No description provided for @email.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get email;

  /// No description provided for @password.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get password;

  /// No description provided for @signIn.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get signIn;

  /// No description provided for @dontHaveAccount.
  ///
  /// In ar, this message translates to:
  /// **'ليس لديك حساب؟'**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب'**
  String get signUp;

  /// No description provided for @createAccount.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب جديد'**
  String get createAccount;

  /// No description provided for @startManaging.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ إدارة تدريبات اللياقة'**
  String get startManaging;

  /// No description provided for @fullName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get fullName;

  /// No description provided for @phone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get phone;

  /// No description provided for @confirmPassword.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد كلمة المرور'**
  String get confirmPassword;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In ar, this message translates to:
  /// **'لديك حساب بالفعل؟'**
  String get alreadyHaveAccount;

  /// No description provided for @dashboard.
  ///
  /// In ar, this message translates to:
  /// **'لوحة التحكم'**
  String get dashboard;

  /// No description provided for @players.
  ///
  /// In ar, this message translates to:
  /// **'اللاعبين'**
  String get players;

  /// No description provided for @workoutPlans.
  ///
  /// In ar, this message translates to:
  /// **'خطة التمارين'**
  String get workoutPlans;

  /// No description provided for @exercises.
  ///
  /// In ar, this message translates to:
  /// **'التمارين'**
  String get exercises;

  /// No description provided for @subscriptions.
  ///
  /// In ar, this message translates to:
  /// **'الاشتراكات'**
  String get subscriptions;

  /// No description provided for @settings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settings;

  /// No description provided for @helpSupport.
  ///
  /// In ar, this message translates to:
  /// **'المساعدة والدعم'**
  String get helpSupport;

  /// No description provided for @logout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logout;

  /// No description provided for @logoutConfirmation.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد أنك تريد تسجيل الخروج؟'**
  String get logoutConfirmation;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get delete;

  /// No description provided for @deleteConfirmation.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد أنك تريد حذف هذا؟'**
  String get deleteConfirmation;

  /// No description provided for @deleteConfirmationAlt.
  ///
  /// In ar, this message translates to:
  /// **'هل تريد بالتأكيد حذف هذا العنصر؟'**
  String get deleteConfirmationAlt;

  /// No description provided for @daysLeft.
  ///
  /// In ar, this message translates to:
  /// **'باقي {days} أيام'**
  String daysLeft(Object days);

  /// No description provided for @unknownPlayer.
  ///
  /// In ar, this message translates to:
  /// **'لاعب غير معروف'**
  String get unknownPlayer;

  /// No description provided for @unknownPlan.
  ///
  /// In ar, this message translates to:
  /// **'خطة غير معروفة'**
  String get unknownPlan;

  /// No description provided for @cancelled.
  ///
  /// In ar, this message translates to:
  /// **'ملغي'**
  String get cancelled;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @saveChanges.
  ///
  /// In ar, this message translates to:
  /// **'حفظ التغييرات'**
  String get saveChanges;

  /// No description provided for @add.
  ///
  /// In ar, this message translates to:
  /// **'نعم'**
  String get add;

  /// No description provided for @edit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get edit;

  /// No description provided for @remove.
  ///
  /// In ar, this message translates to:
  /// **'إزالة'**
  String get remove;

  /// No description provided for @search.
  ///
  /// In ar, this message translates to:
  /// **'بحث...'**
  String get search;

  /// No description provided for @noPlayers.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد لاعبين حتى الآن'**
  String get noPlayers;

  /// No description provided for @addFirstPlayer.
  ///
  /// In ar, this message translates to:
  /// **'أضف لاعبك الأول للبدء'**
  String get addFirstPlayer;

  /// No description provided for @addPlayer.
  ///
  /// In ar, this message translates to:
  /// **'إضافة لاعب'**
  String get addPlayer;

  /// No description provided for @playerDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل اللاعب'**
  String get playerDetails;

  /// No description provided for @editPlayer.
  ///
  /// In ar, this message translates to:
  /// **'تعديل بيانات اللاعب'**
  String get editPlayer;

  /// No description provided for @activeSubscription.
  ///
  /// In ar, this message translates to:
  /// **'الاشتراك النشط'**
  String get activeSubscription;

  /// No description provided for @subscriptionHistory.
  ///
  /// In ar, this message translates to:
  /// **'سجل الاشتراكات'**
  String get subscriptionHistory;

  /// No description provided for @noActiveSubscription.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد اشتراك نشط'**
  String get noActiveSubscription;

  /// No description provided for @expiringSoon.
  ///
  /// In ar, this message translates to:
  /// **'ينتهي قريباً'**
  String get expiringSoon;

  /// No description provided for @expired.
  ///
  /// In ar, this message translates to:
  /// **'منتهي'**
  String get expired;

  /// No description provided for @active.
  ///
  /// In ar, this message translates to:
  /// **'نشط'**
  String get active;

  /// No description provided for @assignPlan.
  ///
  /// In ar, this message translates to:
  /// **'تعيين خطة'**
  String get assignPlan;

  /// No description provided for @noPlans.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد خطط تمرين'**
  String get noPlans;

  /// No description provided for @createFirstPlan.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ خطة التمرين الأولى'**
  String get createFirstPlan;

  /// No description provided for @createPlan.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء خطة'**
  String get createPlan;

  /// No description provided for @newPlan.
  ///
  /// In ar, this message translates to:
  /// **'خطة جديدة'**
  String get newPlan;

  /// No description provided for @planDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الخطة'**
  String get planDetails;

  /// No description provided for @weeklySchedule.
  ///
  /// In ar, this message translates to:
  /// **'جدول التدريب'**
  String get weeklySchedule;

  /// No description provided for @workoutDays.
  ///
  /// In ar, this message translates to:
  /// **'أيام التمرين'**
  String get workoutDays;

  /// No description provided for @restDays.
  ///
  /// In ar, this message translates to:
  /// **'أيام الراحة'**
  String get restDays;

  /// No description provided for @noWorkoutDays.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم تحديد أيام تمرين'**
  String get noWorkoutDays;

  /// No description provided for @editPlan.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الخطة'**
  String get editPlan;

  /// No description provided for @difficultyLevel.
  ///
  /// In ar, this message translates to:
  /// **'مستوى الصعوبة'**
  String get difficultyLevel;

  /// No description provided for @description.
  ///
  /// In ar, this message translates to:
  /// **'الوصف'**
  String get description;

  /// No description provided for @focusArea.
  ///
  /// In ar, this message translates to:
  /// **'منطقة التركيز'**
  String get focusArea;

  /// No description provided for @selectWorkoutDays.
  ///
  /// In ar, this message translates to:
  /// **'تخطيط الأيام'**
  String get selectWorkoutDays;

  /// No description provided for @selectWorkoutDaysSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'قم بإضافة أيام تمرين أو راحة بالتسلسل'**
  String get selectWorkoutDaysSubtitle;

  /// No description provided for @selectFocusAreas.
  ///
  /// In ar, this message translates to:
  /// **'مناطق التركيز (اختياري)'**
  String get selectFocusAreas;

  /// No description provided for @setFocusArea.
  ///
  /// In ar, this message translates to:
  /// **'حدد تركيزاً لكل يوم تمرين'**
  String get setFocusArea;

  /// No description provided for @dayEditor.
  ///
  /// In ar, this message translates to:
  /// **'محرر اليوم'**
  String get dayEditor;

  /// No description provided for @addExercise.
  ///
  /// In ar, this message translates to:
  /// **'إضافة تمرين'**
  String get addExercise;

  /// No description provided for @noExercises.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد تمارين'**
  String get noExercises;

  /// No description provided for @buildLibrary.
  ///
  /// In ar, this message translates to:
  /// **'ابنِ مكتبة تمارينك باستخدام فيديوهات يوتيوب'**
  String get buildLibrary;

  /// No description provided for @exerciseDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل التمرين'**
  String get exerciseDetails;

  /// No description provided for @muscleGroup.
  ///
  /// In ar, this message translates to:
  /// **'العضلة المستهدفة'**
  String get muscleGroup;

  /// No description provided for @youtubeUrl.
  ///
  /// In ar, this message translates to:
  /// **'رابط فيديو يوتيوب'**
  String get youtubeUrl;

  /// No description provided for @videoPreview.
  ///
  /// In ar, this message translates to:
  /// **'معاينة الفيديو'**
  String get videoPreview;

  /// No description provided for @defaultValues.
  ///
  /// In ar, this message translates to:
  /// **'القيم الافتراضية'**
  String get defaultValues;

  /// No description provided for @sets.
  ///
  /// In ar, this message translates to:
  /// **'المجموعات (Sets)'**
  String get sets;

  /// No description provided for @reps.
  ///
  /// In ar, this message translates to:
  /// **'التكرارات (Reps)'**
  String get reps;

  /// No description provided for @duration.
  ///
  /// In ar, this message translates to:
  /// **'المدة (ثواني)'**
  String get duration;

  /// No description provided for @durationOptional.
  ///
  /// In ar, this message translates to:
  /// **'اختياري، للتمارين الموقوتة'**
  String get durationOptional;

  /// No description provided for @videoLink.
  ///
  /// In ar, this message translates to:
  /// **'رابط الفيديو'**
  String get videoLink;

  /// No description provided for @videoNotAvailable.
  ///
  /// In ar, this message translates to:
  /// **'الفيديو غير متوفر'**
  String get videoNotAvailable;

  /// No description provided for @newSubscription.
  ///
  /// In ar, this message translates to:
  /// **'اشتراك جديد'**
  String get newSubscription;

  /// No description provided for @editSubscription.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الاشتراك'**
  String get editSubscription;

  /// No description provided for @selectPlayer.
  ///
  /// In ar, this message translates to:
  /// **'اختر اللاعب'**
  String get selectPlayer;

  /// No description provided for @selectPlan.
  ///
  /// In ar, this message translates to:
  /// **'اختر خطة التمرين'**
  String get selectPlan;

  /// No description provided for @subscriptionDuration.
  ///
  /// In ar, this message translates to:
  /// **'مدة الاشتراك'**
  String get subscriptionDuration;

  /// No description provided for @startDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ البدء'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الانتهاء'**
  String get endDate;

  /// No description provided for @payment.
  ///
  /// In ar, this message translates to:
  /// **'الدفع (اختياري)'**
  String get payment;

  /// No description provided for @amount.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ'**
  String get amount;

  /// No description provided for @paymentNotes.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات الدفع'**
  String get paymentNotes;

  /// No description provided for @requiredField.
  ///
  /// In ar, this message translates to:
  /// **'حقل مطلوب'**
  String get requiredField;

  /// No description provided for @invalidEmail.
  ///
  /// In ar, this message translates to:
  /// **'بريد إلكتروني غير صالح'**
  String get invalidEmail;

  /// No description provided for @invalidPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم هاتف غير صالح'**
  String get invalidPhone;

  /// No description provided for @passwordLength.
  ///
  /// In ar, this message translates to:
  /// **'يجب أن تكون كلمة المرور 6 أحرف على الأقل'**
  String get passwordLength;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In ar, this message translates to:
  /// **'كلمات المرور غير متطابقة'**
  String get passwordsDoNotMatch;

  /// No description provided for @pleaseSelectPlayer.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء اختيار لاعب'**
  String get pleaseSelectPlayer;

  /// No description provided for @pleaseSelectPlan.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء اختيار خطة تمرين'**
  String get pleaseSelectPlan;

  /// No description provided for @success.
  ///
  /// In ar, this message translates to:
  /// **'تم بنجاح'**
  String get success;

  /// No description provided for @error.
  ///
  /// In ar, this message translates to:
  /// **'خطأ'**
  String get error;

  /// No description provided for @trainTrackTransform.
  ///
  /// In ar, this message translates to:
  /// **'تمرن. تتبع. تطور.'**
  String get trainTrackTransform;

  /// No description provided for @welcome.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً،'**
  String get welcome;

  /// No description provided for @day.
  ///
  /// In ar, this message translates to:
  /// **'اليوم {number}'**
  String day(int number);

  /// No description provided for @restDay.
  ///
  /// In ar, this message translates to:
  /// **'راحة'**
  String get restDay;

  /// No description provided for @addDay.
  ///
  /// In ar, this message translates to:
  /// **'إضافة يوم'**
  String get addDay;

  /// No description provided for @removeDay.
  ///
  /// In ar, this message translates to:
  /// **'حذف اليوم'**
  String get removeDay;

  /// No description provided for @exportPdf.
  ///
  /// In ar, this message translates to:
  /// **'تصدير PDF'**
  String get exportPdf;

  /// No description provided for @setDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل المجموعات'**
  String get setDetails;

  /// No description provided for @setLabel.
  ///
  /// In ar, this message translates to:
  /// **'مجموعة {number}'**
  String setLabel(int number);

  /// No description provided for @repsLabel.
  ///
  /// In ar, this message translates to:
  /// **'تكرار'**
  String get repsLabel;

  /// No description provided for @weightLabel.
  ///
  /// In ar, this message translates to:
  /// **'وزن (كغ)'**
  String get weightLabel;

  /// No description provided for @noSubscriptions.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد اشتراكات'**
  String get noSubscriptions;

  /// No description provided for @assignPlansToPlayers.
  ///
  /// In ar, this message translates to:
  /// **'قم بتعيين خطط تمرين للاعبين لإنشاء اشتراكات'**
  String get assignPlansToPlayers;

  /// No description provided for @noWorkoutPlans.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد خطط تمرين'**
  String get noWorkoutPlans;

  /// No description provided for @createFirstPlanMessage.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ خطتك الأولى للتمرين'**
  String get createFirstPlanMessage;

  /// No description provided for @exercisesCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} تمرين'**
  String exercisesCount(int count);

  /// No description provided for @weight.
  ///
  /// In ar, this message translates to:
  /// **'الوزن (كغ)'**
  String get weight;

  /// No description provided for @height.
  ///
  /// In ar, this message translates to:
  /// **'الطول (سم)'**
  String get height;

  /// No description provided for @viewPlan.
  ///
  /// In ar, this message translates to:
  /// **'عرض الخطة'**
  String get viewPlan;

  /// No description provided for @playerWorkoutPlan.
  ///
  /// In ar, this message translates to:
  /// **'خطة تمرين اللاعب'**
  String get playerWorkoutPlan;

  /// No description provided for @noMatchingExercises.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد تمارين مطابقة'**
  String get noMatchingExercises;

  /// No description provided for @thisField.
  ///
  /// In ar, this message translates to:
  /// **'هذا الحقل'**
  String get thisField;

  /// No description provided for @emailRequired.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني مطلوب'**
  String get emailRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور مطلوبة'**
  String get passwordRequired;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد كلمة المرور مطلوب'**
  String get confirmPasswordRequired;

  /// No description provided for @youtubeUrlRequired.
  ///
  /// In ar, this message translates to:
  /// **'رابط يوتيوب مطلوب'**
  String get youtubeUrlRequired;

  /// No description provided for @invalidYoutubeUrl.
  ///
  /// In ar, this message translates to:
  /// **'رابط يوتيوب غير صالح'**
  String get invalidYoutubeUrl;

  /// No description provided for @numberInvalid.
  ///
  /// In ar, this message translates to:
  /// **'الرقم غير صالح'**
  String get numberInvalid;

  /// No description provided for @amountInvalid.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ غير صالح'**
  String get amountInvalid;

  /// No description provided for @phoneInvalid.
  ///
  /// In ar, this message translates to:
  /// **'رقم هاتف غير صالح'**
  String get phoneInvalid;

  /// No description provided for @justNow.
  ///
  /// In ar, this message translates to:
  /// **'الآن'**
  String get justNow;

  /// No description provided for @minAgo.
  ///
  /// In ar, this message translates to:
  /// **'{minutes} دقيقة مضت'**
  String minAgo(Object minutes);

  /// No description provided for @hrAgo.
  ///
  /// In ar, this message translates to:
  /// **'{hours} ساعة مضت'**
  String hrAgo(Object hours);

  /// No description provided for @daysAgo.
  ///
  /// In ar, this message translates to:
  /// **'{days} أيام مضت'**
  String daysAgo(Object days);

  /// No description provided for @secondsShort.
  ///
  /// In ar, this message translates to:
  /// **'ث'**
  String get secondsShort;

  /// No description provided for @minutesShort.
  ///
  /// In ar, this message translates to:
  /// **'د'**
  String get minutesShort;

  /// No description provided for @expiresToday.
  ///
  /// In ar, this message translates to:
  /// **'تنتهي اليوم'**
  String get expiresToday;

  /// No description provided for @dayRemaining.
  ///
  /// In ar, this message translates to:
  /// **'يوم واحد متبقي'**
  String get dayRemaining;

  /// No description provided for @daysRemaining.
  ///
  /// In ar, this message translates to:
  /// **'{days} أيام متبقية'**
  String daysRemaining(Object days);

  /// No description provided for @selectPlayerTitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر اللاعب'**
  String get selectPlayerTitle;

  /// No description provided for @selectPlanTitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر خطة التمرين'**
  String get selectPlanTitle;

  /// No description provided for @choosePlayer.
  ///
  /// In ar, this message translates to:
  /// **'اختر لاعباً'**
  String get choosePlayer;

  /// No description provided for @choosePlan.
  ///
  /// In ar, this message translates to:
  /// **'اختر خطة'**
  String get choosePlan;

  /// No description provided for @month.
  ///
  /// In ar, this message translates to:
  /// **'شهر'**
  String get month;

  /// No description provided for @paymentOptional.
  ///
  /// In ar, this message translates to:
  /// **'الدفع (اختياري)'**
  String get paymentOptional;

  /// No description provided for @createSubscription.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء اشتراك'**
  String get createSubscription;

  /// No description provided for @subscriptionUpdated.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث الاشتراك'**
  String get subscriptionUpdated;

  /// No description provided for @subscriptionCreated.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء الاشتراك'**
  String get subscriptionCreated;

  /// No description provided for @subscriptionFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل حفظ الاشتراك'**
  String get subscriptionFailed;

  /// No description provided for @setsCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} مجموعات'**
  String setsCount(Object count);

  /// No description provided for @trainer.
  ///
  /// In ar, this message translates to:
  /// **'مدرب'**
  String get trainer;

  /// No description provided for @noDaysAdded.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أيام مضافة بعد. اضغط \"إضافة يوم\" للبدء.'**
  String get noDaysAdded;

  /// No description provided for @noWorkoutDaysMessage.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أيام مضافة بعد. اضغط \"إضافة يوم\" للبدء.'**
  String get noWorkoutDaysMessage;

  /// No description provided for @lockers.
  ///
  /// In ar, this message translates to:
  /// **'الخزائن'**
  String get lockers;

  /// No description provided for @lockerNumber.
  ///
  /// In ar, this message translates to:
  /// **'خزانة'**
  String get lockerNumber;

  /// No description provided for @assignLocker.
  ///
  /// In ar, this message translates to:
  /// **'تعيين خزانة'**
  String get assignLocker;

  /// No description provided for @unassignLocker.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء التعيين'**
  String get unassignLocker;

  /// No description provided for @availableLockers.
  ///
  /// In ar, this message translates to:
  /// **'خزائن متاحة'**
  String get availableLockers;

  /// No description provided for @occupiedLockers.
  ///
  /// In ar, this message translates to:
  /// **'خزائن مشغولة'**
  String get occupiedLockers;

  /// No description provided for @lockerAssigned.
  ///
  /// In ar, this message translates to:
  /// **'تم تعيين الخزانة'**
  String get lockerAssigned;

  /// No description provided for @lockerUnassigned.
  ///
  /// In ar, this message translates to:
  /// **'تم إلغاء تعيين الخزانة'**
  String get lockerUnassigned;

  /// No description provided for @selectPlayerForLocker.
  ///
  /// In ar, this message translates to:
  /// **'اختر لاعباً للخزانة'**
  String get selectPlayerForLocker;

  /// No description provided for @noLockers.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد خزائن'**
  String get noLockers;

  /// No description provided for @occupied.
  ///
  /// In ar, this message translates to:
  /// **'مشغول'**
  String get occupied;

  /// No description provided for @available.
  ///
  /// In ar, this message translates to:
  /// **'متاح'**
  String get available;

  /// No description provided for @total.
  ///
  /// In ar, this message translates to:
  /// **'المجموع'**
  String get total;

  /// No description provided for @alerts.
  ///
  /// In ar, this message translates to:
  /// **'التنبيهات'**
  String get alerts;

  /// No description provided for @unpaidSubscriptions.
  ///
  /// In ar, this message translates to:
  /// **'اشتراكات غير مدفوعة'**
  String get unpaidSubscriptions;

  /// No description provided for @unpaid.
  ///
  /// In ar, this message translates to:
  /// **'غير مدفوع'**
  String get unpaid;

  /// No description provided for @needsRenewal.
  ///
  /// In ar, this message translates to:
  /// **'يحتاج تجديد'**
  String get needsRenewal;

  /// No description provided for @renewSubscription.
  ///
  /// In ar, this message translates to:
  /// **'تجديد الاشتراك'**
  String get renewSubscription;

  /// No description provided for @overdue.
  ///
  /// In ar, this message translates to:
  /// **'متأخر'**
  String get overdue;

  /// No description provided for @daysUnit.
  ///
  /// In ar, this message translates to:
  /// **'يوم'**
  String get daysUnit;

  /// No description provided for @expiredOn.
  ///
  /// In ar, this message translates to:
  /// **'انتهى في'**
  String get expiredOn;

  /// No description provided for @noAlerts.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد تنبيهات'**
  String get noAlerts;

  /// No description provided for @currencies.
  ///
  /// In ar, this message translates to:
  /// **'العملات'**
  String get currencies;

  /// No description provided for @addCurrency.
  ///
  /// In ar, this message translates to:
  /// **'إضافة عملة'**
  String get addCurrency;

  /// No description provided for @editCurrency.
  ///
  /// In ar, this message translates to:
  /// **'تعديل العملة'**
  String get editCurrency;

  /// No description provided for @deleteCurrency.
  ///
  /// In ar, this message translates to:
  /// **'حذف العملة'**
  String get deleteCurrency;

  /// No description provided for @currencyName.
  ///
  /// In ar, this message translates to:
  /// **'اسم العملة'**
  String get currencyName;

  /// No description provided for @currencyCode.
  ///
  /// In ar, this message translates to:
  /// **'رمز العملة'**
  String get currencyCode;

  /// No description provided for @currencySymbol.
  ///
  /// In ar, this message translates to:
  /// **'رمز العملة'**
  String get currencySymbol;

  /// No description provided for @defaultLabel.
  ///
  /// In ar, this message translates to:
  /// **'افتراضي'**
  String get defaultLabel;

  /// No description provided for @setAsDefault.
  ///
  /// In ar, this message translates to:
  /// **'تعيين كافتراضي'**
  String get setAsDefault;

  /// No description provided for @currencyInUse.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن حذف عملة مستخدمة في اشتراكات'**
  String get currencyInUse;

  /// No description provided for @noCurrencies.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد عملات'**
  String get noCurrencies;

  /// No description provided for @selectCurrency.
  ///
  /// In ar, this message translates to:
  /// **'اختر العملة'**
  String get selectCurrency;

  /// No description provided for @playerHasActiveSubscription.
  ///
  /// In ar, this message translates to:
  /// **'هذا اللاعب لديه اشتراك نشط بالفعل'**
  String get playerHasActiveSubscription;

  /// No description provided for @cannotAddSubscription.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن إضافة اشتراك جديد'**
  String get cannotAddSubscription;

  /// No description provided for @share.
  ///
  /// In ar, this message translates to:
  /// **'مشاركة'**
  String get share;

  /// No description provided for @download.
  ///
  /// In ar, this message translates to:
  /// **'تحميل'**
  String get download;

  /// No description provided for @printLabel.
  ///
  /// In ar, this message translates to:
  /// **'طباعة'**
  String get printLabel;

  /// No description provided for @exportPlan.
  ///
  /// In ar, this message translates to:
  /// **'تصدير الخطة'**
  String get exportPlan;

  /// No description provided for @fileSaved.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ الملف في'**
  String get fileSaved;

  /// No description provided for @shareVia.
  ///
  /// In ar, this message translates to:
  /// **'مشاركة عبر'**
  String get shareVia;

  /// No description provided for @pdfExportOptions.
  ///
  /// In ar, this message translates to:
  /// **'خيارات التصدير'**
  String get pdfExportOptions;

  /// No description provided for @saveToDevice.
  ///
  /// In ar, this message translates to:
  /// **'حفظ في الجهاز'**
  String get saveToDevice;

  /// No description provided for @systemPrintDialog.
  ///
  /// In ar, this message translates to:
  /// **'نافذة الطباعة'**
  String get systemPrintDialog;
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
      <String>['ar'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
