import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Row(children: const <Widget>[
              Text("Welcome",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 30),
            Row(children: const <Widget>[
              Text("Yourn next lesson",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ]),
            Row(
              children: <Widget>[
                const Expanded(flex: 9, child: NextFilledCardExample()),
                Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("1"),
                            SizedBox(width: 10),
                            Icon(
                              Icons.remove_red_eye,
                              color: Colors.grey,
                              size: 25.0,
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("1"),
                            SizedBox(width: 10),
                            Icon(
                              Icons.star,
                              color: Colors.grey,
                              size: 25.0,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.mode,
                                color: Colors.grey,
                                size: 25.0,
                              ),
                              onPressed: () {
                                //
                              },
                            ),
                          ],
                        ),
                      ],
                    )),
              ],
            ),
            const Divider(
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            Row(children: const <Widget>[
              Text("Saved lessons",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 10),
            SizedBox(
              height: 100.0,
              child:
                  ListView(scrollDirection: Axis.horizontal, children: const [
                SmallFilledCardExample(),
                SmallFilledCardExample(),
                SmallFilledCardExample(),
                SmallFilledCardExample(),
                SmallFilledCardExample(),
                SmallFilledCardExample(),
                SmallFilledCardExample(),
                SmallFilledCardExample(),
                SmallFilledCardExample(),
                SmallFilledCardExample(),
                SmallFilledCardExample(),
              ]),
            ),
            const SizedBox(height: 20),
            const Divider(
              color: Colors.grey,
            ),
            const SizedBox(height: 30),
            Row(children: const <Widget>[
              Text("Suggested for you",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 10),
            const Text(
                "This is a list of possible lessons who you may find interesting.",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 13)),
            const SizedBox(height: 30),
            Row(children: const <Widget>[
              Expanded(child: FilledCardExample()),
              Expanded(child: FilledCardExample()),
            ]),
            Row(children: const <Widget>[
              Expanded(child: FilledCardExample()),
              Expanded(child: FilledCardExample()),
            ]),
            Row(children: const <Widget>[
              Expanded(child: FilledCardExample()),
              Expanded(child: FilledCardExample()),
            ]),
          ],
        ),
      ),
    );
  }
}

class FilledCardExample extends StatelessWidget {
  const FilledCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: const SizedBox(
          height: 300,
          child: Center(child: Text('Filled Card')),
        ),
      ),
    );
  }
}

class NextFilledCardExample extends StatelessWidget {
  const NextFilledCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: const SizedBox(
          height: 100,
          child: Center(child: Text('Filled Card')),
        ),
      ),
    );
  }
}

class SmallFilledCardExample extends StatelessWidget {
  const SmallFilledCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: const SizedBox(
          height: 90,
          width: 90,
        ),
      ),
    );
  }
}
