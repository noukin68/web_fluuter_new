import 'package:flutter/material.dart';
class AuthorizationProvider extends InheritedWidget {
  final ValueNotifier<bool> _isAuthorizedNotifier;
  final ValueNotifier<bool> _hasLicenseNotifier;

  AuthorizationProvider({
    super.key,
    required Widget child,
    required bool isAuthorized,
    required bool hasLicense,
  })  : _isAuthorizedNotifier = ValueNotifier<bool>(isAuthorized),
        _hasLicenseNotifier = ValueNotifier<bool>(hasLicense),
        super(child: child);

  ValueNotifier<bool> get isAuthorizedNotifier => _isAuthorizedNotifier;
  ValueNotifier<bool> get hasLicenseNotifier => _hasLicenseNotifier;

  static AuthorizationProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AuthorizationProvider>();
  }

  void updateAuthorization(bool isAuthorized, bool hasLicense) {
    _isAuthorizedNotifier.value = isAuthorized;
    _hasLicenseNotifier.value = hasLicense;
  }

  @override
  bool updateShouldNotify(AuthorizationProvider oldWidget) {
    return _isAuthorizedNotifier.value != oldWidget._isAuthorizedNotifier.value ||
        _hasLicenseNotifier.value != oldWidget._hasLicenseNotifier.value;
  }
}