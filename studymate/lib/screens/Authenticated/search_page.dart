import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:substring_highlight/substring_highlight.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(children: <Widget>[
              const Expanded(
                flex: 9,
                child: Text("Search",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              IconButton(
                icon: const Icon(
                  Icons.tune,
                  color: Colors.grey,
                  size: 25.0,
                ),
                onPressed: () {
                  //
                },
              ),
            ]),
            AutocompleteSearch(),
            const SizedBox(height: 20),
            Row(children: const <Widget>[
              Text("Categories",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ]),
            SizedBox(
              height: 150.0,
              child:
                  ListView(scrollDirection: Axis.horizontal, children: const [
                CategoryCard(),
                CategoryCard(),
                CategoryCard(),
                CategoryCard(),
                CategoryCard(),
                CategoryCard(),
                CategoryCard(),
                CategoryCard(),
                CategoryCard(),
                CategoryCard(),
                CategoryCard(),
              ]),
            ),
            const SizedBox(height: 20),
            const Divider(
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            Row(children: const <Widget>[
              Text("Recent",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 30),
            const RecentItem(),
            const SizedBox(height: 15),
            const RecentItem(),
            const SizedBox(height: 15),
            const RecentItem(),
            const SizedBox(height: 15),
            const RecentItem(),
            const SizedBox(height: 15),
            const RecentItem(),

          ],
        ),
      ),
    );
  }
}

class AutocompleteSearch extends StatefulWidget {
  @override
  _AutocompleteSearchState createState() => _AutocompleteSearchState();
}

class _AutocompleteSearchState extends State<AutocompleteSearch> {
  bool isLoading = false;

  late List<String> autoCompleteData;

  late TextEditingController controller;

  Future fetchAutoCompleteData() async {
    setState(() {
      isLoading = true;
    });

    final String stringData = await rootBundle.loadString("assets/data.json");

    final List<dynamic> json = jsonDecode(stringData);

    final List<String> jsonStringData = json.cast<String>();

    setState(() {
      isLoading = false;
      autoCompleteData = jsonStringData;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAutoCompleteData();
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
                  hintText: "Search a lesson or a tutor",
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

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: const SizedBox(
          height: 150,
          width: 100,
        ),
      ),
    );
  }
}

class RecentItem extends StatelessWidget {
  const RecentItem({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("Tapped on container");
      },
      child: Row(
        children: [
          SizedBox(
            height: 70,
            width: 70,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: const Image(
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80'),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: const [
                    Text(
                      "Machine Learning",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: const [
                    Text("Thursday 26/01/2023, Milan"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}