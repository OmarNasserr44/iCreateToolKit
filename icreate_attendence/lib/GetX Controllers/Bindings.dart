import 'package:get/get.dart';
import 'package:icreate_attendence/GetX%20Controllers/NewTaskController.dart';
import 'package:icreate_attendence/GetX%20Controllers/Push_Notification.dart';
import 'package:icreate_attendence/GetX%20Controllers/TasksController.dart';
import 'package:icreate_attendence/GetX%20Controllers/shared_preferences.dart';
import 'package:icreate_attendence/GetX%20Controllers/updateCheck.dart';
import 'package:icreate_attendence/Requests/FirebaseRequests.dart';
import 'package:icreate_attendence/Requests/SignInUpFirebase.dart';

class AllControllerBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TasksController>(() => TasksController(), fenix: true);
    Get.lazyPut<SignInUp>(() => SignInUp(), fenix: true);
    Get.lazyPut<FirebaseRequests>(() => FirebaseRequests(), fenix: true);
    Get.lazyPut<UpdateCheck>(() => UpdateCheck(), fenix: true);
    Get.lazyPut<NewTaskController>(() => NewTaskController(), fenix: true);
    Get.lazyPut<PushNotification>(() => PushNotification(), fenix: true);
    Get.lazyPut<SharedPreferencesController>(
        () => SharedPreferencesController(),
        fenix: true);
  }
}
