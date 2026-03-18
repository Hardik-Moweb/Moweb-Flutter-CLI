class MyStrings {
  static const String appName = 'Flutter Code Structure';
  static const String sessionTimeOut = 'Session timeout, please login again.';
  static const String ok = 'OK';
  static const String sureToExit = 'Are you sure you want to exit?';
  static const String somethingWentWrong =
      'Something went wrong, please try again later.';
  static const String nointernet = 'No Internet Connection';
  static const String login = 'Login';
  static const String signin = 'Sign In';
  static const String welcomeBack = 'Welcome Back';
  static const String pleaseEnterCradentials = 'Please enter your credentials';
  static const String email = 'Email';
  static const String emial = 'Email';
  static const String typeHere = 'Type here...';
  static const String password = 'Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String profile = 'Profile';
  static const String firstName = 'First Name';
  static const String lastName = 'Last Name';
  static const String emailAddress = 'Email Address';
  static const String contactNo = 'Contact No';
  static const String phoneNumber = 'Phone Number';
  static const String update = 'Update';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String edit = 'Edit';
  static const String allStatus = 'All Status';
  static const String allManagers = 'All Managers';
  static const String na = 'N/A';
  static const String role = 'Role';
  static const String department = 'Department';
  static const String updateProfile = 'Update Profile';

  // Hints
  static const String enterFirstNameHint = 'Enter first name';
  static const String enterLastNameHint = 'Enter last name';
  static const String emailHint = 'Enter email address';
  static const String enterPhoneNumberHint = 'Enter phone number';

  // Messages
  static const String profileUpdatedSuccess = 'Profile updated successfully';
  static const String profileUpdateFailed = 'Failed to update profile';
  static const String emailIsRequired = 'Email is required';
  static const String invalidEmail = 'Invalid email';
  static const String passwordIsRequired = 'Password is required';
  static const String passwordTooShort =
      'Password must be at least 6 characters';
  static const String enterEmail = 'Please enter email address';
  static const String enterValidEmail = 'Please enter a valid email address';
  static const String eneterPassword = 'Please enter password';
  static const String enterFirstName = 'Please enter first name';
  static const String enterLastName = 'Please enter last name';
  static const String enterPhoneNumber = 'Please enter phone number';
  static const String updateReq = 'Update Required';
  static const String updateAvail = 'Update Available';
  static const String newVersionTextForceUpdate =
      'A new version is available. Please update to continue.';
  static const String newVersionTextSoftUpdate =
      'A new version is available. Would you like to update?';
  static const String version = 'Version';
  static const String updateNow = 'Update Now';
  static const String later = 'Later';
}

class DateFormats {
  static const String yyyyMMdd = "yyyy-MM-dd";
  static const String ddMMMyyyy = "dd MMM yyyy";
  static const String ddMMyyyy = "dd-MM-yyyy";
  static const String mmmDdYyyyHhmm = "MMM dd, yyyy HH:mm";
  static const String ddMMyyyySlash = "dd/MM/yyyy";
  static const String mmDdYyyySlash = "MM/dd/yyyy";
  static const String ddMmmYyyySpace = "dd MMM yyyy";
  static const String hhmmA = "hh:mm a";
  static const String hhMmSsSss = "HH:mm:ss.SSS";
  static const String yyyyMmDdHhMmSs = "yyyy-MM-dd HH:mm:ss";
}

class Pref {
  static const String loginData = "loginData";
  static const String userData = "userData";
  static const String profileData = "profileData";
}

class PreferenceKey {
  static String prefIsUserLoggedIn = "isUserLoggedIn";
  static String prefAccessToken = "accessToken";
  static String prefIntUDID = "intUDID";
  static String prefDeviceToken = "deviceToken";
  static String prefRefreshToken = "refreshToken";
}

class RegexPatterns {
  static const String emailPattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
}
