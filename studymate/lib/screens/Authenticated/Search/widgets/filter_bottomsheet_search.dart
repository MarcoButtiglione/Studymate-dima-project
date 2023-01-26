import 'package:flutter/material.dart';

class FilterBottomsheetSearch extends StatelessWidget {
  const FilterBottomsheetSearch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const FlutterLogo(size: 120),
          const FlutterLogo(size: 120),
          const FlutterLogo(size: 120),
          ElevatedButton(
            child: const Text("Close"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
