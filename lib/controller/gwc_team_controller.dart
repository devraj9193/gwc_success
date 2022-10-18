import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/doctor_list_model.dart';
import '../model/success_list_model.dart';
import '../utils/gwc_api.dart';

class GwcTeamController extends GetxController {
  DoctorsList? doctorsList;
  SuccessList? successList;

  @override
  void onInit() {
    super.onInit();
    fetchDoctorList();
    fetchSuccessList();
  }

  Future<List<DoctorsTeam>?> fetchDoctorList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    final response =
        await http.get(Uri.parse(GwcApi.doctorsListApiUrl), headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
     // print("status: ${response.body}");
      DoctorsList jsonData = doctorsListFromJson(response.body);
      List<DoctorsTeam>? arrData = jsonData.data;
      print("status: ${arrData?[0].name}");
      return arrData;
    } else {
      throw Exception();
    }
  }

  Future<List<SuccessTeam>?> fetchSuccessList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    final response =
        await http.get(Uri.parse(GwcApi.successTeamListApiUrl), headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      //print("status: ${response.body}");
      SuccessList jsonData = successListFromJson(response.body);
      List<SuccessTeam>? arrData = jsonData.data;
      print("status: ${arrData?[0].email}");
      return arrData;
    } else {
      throw Exception();
    }
  }
}
