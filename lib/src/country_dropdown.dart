import 'package:app_direct/src/Func/app_func.dart';
import 'package:app_direct/src/Model/country_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CountryCodeDropDown extends StatefulWidget {
  const CountryCodeDropDown({Key? key}) : super(key: key);

  @override
  State<CountryCodeDropDown> createState() => _CountryCodeDropDownState();
}

class _CountryCodeDropDownState extends State<CountryCodeDropDown> {
  @override
  Widget build(BuildContext context) {
    Widget getSelectedCountry() {
      final selec = countryData.selectedCountry;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Image.asset('assets/${selec.flag}', width: 30),
          const SizedBox(width: 6),
          Text(selec.callingCode)
        ]),
      );
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
          isDense: false,
          customButton: getSelectedCountry(),
          isExpanded: false,
          dropdownWidth: 350,
          itemHeight: 40,
          items: countryData.countries
              .map((e) => DropdownMenuItem(
                  value: e.countryCode, child: CountryListTile(country: e)))
              .toList(),
          value: null,
          onChanged: (v) {
            if (v == null) return;
            setState(() => countryData.selectedCountryCode = v);
          }),
    );
  }
}

class CountryListTile extends StatelessWidget {
  final Country country;
  const CountryListTile({Key? key, required this.country}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/${country.flag}', width: 30),
          SizedBox(
            width: 60,
            child: Text(country.callingCode,
                textAlign: TextAlign.right,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(country.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}
