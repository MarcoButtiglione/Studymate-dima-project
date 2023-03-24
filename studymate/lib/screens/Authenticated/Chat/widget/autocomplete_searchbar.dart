import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:substring_highlight/substring_highlight.dart';

import '../../../../models/user.dart';

class AutocompleteSearchbar extends StatefulWidget {
  final List<Users> users;

  const AutocompleteSearchbar({super.key, required this.users});
  @override
  _AutocompleteSearchbarState createState() => _AutocompleteSearchbarState();
}

class _AutocompleteSearchbarState extends State<AutocompleteSearchbar> {
  bool isLoading = false;

  late List<String> autoCompleteData;

  late TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    widget.users.forEach(
      (element) =>
          autoCompleteData.add("${element.firstname} ${element.lastname}"),
    );
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Autocomplete(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<String>.empty();
              } else {
                return autoCompleteData.where((word) => word
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()));
              }
            },
            optionsViewBuilder:
                (context, Function(String) onSelected, options) {
              return Material(
                elevation: 4,
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final option = options.elementAt(index);
                    return ListTile(
                      // title: Text(option.toString()),
                      title: SubstringHighlight(
                        text: option.toString(),
                        term: controller.text,
                        textStyleHighlight:
                            TextStyle(fontWeight: FontWeight.w700),
                      ),
                      //subtitle: Text("This is subtitle"),
                      onTap: () {
                        onSelected(option.toString());
                      },
                    );
                  },
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: options.length,
                ),
              );
            },
            onSelected: (selectedString) {
              print(selectedString);
            },
            fieldViewBuilder:
                (context, controller, focusNode, onEditingComplete) {
              this.controller = controller;

              return TextField(
                controller: controller,
                focusNode: focusNode,
                onEditingComplete: onEditingComplete,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
