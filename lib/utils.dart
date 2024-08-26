import 'package:chat_easy/firebase_options.dart';
import 'package:chat_easy/services/auth_service.dart';
import 'package:chat_easy/services/database_service.dart';
import 'package:chat_easy/services/media_service.dart';
import 'package:chat_easy/services/navigation_services.dart';
import 'package:chat_easy/services/stortage_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';


Future<void> setupFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,);
}
Future<void> registerServices()
async {
  final GetIt getIt= GetIt.instance;
  getIt.registerSingleton<AuthService>(
    AuthService(),
  );
getIt.registerSingleton<NavigationService>(
  NavigationService(),
);
getIt.registerSingleton<MediaService>(
  MediaService(),
);
getIt.registerSingleton<StortageServices>(
 StortageServices(),
);
getIt.registerSingleton<Databaseservice>(
 Databaseservice(),
);

}
Future<String> generateChatID({required String uid1,required String uid2})
async {
  List uids=[uid1,uid2];
  uids.sort();
  String chatID=uids.fold("", (id,uid)=>"$id$uid");
  return chatID;
}