class ValidationHelper {
  /// Basic email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "البرىد الإلكترونى لا يمكن أن يكون فارغًا";
    }
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return "البريد الإلكترونى غير صالح";
    }
    return null;
  }

  /// Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "كلمة المرور لا يمكن أن تكون فارغة";
    }
    if (value.length < 6) {
      return "كلمة المرور يجب أن تحتوى على 6 أحرف على الأقل";
    }
    return null;
  }

  static String? validateConfirmPassword(String? value1, String value2) {
    final message = validatePassword(value1);
    if (message != null) return message;
    if (value1 != value2) {
      return "كلمة المرور غير متطابقة";
    }
    return null;
  }

  /// First Name
  static String? validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return "الاسم الأول لا يمكن أن يكون فارغًا";
    }
    if (value.length < 2) {
      return "الاسم الأول يجب أن يكون على الأقل حرفين";
    }
    return null;
  }

  /// Last Name
  static String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return "اسم العائلة لا يمكن أن يكون فارغًا";
    }
    if (value.length < 2) {
      return "اسم العائلة يجب أن يكون على الأقل حرفين";
    }
    return null;
  }

  /// Simple international phone number validation (E.164)
  static String? validateBasicInternationalPhone(
      String? value, String? countryCode, String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return "رقم الهاتف لا يمكن أن يكون فارغًا";
    }
    if (countryCode == null) {
      return "ادخل كود الدولة";
    }
    final RegExp phoneRegex = RegExp(r'^\+\d{6,15}$');
    if (!phoneRegex.hasMatch(phoneNumber)) {
      return "رقم الهاتف غير صالح";
    }
    return null;
  }
}
//   /// Advanced phone number validation using libphonenumber
//   static Future<String?> validateAdvancedPhone(String? value,
//       {String isoCode = 'SA'}) async {
//     if (value == null || value.isEmpty) {
//       return "رقم الهاتف لا يمكن أن يكون فارغًا";
//     }

//     final isValid = await PhoneNumberUtil.isValidPhoneNumber(
//       phoneNumber: value,
//       isoCode: isoCode,
//     );

//     if (!isValid!) {
//       return "رقم الهاتف غير صالح";
//     }

//     return null;
//   }
// }
