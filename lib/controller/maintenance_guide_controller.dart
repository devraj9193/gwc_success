import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/maintenance_guide_model.dart';
import '../utils/success_api_urls.dart';

class MaintenanceGuideController extends GetxController {
  MaintenanceGuideModel? maintenanceGuideModel;

  @override
  void onInit() {
    super.onInit();
    fetchPostProgramList();
    fetchMaintenanceGuideList();
  }

  Future<List<GutMaintenanceGuide>?> fetchPostProgramList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    final response =
        await http.get(Uri.parse(SuccessApiUrls.successPostProgramList), headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Gut: ${response.body}");
      MaintenanceGuideModel jsonData =
          maintenanceGuideModelFromJson(response.body);
      List<GutMaintenanceGuide>? arrData = jsonData.postProgramList;
      print("status: ${arrData?[0].status}");
      return arrData;
    } else {
      throw Exception();
    }
  }

  Future<List<GutMaintenanceGuide>?> fetchMaintenanceGuideList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    final response =
        await http.get(Uri.parse(SuccessApiUrls.successPostProgramList), headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      MaintenanceGuideModel jsonData =
          maintenanceGuideModelFromJson(response.body);
      List<GutMaintenanceGuide>? arrData = jsonData.gutMaintenanceGuide;
      print("status: ${arrData?[0].status}");
      return arrData;
    } else {
      throw Exception();
    }
  }
}
