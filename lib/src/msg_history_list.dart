import 'package:app_direct/src/Func/app_func.dart';
import 'package:app_direct/src/Func/storags.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StoredClipsListWidgets extends StatefulWidget {
  const StoredClipsListWidgets({Key? key}) : super(key: key);

  @override
  State<StoredClipsListWidgets> createState() => _StoredClipsListWidgetsState();
}

class _StoredClipsListWidgetsState extends State<StoredClipsListWidgets> {
  String searchTxt = '';
  bool isSearchEnable = false;
  @override
  void initState() {
    storage.addListener(() {
      if (mounted) setState(() {});
    });
    countryData.msgContrl.addListener(() {
      if (isSearchEnable) {
        searchTxt = countryData.msgContrl.text;
        setState(() {});
      }
    });
    countryData.addListener(() {
      if (isSearchEnable != countryData.searchHistory) {
        isSearchEnable = countryData.searchHistory;
        searchTxt = countryData.msgContrl.text;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = isSearchEnable
        ? storage.data
            .where(
                (e) => e.text.toLowerCase().contains(searchTxt.toLowerCase()))
            .toList()
        : storage.data;
    return ReorderableListView.builder(
      shrinkWrap: true,
      itemCount: data.length,
      restorationId: 'RID',
      buildDefaultDragHandles: false,
      onReorder: (oldIdx, newIdx) {
        setState(() {
          storage.changeInIndex(oldIdx, newIdx);
        });
      },
      itemBuilder: (context, i) {
        return Container(
          key: ValueKey(data[i].key),
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(4)),
          child: Row(
            children: [
              ReorderableDragStartListener(
                  index: i, child: const Card(child: Icon(Icons.drag_handle))),
              Expanded(
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 10, 10, 5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            data[i].text,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy hh:mm a')
                                .format(data[i].date),
                            textAlign: TextAlign.right,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ]),
                  ),
                  onTap: () {
                    countryData.msgContrl.text = data[i].text;
                  },
                ),
              ),
              InkWell(
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.delete, color: Colors.red),
                ),
                onTap: () async {
                  await storage.deleteClip(data[i]);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
