import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:myapp/onboarding/auth.dart';

class AddWidget extends StatefulWidget {
  const AddWidget({Key? key}) : super(key: key);

  @override
  State<AddWidget> createState() => AddWidgetState();
}

class AddWidgetState extends State<AddWidget> {
  final _formState = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  double _rating = 0;

  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formState,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 500,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "Stall Name",
                    fillColor: Color.fromARGB(50, 208, 210, 212),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == '') {
                      return 'Enter a stall name';
                    }
                  },
                ),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "Location",
                    fillColor: Color.fromARGB(50, 208, 210, 212),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == '') {
                      return 'Enter a location';
                    }
                  },
                ),
                FormField<double>(
                  builder: (field) => Align(
                    alignment: Alignment.centerLeft,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: '    Rating',
                        errorText: field.errorText == null
                            ? null
                            : '    ${field.errorText}',
                        errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      child: RatingStars(
                        starBuilder: (index, color) => Icon(
                          Icons.star,
                          color: color,
                          size: 40,
                        ),
                        starColor: Colors.yellow,
                        starOffColor: const Color.fromARGB(255, 208, 210, 212),
                        starSize: 50,
                        value: field.value ?? 0,
                        onValueChanged: (value) {
                          field.didChange(value);
                          setState(() => _rating = value);
                        },
                        valueLabelVisibility: false,
                      ),
                    ),
                  ),
                  initialValue: 0,
                  validator: (value) {
                    if (value == 0) {
                      return 'Give a rating';
                    }
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!(_formState.currentState!.validate())) {
                        return;
                      }

                      _formState.currentState!.save();

                      User user = Auth().currentUser!;

                      db
                          .collection('users')
                          .doc(user.uid)
                          .set(
                            {},
                            SetOptions(merge: true),
                          )
                          .then(
                            (_) => db.collection('stalls').add(
                              {
                                'Name': _nameController.text,
                                'Location': _locationController.text,
                                'Rating': _rating.toInt(),
                              },
                            ),
                          )
                          .then(
                            (_) {
                              String name = _nameController.text;

                              _formState.currentState!.reset();
                              _nameController.clear();
                              _locationController.clear();
                              _rating = 0;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Added $name'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                          );
                    },
                    child: const Text("Submit"),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
