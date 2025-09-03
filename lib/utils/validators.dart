class Validators {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters long';
    }
    if (value.length > 30) {
      return 'Username must be less than 30 characters';
    }
    // Username should only contain letters, numbers, dots, and underscores
    if (!RegExp(r'^[a-zA-Z0-9._]+$').hasMatch(value)) {
      return 'Username can only contain letters, numbers, dots, and underscores';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Basic email validation
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  static String? validateUserCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a user code';
    }
    if (value.length < 3) {
      return 'User code must be at least 3 characters long';
    }
    if (value.length > 30) {
      return 'User code must be less than 30 characters';
    }
    // User code should only contain letters, numbers, and underscores
    if (!RegExp(r'^[A-Z0-9_]+$').hasMatch(value)) {
      return 'User code can only contain uppercase letters, numbers, and underscores';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone is optional
    }
    // Basic phone validation (allows +, numbers, spaces, dashes, parentheses)
    if (!RegExp(r'^[\+]?[0-9\s\-\(\)]+$').hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
}
