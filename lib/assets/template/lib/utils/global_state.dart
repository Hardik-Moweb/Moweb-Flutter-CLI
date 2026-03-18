import 'package:{{project_name}}/features/auth/models/login_model.dart';
import 'package:{{project_name}}/features/auth/models/profile_model.dart';
import 'package:{{project_name}}/features/auth/models/user_data_model.dart';

/// GlobalState — singleton for application-wide in-memory state.
///
/// Access anywhere via the top-level [globalState] instance:
///
/// ```dart
/// // Store login data after successful login
/// globalState.setLoginResponse(loginModel);
///
/// // Read the current user's name
/// final name = globalState.userData?.firstName ?? '';
///
/// // Clear everything on logout
/// globalState.clearUserData();
/// ```
class GlobalState {
  // ── Singleton ──────────────────────────────────────────────────────────────
  static final GlobalState _instance = GlobalState._internal();
  factory GlobalState() => _instance;
  GlobalState._internal();

  // ── Auth / User data ───────────────────────────────────────────────────────

  /// Full login API response (tokens + user snapshot).
  LoginResponseModel? loginResponseData;

  /// Latest profile API response.
  ProfileData? profileData;

  /// Merged user model built from [loginResponseData] + [profileData].
  UserDataModel? userData;

  /// Current device push-notification token.
  String? strDeviceId;

  /// Whether the logged-in user holds the "Super Admin" role.
  bool isSuperAdmin = false;

  // ── App meta ───────────────────────────────────────────────────────────────
  String appVersion = "";
  bool updateDialog = false;
  String pendingSoftUpdate = "";

  // ── Notifications ──────────────────────────────────────────────────────────
  int unreadCount = 0;

  // ── Currency ───────────────────────────────────────────────────────────────
  /// Symbol shown across the app (e.g. "₹", "\$"). Updated after login.
  String currencySymbol = '₹';

  // ── Public helpers ─────────────────────────────────────────────────────────

  /// Stores the login response, builds [userData], updates currency and role.
  void setLoginResponse(LoginResponseModel model) {
    loginResponseData = model;
    userData = UserDataModel.fromLoginResponse(model);
    updateCurrency(model.data?.user?.currency);
    updateIsSuperAdminFromUserData();
  }

  /// Updates [isSuperAdmin] from [userData] role name.
  void updateIsSuperAdminFromUserData() {
    final roleName = userData?.role?.name ?? userData?.roleName ?? '';
    isSuperAdmin = roleName.trim().toLowerCase() == 'super admin';
  }

  void updateCurrency(String? currency) {
    if (currency != null && currency.isNotEmpty) {
      currencySymbol = currency;
    }
  }

  String getCurrencySymbol() => currencySymbol;

  void updateAppVersion(String version) => appVersion = version;

  void updatePendingSoftwareVersion(String version) =>
      pendingSoftUpdate = version;

  /// Clears all user-specific state (call on logout).
  void clearUserData() {
    loginResponseData = null;
    profileData = null;
    userData = null;
    isSuperAdmin = false;
    currencySymbol = '₹';
    unreadCount = 0;
    strDeviceId = null;
  }
}

// Top-level singleton – import this anywhere in the app.
final globalState = GlobalState();
