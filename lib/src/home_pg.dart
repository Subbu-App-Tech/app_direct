import 'package:app_direct/src/action_button.dart';
import 'package:app_direct/src/Func/app_func.dart';
import 'package:app_direct/src/country_dropdown.dart';
import 'package:app_direct/src/msg_history_list.dart';
import 'package:app_direct/src/Func/storags.dart';
import 'package:flutter/material.dart';

class HomePg extends StatelessWidget {
  const HomePg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future getDatas() async {
      countryData.lookForClip(context);
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
                    countryData.msg = msg;
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
