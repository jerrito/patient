import 'package:flutter/foundation.dart';
import 'package:project/databases/firebase_services.dart';
import 'package:project/modules/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  final SharedPreferences? preferences;
  final firebaseService = FirebaseServices();

  UserProvider({required this.preferences}) {
    var appUserString = preferences?.getString("app_user") ?? '';
    _appUser = appUserString.isNotEmpty ? User.fromString(appUserString) : null;
  }

  User? _appUser;
  User? get appUser => _appUser;

  set appUser(User? a) {
    _appUser = a;
    notifyListeners();

    preferences?.setString(
      "app_user",
      a?.toString() ?? '',
    );
  }

  Future<QueryResult<User>?>? getUser({required String phoneNumber}) async {
    var result = await firebaseService.getUser(phoneNumber: phoneNumber);

    if (result?.status == QueryStatus.Successful && result?.data != null) {
      appUser = result?.data;
    }

    return result;
  }

  Future<QueryResult<User>?>? getUser_2(
      {required String phoneNumber, required String password}) async {
    var result = await firebaseService.getUser_2(
        phoneNumber: phoneNumber, password: password);

    if (result?.status == QueryStatus.Successful && result?.data != null) {
      appUser = result?.data;
    }

    return result;
  }

  Future<QueryResult<User>?>? updateUser({required User user}) async {
    var result = await firebaseService.updateUser(user: user);

    if (result?.status == QueryStatus.Successful) {
      await getUser(phoneNumber: user.number ?? "");
    }

    return result;
  }
}

// class MedicalProvider extends ChangeNotifier {
//   final SharedPreferences? preferences;
//   final firebaseService = FirebaseServices();
//
//   MedicalProvider({required this.preferences}) {
//     var appUserString = preferences?.getString("app_user") ?? '';
//     _appUser =
//         appUserString.isNotEmpty ? MedicalInfo.fromString(appUserString) : null;
//   }
//
//   MedicalInfo? _appUser;
//
//   MedicalInfo? get appUser => _appUser;
//
//   set appUser(MedicalInfo? a) {
//     _appUser = a;
//     notifyListeners();
//
//     preferences?.setString(
//       "app_user",
//       a?.toString() ?? '',
//     );
//   }
//
//   Future<QueryResult<MedicalInfo>?>? getMedicalInfo(
//       {required String phoneNumber}) async {
//     var result = await firebaseService.getMedicalInfo(phoneNumber: phoneNumber);
//
//     if (result?.status == QueryStatus.Successful && result?.data != null) {
//       appUser = result?.data;
//     }
//
//     return result;
//   }
// }
