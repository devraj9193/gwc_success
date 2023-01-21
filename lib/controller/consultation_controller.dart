import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/consultation_model.dart';
import '../utils/gwc_api.dart';

class ConsultationController extends GetxController {
  ConsultationModel? consultationModel;

  @override
  void onInit() {
    super.onInit();
    fetchConsultation();
  }

  Future<List<Appointment>?> fetchConsultation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    final response = await http.get(Uri.parse(GwcApi.consultationUrl), headers: {
      'Authorization': 'Bearer $token',
    });
     print("Consultation: ${response.body}");
    if (response.statusCode == 200) {
      ConsultationModel jsonData = consultationModelFromJson(response.body);
      List<Appointment>? arrData = jsonData.appointmentList;
      //   print("status: ${arrData?[0].status}");
      return arrData;
    } else {
      throw Exception();
    }
  }
}
