class Validators {
  static String? required(String? value, {String fieldName = 'هذا الحقل'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'بريد إلكتروني غير صالح';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    if (value.length < 6) {
      return 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'تأكيد كلمة المرور مطلوب';
    }
    if (value != password) {
      return 'كلمات المرور غير متطابقة';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Phone is optional
    }
    final phoneRegex = RegExp(r'^[+]?[\d\s-]{8,}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'رقم هاتف غير صالح';
    }
    return null;
  }

  static String? youtubeUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رابط يوتيوب مطلوب';
    }
    
    final youtubeRegex = RegExp(
      r'^(https?://)?(www\.)?(youtube\.com/watch\?v=|youtu\.be/|youtube\.com/embed/)[\w-]+',
    );
    
    if (!youtubeRegex.hasMatch(value)) {
      return 'رابط يوتيوب غير صالح';
    }
    return null;
  }

  static String? number(String? value, {String fieldName = 'هذا الحقل', int? min, int? max}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }
    
    final number = int.tryParse(value);
    if (number == null) {
      return 'الرقم غير صالح';
    }
    
    if (min != null && number < min) {
      return '$fieldName يجب أن يكون أكبر من أو يساوي $min';
    }
    
    if (max != null && number > max) {
      return '$fieldName يجب أن يكون أصغر من أو يساوي $max';
    }
    
    return null;
  }

  static String? amount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Amount can be optional
    }
    
    final amount = double.tryParse(value);
    if (amount == null || amount < 0) {
      return 'المبلغ غير صالح';
    }
    
    return null;
  }
}
