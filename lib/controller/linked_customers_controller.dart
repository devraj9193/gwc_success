import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/customers_list_model.dart';
import '../model/linked_customers_model.dart';
import '../utils/gwc_api.dart';

class LinkedCustomersController extends GetxController {
  LinkedCustomerList? linkedCustomerList;
  CustomersList? customersList;

  @override
  void onInit() {
    super.onInit();
    fetchLinkedList();
    fetchCustomersList();
  }

  Future<List<LinkedList>?> fetchLinkedList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    final response =
        await http.get(Uri.parse(GwcApi.linkedListApiUrl), headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      // print("status: ${response.body}");
      LinkedCustomerList jsonData = linkedCustomerListFromJson(response.body);
      List<LinkedList>? arrData = jsonData.data;
      return arrData;
    } else {
      throw Exception();
    }
  }

  Future<List<Datum>?> fetchCustomersList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    final response =
        await http.get(Uri.parse(GwcApi.customersListApiUrl), headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
       print("statussss: ${response.body}");
      CustomersList jsonData = customersListFromJson(response.body);
      List<Datum>? arrData = jsonData.data;
      return arrData;
    } else {
      throw Exception();
    }
  }
}
