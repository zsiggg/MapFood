import 'package:flutter/material.dart';

class AddWidget extends StatefulWidget {
  const AddWidget({Key? key}) : super(key: key);

  @override
  State<AddWidget> createState() => AddWidgetState();
}

class AddWidgetState extends State<AddWidget> {
  final _formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formState,
      child: SizedBox(
        width: 200,
        height: 300,
        child: Container(
          padding: const EdgeInsets.only(left: 20, top: 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Stall Name",
                  ),
                  validator: (value) {
                    if (value != "abc") {
                      return "Field must be exactly 'abc'";
                    }
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Location",
                  ),
                  validator: (value) {
                    if (value != "abc") {
                      return "Field must be exactly 'abc'";
                    }
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Rating out of 5",
                  ),
                  validator: (value) {
                    if (value != "abc") {
                      return "Field must be exactly 'abc'";
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formState.currentState!.validate()) {
                      // display message in snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sending data to firebase'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  child: const Text("Submit"),
                ),
              ]),
        ),
      ),
    );
  }
}
