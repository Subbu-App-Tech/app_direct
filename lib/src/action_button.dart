import 'package:app_direct/src/Func/app_func.dart';
import 'package:app_direct/src/Func/storags.dart';
import 'package:flutter/material.dart';

class PinButton extends StatefulWidget {
  const PinButton({Key? key}) : super(key: key);

  @override
  State<PinButton> createState() => _PinButtonState();
}

class _PinButtonState extends State<PinButton> {
  bool isSearchEnables = false;
  @override
  void initState() {
    storage.addListener(() => setState(() {}));
    countryData.addListener(() {
      if (isSearchEnables != countryData.searchHistory) {
        isSearchEnables = countryData.searchHistory;
        if (mounted) setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isExist = storage.isExist(countryData.msg);
    return Row(
      children: [
        IconButton(
          icon: Icon(
              isSearchEnables ? Icons.search_off_sharp : Icons.manage_search),
          onPressed: () {
            countryData.updateSearch();
          },
        ),
        ElevatedButton.icon(
            onPressed: isExist
                ? null
                : () async {
                    await storage.saveClipText(StorageClipModel(
                        text: countryData.msg.trim(),
                        mobileNo: countryData.fullMobileNo));
                  },
            icon: RotationTransition(
                turns: const AlwaysStoppedAnimation(46 / 360),
                child: Icon(
                    isExist ? Icons.push_pin_sharp : Icons.push_pin_outlined)),
            label: const Text('Pin')),
      ],
    );
  }
}
