import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OwnProfilePage extends StatefulWidget {
  @override
  State<OwnProfilePage> createState() => _OwnProfilePageState();
}

class _OwnProfilePageState extends State<OwnProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Profile details", style: TextStyle(fontSize: 35)),
              const SizedBox(height: 50),
              Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: const Image(
                        image: NetworkImage(
                            'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80'),
                      ),
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.photo_camera),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          builder: (context) => Container(
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
                          ),
                        );
                      },
                      style: IconButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        disabledBackgroundColor: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.12),
                        hoverColor: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withOpacity(0.08),
                        focusColor: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withOpacity(0.12),
                        highlightColor: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withOpacity(0.12),
                      )),
                ],
              ),
              const SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      enabled: false,
                      initialValue: 'Daniel',
                      decoration: InputDecoration(
                        labelText: "First name",
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
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      enabled: false,
                      initialValue: 'Rogers',
                      decoration: InputDecoration(
                        labelText: "Last name",
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
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Row(children: const <Widget>[
                Text("Modify your interests",
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
