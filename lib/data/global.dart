import 'package:travel/data/models/user_model.dart';
import 'package:travel/data/repositories/user_repository.dart';
import 'package:travel/services/firebase_auth_service.dart';

class Global {
  static final Global _instance = Global._internal();
  factory Global() => _instance;
  Global._internal();

  static final UserModel user = UserModel(uid: '', username: '', name: '', email: '', country: '', gender: '', phone: '', role: 'user');

  static Future<void> loadUserInfo() async {
    String userUid = AuthService.getCurrentUser()!.uid;
    UserModel? currentUser = await UserRepository.getUser(userUid);
    user.uid = currentUser!.uid;
    user.username = currentUser.username;
    user.name = currentUser.name;
    user.email = currentUser.email;
    user.country = currentUser.country;
    user.gender = currentUser.gender;
    user.phone = currentUser.phone;
    user.role = currentUser.role;
    user.imageUrl = currentUser.imageUrl;
  }
}
