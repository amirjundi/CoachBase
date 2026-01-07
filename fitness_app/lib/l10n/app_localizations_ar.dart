// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'CoachBase';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get signInToContinue => 'سجل الدخول للمتابعة';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get createAccount => 'إنشاء حساب جديد';

  @override
  String get startManaging => 'ابدأ إدارة تدريبات اللياقة';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get phone => 'رقم الهاتف';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get players => 'اللاعبين';

  @override
  String get workoutPlans => 'خطة التمارين';

  @override
  String get exercises => 'التمارين';

  @override
  String get subscriptions => 'الاشتراكات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get helpSupport => 'المساعدة والدعم';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutConfirmation => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get deleteConfirmation => 'هل أنت متأكد أنك تريد حذف هذا؟';

  @override
  String get deleteConfirmationAlt => 'هل تريد بالتأكيد حذف هذا العنصر؟';

  @override
  String daysLeft(Object days) {
    return 'باقي $days أيام';
  }

  @override
  String get unknownPlayer => 'لاعب غير معروف';

  @override
  String get unknownPlan => 'خطة غير معروفة';

  @override
  String get cancelled => 'ملغي';

  @override
  String get save => 'حفظ';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get add => 'نعم';

  @override
  String get edit => 'تعديل';

  @override
  String get remove => 'إزالة';

  @override
  String get search => 'بحث...';

  @override
  String get noPlayers => 'لا يوجد لاعبين حتى الآن';

  @override
  String get addFirstPlayer => 'أضف لاعبك الأول للبدء';

  @override
  String get addPlayer => 'إضافة لاعب';

  @override
  String get playerDetails => 'تفاصيل اللاعب';

  @override
  String get editPlayer => 'تعديل بيانات اللاعب';

  @override
  String get activeSubscription => 'الاشتراك النشط';

  @override
  String get subscriptionHistory => 'سجل الاشتراكات';

  @override
  String get noActiveSubscription => 'لا يوجد اشتراك نشط';

  @override
  String get expiringSoon => 'ينتهي قريباً';

  @override
  String get expired => 'منتهي';

  @override
  String get active => 'نشط';

  @override
  String get assignPlan => 'تعيين خطة';

  @override
  String get noPlans => 'لا يوجد خطط تمرين';

  @override
  String get createFirstPlan => 'أنشئ خطة التمرين الأولى';

  @override
  String get createPlan => 'إنشاء خطة';

  @override
  String get newPlan => 'خطة جديدة';

  @override
  String get planDetails => 'تفاصيل الخطة';

  @override
  String get weeklySchedule => 'جدول التدريب';

  @override
  String get workoutDays => 'أيام التمرين';

  @override
  String get restDays => 'أيام الراحة';

  @override
  String get noWorkoutDays => 'لم يتم تحديد أيام تمرين';

  @override
  String get editPlan => 'تعديل الخطة';

  @override
  String get difficultyLevel => 'مستوى الصعوبة';

  @override
  String get description => 'الوصف';

  @override
  String get focusArea => 'منطقة التركيز';

  @override
  String get selectWorkoutDays => 'تخطيط الأيام';

  @override
  String get selectWorkoutDaysSubtitle =>
      'قم بإضافة أيام تمرين أو راحة بالتسلسل';

  @override
  String get selectFocusAreas => 'مناطق التركيز (اختياري)';

  @override
  String get setFocusArea => 'حدد تركيزاً لكل يوم تمرين';

  @override
  String get dayEditor => 'محرر اليوم';

  @override
  String get addExercise => 'إضافة تمرين';

  @override
  String get noExercises => 'لا يوجد تمارين';

  @override
  String get buildLibrary => 'ابنِ مكتبة تمارينك باستخدام فيديوهات يوتيوب';

  @override
  String get exerciseDetails => 'تفاصيل التمرين';

  @override
  String get muscleGroup => 'العضلة المستهدفة';

  @override
  String get youtubeUrl => 'رابط فيديو يوتيوب';

  @override
  String get videoPreview => 'معاينة الفيديو';

  @override
  String get defaultValues => 'القيم الافتراضية';

  @override
  String get sets => 'المجموعات (Sets)';

  @override
  String get reps => 'التكرارات (Reps)';

  @override
  String get duration => 'المدة (ثواني)';

  @override
  String get durationOptional => 'اختياري، للتمارين الموقوتة';

  @override
  String get videoLink => 'رابط الفيديو';

  @override
  String get videoNotAvailable => 'الفيديو غير متوفر';

  @override
  String get newSubscription => 'اشتراك جديد';

  @override
  String get editSubscription => 'تعديل الاشتراك';

  @override
  String get selectPlayer => 'اختر اللاعب';

  @override
  String get selectPlan => 'اختر خطة التمرين';

  @override
  String get subscriptionDuration => 'مدة الاشتراك';

  @override
  String get startDate => 'تاريخ البدء';

  @override
  String get endDate => 'تاريخ الانتهاء';

  @override
  String get payment => 'الدفع (اختياري)';

  @override
  String get amount => 'المبلغ';

  @override
  String get paymentNotes => 'ملاحظات الدفع';

  @override
  String get requiredField => 'حقل مطلوب';

  @override
  String get invalidEmail => 'بريد إلكتروني غير صالح';

  @override
  String get invalidPhone => 'رقم هاتف غير صالح';

  @override
  String get passwordLength => 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';

  @override
  String get passwordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String get pleaseSelectPlayer => 'الرجاء اختيار لاعب';

  @override
  String get pleaseSelectPlan => 'الرجاء اختيار خطة تمرين';

  @override
  String get success => 'تم بنجاح';

  @override
  String get error => 'خطأ';

  @override
  String get trainTrackTransform => 'تمرن. تتبع. تطور.';

  @override
  String get welcome => 'مرحباً،';

  @override
  String day(int number) {
    return 'اليوم $number';
  }

  @override
  String get restDay => 'راحة';

  @override
  String get addDay => 'إضافة يوم';

  @override
  String get removeDay => 'حذف اليوم';

  @override
  String get exportPdf => 'تصدير PDF';

  @override
  String get setDetails => 'تفاصيل المجموعات';

  @override
  String setLabel(int number) {
    return 'مجموعة $number';
  }

  @override
  String get repsLabel => 'تكرار';

  @override
  String get weightLabel => 'وزن (كغ)';

  @override
  String get noSubscriptions => 'لا يوجد اشتراكات';

  @override
  String get assignPlansToPlayers =>
      'قم بتعيين خطط تمرين للاعبين لإنشاء اشتراكات';

  @override
  String get noWorkoutPlans => 'لا يوجد خطط تمرين';

  @override
  String get createFirstPlanMessage => 'أنشئ خطتك الأولى للتمرين';

  @override
  String exercisesCount(int count) {
    return '$count تمرين';
  }

  @override
  String get weight => 'الوزن (كغ)';

  @override
  String get height => 'الطول (سم)';

  @override
  String get viewPlan => 'عرض الخطة';

  @override
  String get playerWorkoutPlan => 'خطة تمرين اللاعب';

  @override
  String get noMatchingExercises => 'لا توجد تمارين مطابقة';

  @override
  String get thisField => 'هذا الحقل';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String get confirmPasswordRequired => 'تأكيد كلمة المرور مطلوب';

  @override
  String get youtubeUrlRequired => 'رابط يوتيوب مطلوب';

  @override
  String get invalidYoutubeUrl => 'رابط يوتيوب غير صالح';

  @override
  String get numberInvalid => 'الرقم غير صالح';

  @override
  String get amountInvalid => 'المبلغ غير صالح';

  @override
  String get phoneInvalid => 'رقم هاتف غير صالح';

  @override
  String get justNow => 'الآن';

  @override
  String minAgo(Object minutes) {
    return '$minutes دقيقة مضت';
  }

  @override
  String hrAgo(Object hours) {
    return '$hours ساعة مضت';
  }

  @override
  String daysAgo(Object days) {
    return '$days أيام مضت';
  }

  @override
  String get secondsShort => 'ث';

  @override
  String get minutesShort => 'د';

  @override
  String get expiresToday => 'تنتهي اليوم';

  @override
  String get dayRemaining => 'يوم واحد متبقي';

  @override
  String daysRemaining(Object days) {
    return '$days أيام متبقية';
  }

  @override
  String get selectPlayerTitle => 'اختر اللاعب';

  @override
  String get selectPlanTitle => 'اختر خطة التمرين';

  @override
  String get choosePlayer => 'اختر لاعباً';

  @override
  String get choosePlan => 'اختر خطة';

  @override
  String get month => 'شهر';

  @override
  String get paymentOptional => 'الدفع (اختياري)';

  @override
  String get createSubscription => 'إنشاء اشتراك';

  @override
  String get subscriptionUpdated => 'تم تحديث الاشتراك';

  @override
  String get subscriptionCreated => 'تم إنشاء الاشتراك';

  @override
  String get subscriptionFailed => 'فشل حفظ الاشتراك';

  @override
  String setsCount(Object count) {
    return '$count مجموعات';
  }

  @override
  String get trainer => 'مدرب';

  @override
  String get noDaysAdded => 'لا توجد أيام مضافة بعد. اضغط \"إضافة يوم\" للبدء.';

  @override
  String get noWorkoutDaysMessage =>
      'لا توجد أيام مضافة بعد. اضغط \"إضافة يوم\" للبدء.';
}
