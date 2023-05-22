import 'dart:convert';
import 'package:currency_converter_app/model/currency_model.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';

class ApiService {
  Future<List<CurrencyModel>> getLatest(String baseCurrency) async {
    List<CurrencyModel> currencyModelList = [];
    Uri uri = Uri.parse('$url&base_currency=$baseCurrency');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      Map<String, dynamic> body = json['data'];

      body.forEach((key, value) {
        CurrencyModel currencyModel =
            CurrencyModel(code: value['code'], value: value['value']);
        currencyModelList.add(currencyModel);
      });

      return currencyModelList;
    } else {
      return [];
    }
  }

  Future<List<CurrencyModel>> getExhange(
      String baseCurrency, String targetCurrency) async {
    List<CurrencyModel> currencyModelList = [];
    Uri uri = Uri.parse(
        '$url&base_currency=$baseCurrency&currencies=$targetCurrency');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      Map<String, dynamic> body = json['data'];

      body.forEach((key, value) {
        CurrencyModel currencyModel =
            CurrencyModel(code: value['code'], value: value['value']);
        currencyModelList.add(currencyModel);
      });

      return currencyModelList;
    } else {
      return [];
    }
  }
}
