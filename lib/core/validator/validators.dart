class Validators {
  //email'i kontrol etmek için bir regex
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  //email dogrulama fonksiyonu
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email address is required";
    }

    if (!emailRegex.hasMatch(value)) {
      return "Enter a valid email address";
    }

    return null; // doğrulama başarılı
  }

  //şifre doğrulama fonksiyonu
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  // İsim doğrulama fonksiyonu
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Name is required";
    }

    if (value.length < 3) {
      return "Name must be at least 3 characters";
    }
    return null;
  }

  // Şifre onaylama fonksiyonu
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password";
    }

    if (value != password) {
      return "Passwords do not match";
    }
    return null;
  }
}