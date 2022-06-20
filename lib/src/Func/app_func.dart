import 'dart:convert';
import 'dart:io';
import 'package:app_direct/src/Model/country_model.dart';
import 'package:app_direct/src/pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

CountryData countryData = CountryData();

class CountryData with ChangeNotifier {
  static final CountryData _singleton = CountryData._internal();
  factory CountryData() => _singleton;
  CountryData._internal();

  String? defCountryCode;
  String? selectedCountryCode;
  List<Country> countries = [];
  int? mobileNo;
  bool searchHistory = false;
  String get msg => msgContrl.text;
  TextEditingController mobNoContrl = TextEditingController();
  TextEditingController msgContrl = TextEditingController();

  Country get selectedCountry => getCountry(selectedCountryCode);
  Country getCountry(String? code) {
    debugPrint('Getting Code for: ${code ?? defCountryCode ?? 'IN'}');
    return countries
        .firstWhere((e) => e.countryCode == (code ?? defCountryCode ?? 'IN'));
  }

  Future _loadCountries() async {
    await _loadSimCountryCode();
    if (countries.isEmpty) {
      String rawData =
          await rootBundle.loadString('assets/countryCode/country_codes.json');
      final parsed =
          json.decode(rawData.toString()).cast<Map<String, dynamic>>();
      countries =
          parsed.map<Country>((json) => Country.fromJson(json)).toList();
      countries.sort((a, b) => a.name.compareTo(b.name));
    }
    if (defCountryCode != null) {
      final country = getCountry(defCountryCode!);
      countries.removeWhere((e) => e.countryCode == defCountryCode!);
      countries.insert(0, country);
    }
  }

  Future _loadSimCountryCode() async {
    String locale = Platform.localeName;
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        defCountryCode ??= await FlutterSimCountryCode.simCountryCode;
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    defCountryCode ??= locale.split('_').last;
    selectedCountryCode ??= defCountryCode;
  }

  int ii = 0;
  void onChangeMobileNo(String text) {
    countries
        .sort((b, a) => a.callingCode.length.compareTo(b.callingCode.length));
    if (text.startsWith('+')) {
      final countryMatch = countries.firstWhere(
          (e) => text.startsWith(e.callingCode),
          orElse: () =>
              Country('India', 'flags/ind.png', defCountryCode ?? 'IN', '+91'));
      text = text.replaceFirst(countryMatch.callingCode, '');
      if (int.tryParse(text) != null) {
        if (ii < 2) {
          ii++;
          selectedCountryCode = countryMatch.countryCode;
          mobNoContrl.text = text;
        }
      }
    } else if (text.startsWith('0')) {
      text = text.replaceFirst('0', '');
    }
    mobileNo = int.tryParse(text);
  }

  String get fullMobileNo {
    if (mobileNo == null) return '';
    String cc = selectedCountry.callingCode;
    String mbNo = '$cc${mobileNo!}';
    return mbNo;
  }

  Future toWhatsApp(BuildContext context) async {
    if (fullMobileNo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Valid Mobile not Found to send Message')));
      return;
    }
    final mbNo = fullMobileNo.replaceFirst('+', '');
    String url = 'https://wa.me/$mbNo?text=$msg';
    debugPrint('url: $url');
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  Future lookForClip(BuildContext context, String textfrom) async {
    await _loadCountries();
    String clipText = textfrom.isNotEmpty
        ? textfrom
        : (await Clipboard.getData(Clipboard.kTextPlain))?.text ?? '';
    debugPrint('Text On Clip: $clipText | $textfrom<');
    clipText = getMatchingString(clipText);
    if (clipText.isNotEmpty) {
      onChangeMobileNo(clipText);
    }
    return clipText.isNotEmpty;
  }

  String getMatchingString(String clipText) {
    if (clipText.isNotEmpty) {
      clipText = clipText.replaceAll('-', '');
      clipText = clipText.replaceAll(' ', '');
      bool isMatchFound = RegExp(regEx).hasMatch(clipText);
      return isMatchFound ? clipText : '';
    }
    return '';
  }

  void updateSearch() {
    searchHistory = !searchHistory;
    notifyListeners();
  }
}

// +917708879071
// 07708879071
String regEx =
    '(9[976]\\d|8[987530]\\d|6[987]\\d|5[90]\\d|42\\d|3[875]\\d|2[98654321]\\'
    'd|9[8543210]|8[6421]|6[6543210]|5[87654321]|4[987654310]|3[9643210]|2[70]|7|1)\\d{1,14}\$';
// '\\+'