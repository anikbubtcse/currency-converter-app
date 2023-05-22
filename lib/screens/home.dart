import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_picker_dropdown.dart';
import 'package:country_currency_pickers/utils/utils.dart';
import 'package:currency_converter_app/service/currency_model_service.dart';
import 'package:flutter/material.dart';

import '../model/currency_model.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _selectedCurrency = "USD";
  ApiService _apiService = ApiService();

  Widget _buildCurrencyDropdownItem(Country country) => Container(
        child: Row(
          children: [
            CountryPickerUtils.getDefaultFlagImage(country),
            const SizedBox(
              width: 8,
            ),
            Text("${country.currencyCode}"),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          const Text(
            "Base Currency",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: CountryPickerDropdown(
              initialValue: 'us',
              itemBuilder: _buildCurrencyDropdownItem,
              onValuePicked: (Country? country) {
                setState(() {
                  _selectedCurrency = country?.currencyCode ?? "";
                });
              },
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            "All Currency",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          const SizedBox(
            height: 8,
          ),
          FutureBuilder(
              future: _apiService.getLatest(_selectedCurrency),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: (CircularProgressIndicator(
                    color: Colors.white,
                  )));
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error occured"),
                  );
                }

                if (snapshot.hasData) {
                  List<CurrencyModel> currencyModel = snapshot.data ?? [];
                  return Expanded(
                      child: ListView.builder(
                          itemCount: currencyModel.length,
                          itemBuilder: (contex, index) {
                            return Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.blue.withAlpha(90),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(currencyModel[index].code.toString(),
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 17)),
                                  Text(
                                      currencyModel[index]
                                          .value!
                                          .toStringAsFixed(2)
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 17)),
                                ],
                              ),
                            );
                          }));
                }

                return Container();
              })
        ],
      ),
    );
  }
}
