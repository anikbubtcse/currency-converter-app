import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_picker_dropdown.dart';
import 'package:country_currency_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import '../model/currency_model.dart';
import '../service/currency_model_service.dart';

class Exchange extends StatefulWidget {
  @override
  State<Exchange> createState() => _ExchangeState();
}

class _ExchangeState extends State<Exchange> {
  String _selectedBaseCurrency = 'USD';
  String _selectedTargetCurrency = 'GBP';
  List<CurrencyModel> currencyModel = [];
  String _exchangeRate = '';
  ApiService _apiService = ApiService();
  bool isVisible = false;
  TextEditingController _textController = TextEditingController();

  getExhangeData() async {
    currencyModel = await _apiService.getExhange(
        _selectedBaseCurrency, _selectedTargetCurrency);
    if (currencyModel.isNotEmpty) {
      isVisible = true;
      double value = double.parse(_textController.text.toString());
      double exchangeRate = double.parse(currencyModel[0].value.toString());
      double total = value * exchangeRate;

      _exchangeRate = total.toStringAsFixed(2).toString();
      setState(() {});
    }
  }

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
        child: Column(children: [
      const SizedBox(
        height: 8,
      ),
      const Align(
        alignment: Alignment.center,
        child: Text(
          "Base Currency",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
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
              _selectedBaseCurrency = country?.currencyCode ?? "";
            });
          },
        ),
      ),
      const SizedBox(
        height: 8,
      ),
      SizedBox(
        width: 250,
        height: 50,
        child: TextField(
          controller: _textController,
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize: 20),
          decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none)),
        ),
      ),
      const SizedBox(
        height: 15,
      ),
      const Text(
        "Target Currency",
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
          initialValue: 'GB',
          itemBuilder: _buildCurrencyDropdownItem,
          onValuePicked: (Country? country) {
            setState(() {
              isVisible = false;
              _selectedTargetCurrency = country?.currencyCode ?? "";
            });
          },
        ),
      ),
      const SizedBox(
        height: 8,
      ),
      ElevatedButton(
          onPressed: () => getExhangeData(), child: Text('EXCHANGE')),
      const SizedBox(
        height: 15,
      ),
      if (isVisible)
        Text(
          _exchangeRate + " " + _selectedTargetCurrency,
          style: const TextStyle(fontSize: 60, color: Colors.greenAccent),
        )
    ]));
  }
}
