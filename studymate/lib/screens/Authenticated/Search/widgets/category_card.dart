import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final String url;
  const CategoryCard({super.key, required this.name, required this.url});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: SizedBox(
              height: 150,
              width: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  fit: BoxFit.cover,
                  image: NetworkImage(url),
                ),
              ),
            ),
          ),
          Text(name, style: TextStyle(fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}
