import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:substring_highlight/substring_highlight.dart';

class AutocompleteSearchbarSearchPage extends StatefulWidget {
  final List<String> lessonsTitle;
  final Function(String) onSelectedCallback;
  final Function() onCleanCallback;
  const AutocompleteSearchbarSearchPage({
    super.key,
    required this.lessonsTitle,
    required this.onSelectedCallback,
    required this.onCleanCallback,
  });

  @override
  _AutocompleteSearchbarSearchPageState createState() =>
      _AutocompleteSearchbarSearchPageState();
}

class _AutocompleteSearchbarSearchPageState
    extends State<AutocompleteSearchbarSearchPage> {
  bool isLoading = false;

  late TextEditingController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Autocomplete(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<String>.empty();
              } else {
                return widget.lessonsTitle.where((word) => word
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
              widget.onSelectedCallback(selectedString);
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
                  hintText: "Search a lesson",
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: controller.text!=''?IconButton(
                      onPressed: () {
                        controller.clear();
                        widget.onCleanCallback();
                      },
                      icon: const Icon(
                        Icons.delete,
                      )):null
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
