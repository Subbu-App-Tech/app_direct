import 'package:app_direct/src/action_button.dart';
import 'package:app_direct/src/Func/app_func.dart';
import 'package:app_direct/src/country_dropdown.dart';
import 'package:app_direct/src/msg_history_list.dart';
import 'package:app_direct/src/Func/storags.dart';
import 'package:app_direct/src/pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:text_process/text_process.dart';
import 'package:external_app_launcher/external_app_launcher.dart';

class HomePg extends StatefulWidget {
  const HomePg({Key? key}) : super(key: key);

  @override
  State<HomePg> createState() => _HomePgState();
}

class _HomePgState extends State<HomePg> {
  late final Stream<String> _processText;
  @override
  void initState() {
    TextProcess.initialize(
        showConfirmationToast: false,
        showErrorToast: true,
        errorMessage: "Some Error");
    _processText = TextProcess.getProcessTextStream;
    _processText.listen((event) {
      debugPrint('\n-\nEvent => $event\n=\n');
      String matchStr = countryData.getMatchingString(event);
      if (matchStr.isNotEmpty) {
        textfrom = event;
        LaunchApp.openApp(androidPackageName: 'com.subbu.app_direct');
        setState(() {});
      }
    });
    super.initState();
  }

  String textfrom = '';
  @override
  Widget build(BuildContext context) {
    Future getDatas() async {
      // ignore: use_build_context_synchronously
      final isMatchFound = await countryData.lookForClip(context, textfrom);
      if (isMatchFound && countryData.mobileNo != null) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          showMobNoInClip(context, '${countryData.mobileNo}', textfrom.isEmpty);
        });
      }

      await storage.init();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('WhatsApp Direct')),
      body: FutureBuilder(
          future: getDatas(),
          builder: (context, snapshot) {
            return snapshot.connectionState != ConnectionState.done
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                        MobileNoTextField(),
                        Expanded(child: StoredClipsListWidgets())
                      ]);
          }),
    );
  }
}

class MobileNoTextField extends StatelessWidget {
  const MobileNoTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey pinButton = GlobalKey();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextField(
                  enableSuggestions: true,
                  controller: countryData.mobNoContrl,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: CountryCodeDropDown(),
                      labelText: 'Phone Number'),
                  onChanged: countryData.onChangeMobileNo),
              const SizedBox(height: 10),
              TextField(
                  enableSuggestions: true,
                  controller: countryData.msgContrl,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Message'),
                  onChanged: (msg) {
                    // ignore: invalid_use_of_protected_member
                    pinButton.currentState?.setState(() {});
                  },
                  maxLines: 4),
              const SizedBox(height: 10),
              Row(
                children: [
                  PinButton(key: pinButton),
                  const Spacer(),
                  ElevatedButton.icon(
                      onPressed: () => countryData.toWhatsApp(context),
                      icon: const Icon(Icons.whatsapp),
                      label: const Text('Send')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
