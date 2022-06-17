import 'package:app_direct/src/Func/app_func.dart';
import 'package:flutter/material.dart';

void showMobNoInClip(BuildContext context, String mobileNo) async {
  showDialog(
      context: context,
      builder: (c) {
        return MobileNoinClipPop(mobileNo: mobileNo);
      });
}

class MobileNoinClipPop extends StatelessWidget {
  final String mobileNo;
  const MobileNoinClipPop({Key? key, required this.mobileNo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(8),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(width: 7),
          const Text('Number Found'),
          const Spacer(),
          IconButton(
              color: Colors.red,
              padding: const EdgeInsets.all(5),
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.cancel))
        ],
      ),
      content: Text('Number: $mobileNo'),
      actions: [
        ElevatedButton.icon(
            onPressed: () {
              countryData.mobNoContrl.text = mobileNo;
              Navigator.pop(context);
            },
            icon: const Icon(Icons.note_alt_sharp),
            label: const Text('Paste')),
        ElevatedButton.icon(
            onPressed: () {
              countryData.toWhatsApp(context);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.whatsapp_sharp),
            label: const Text('Open Chat')),
      ],
    );
  }
}
