import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Filter;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:myapp/add/stalls_search_widget.dart';
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

  final _filterState = FilterState();
  final _stallsSearcher = HitsSearcher(
    applicationID: dotenv.env['ALGOLIA_APPLICATION_ID'] ?? '',
    apiKey: dotenv.env['ALGOLIA_API_KEY'] ?? '',
    indexName: 'stalls',
  );
  Stream<SearchResponse> get _searchResponses {
    return _stallsSearcher.responses;
  }

  String _stallDocId = '';
  bool _isNewStall = false;
  bool _isNewLocation = false;
  bool _isSubmitDisabled = false;

  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    _nameController.addListener(() {
      _locationController.clear();
      setState(() => _rating = 0);
      _nameController.text != ''
          ? _filterState.set({
              const FilterGroupID(): {
                Filter.facet(
                  'Name',
                  _nameController.text,
                )
              }
            })
          : _filterState.clear();
    });
    _stallsSearcher.connectFilterState(_filterState);
    super.initState();
  }

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
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: 'Stall Name',
                    helperText: _nameController.text == ''
                        ? 'Enter a stall name before selecting location and rating'
                        : '',
                    fillColor: const Color.fromARGB(50, 208, 210, 212),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == '') {
                      return 'Enter a stall name';
                    }
                  },
                  readOnly: true,
                  onTap: () async {
                    String? res = await showSearch(
                      context: context,
                      delegate: StallsSearchWidget(),
                      query: _nameController.text,
                    );

                    if (res == '' || res == null) {
                      return;
                    }
                    _nameController.text = res;
                  },
                ),
                StreamBuilder<SearchResponse>(
                  stream: _searchResponses,
                  builder: (context, snapshot) {
                    if (_nameController.text == '') {
                      return TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Location',
                          fillColor: Color.fromARGB(50, 208, 210, 212),
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == '') {
                            return 'Enter a location';
                          }
                        },
                        enabled: false,
                      );
                    } else if (_nameController.text != '' &&
                        snapshot.hasData &&
                        snapshot.data!.nbHits > 0) {
                      _stallDocId = snapshot.data!.hits[0]['objectID'];
                      _isNewStall = false;

                      String dropdownListFirstOption =
                          snapshot.data!.hits[0]['Locations'][0];
                      _locationController.text =
                          _isNewLocation ? '' : dropdownListFirstOption;

                      return Container(
                        child: _isNewLocation
                            ? TextFormField(
                                controller: _locationController,
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(),
                                  labelText: 'New Location',
                                  icon: IconButton(
                                    icon: const Icon(Icons.arrow_back),
                                    onPressed: () => setState(() {
                                      _isNewLocation = false;
                                    }),
                                  ),
                                  helperText:
                                      'Click "Back" to select from existing locations',
                                  fillColor:
                                      const Color.fromARGB(50, 208, 210, 212),
                                  filled: true,
                                ),
                                validator: (value) {
                                  if (value == '') {
                                    return 'Enter a location';
                                  }
                                },
                              )
                            : DropdownButtonFormField<String>(
                                value: dropdownListFirstOption,
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Location',
                                  helperText: 'Select location of stall',
                                  fillColor: Color.fromARGB(50, 208, 210, 212),
                                  filled: true,
                                ),
                                items: snapshot.data!.hits[0]['Locations']
                                    .map<DropdownMenuItem<String>>(
                                      (item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item),
                                      ),
                                    )
                                    .toList()
                                  ..add(
                                    DropdownMenuItem<String>(
                                      value: '',
                                      child: TextButton.icon(
                                        onPressed: () => setState(() {
                                          _isNewLocation = true;
                                        }),
                                        icon: Icon(Icons.add,
                                            color: Theme.of(context).hintColor),
                                        label: Text(
                                          'Create new stall',
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).hintColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                onChanged: (value) =>
                                    _locationController.text = value ?? ''),
                      );
                    } else if (_nameController.text != '' &&
                        snapshot.hasData &&
                        snapshot.data!.nbHits == 0) {
                      _isNewStall = true;
                      _isNewLocation = true;
                      _locationController.text = '';

                      return TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Location',
                          helperText: 'Enter location for new stall',
                          fillColor: Color.fromARGB(50, 208, 210, 212),
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == '') {
                            return 'Enter a location';
                          }
                        },
                      );
                    } else {
                      _isSubmitDisabled = true;

                      return TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Location',
                          helperText:
                              'An error occurred while searching for locations for this stall.',
                          fillColor: Color.fromARGB(50, 208, 210, 212),
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == '') {
                            return 'Enter a location';
                          }
                        },
                        enabled: false,
                      );
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
                        starColor: _nameController.text == ''
                            ? const Color.fromARGB(125, 208, 210, 212)
                            : Colors.yellow,
                        starOffColor: _nameController.text == ''
                            ? const Color.fromARGB(125, 208, 210, 212)
                            : const Color.fromARGB(255, 208, 210, 212),
                        starSize: 50,
                        value: field.value ?? 0,
                        onValueChanged: (value) {
                          if (_nameController.text == '') {
                            return;
                          }

                          field.didChange(value);
                          _rating = value;
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
                  enabled: _nameController.text != '',
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: _isSubmitDisabled
                        ? null
                        : () async {
                            if (!(_formState.currentState!.validate())) {
                              return;
                            }
                            _formState.currentState!.save();

                            User user = Auth().currentUser!;

                            await db.collection('users').doc(user.uid).set(
                              {},
                              SetOptions(merge: true),
                            ).then((_) {
                              if (_isNewStall) {
                                FutureGroup futureGroup = FutureGroup()
                                  ..add(db.collection('stalls').add(
                                    {
                                      'Name': _nameController.text,
                                      'Locations': [_locationController.text],
                                    },
                                  ))
                                  ..add(db
                                      .collection('reviews')
                                      .doc(
                                          '${_nameController.text}; ${_locationController.text}')
                                      .set({
                                    'Reviews': [
                                      {
                                        'Rating': _rating,
                                        'UserPath': 'users/${user.uid}',
                                        'Date Added': Timestamp.now(),
                                      }
                                    ],
                                  }));
                                futureGroup.close();
                                return futureGroup;
                              } else if (!_isNewStall && _isNewLocation) {
                                FutureGroup futureGroup = FutureGroup()
                                  ..add(db
                                      .collection('stalls')
                                      .doc(_stallDocId)
                                      .update(
                                    {
                                      'Locations': FieldValue.arrayUnion(
                                          [_locationController.text]),
                                    },
                                  ))
                                  ..add(db
                                      .collection('reviews')
                                      .doc(
                                          '${_nameController.text}; ${_locationController.text}')
                                      .set({
                                    'Reviews': [
                                      {
                                        'Rating': _rating,
                                        'UserPath': 'users/${user.uid}',
                                        'Date Added': Timestamp.now(),
                                      }
                                    ],
                                  }));
                                futureGroup.close();
                                return futureGroup;
                              } else if (!_isNewStall && !_isNewLocation) {
                                return db
                                    .collection('reviews')
                                    .doc(
                                        '${_nameController.text}; ${_locationController.text}')
                                    .update({
                                  'Reviews': FieldValue.arrayUnion([
                                    {
                                      'Rating': _rating,
                                      'UserPath': 'users/${user.uid}',
                                      'Date Added': Timestamp.now(),
                                    }
                                  ]),
                                });
                              }
                            }).then(
                              (_) {
                                String name = _nameController.text;
                                String location = _locationController.text;

                                _formState.currentState!.reset();
                                _nameController.clear();
                                _locationController.clear();
                                _rating = 0;
                                _stallDocId = '';
                                _isSubmitDisabled = false;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: _isNewStall
                                        ? Text('Added $name')
                                        : !_isNewStall && _isNewLocation
                                            ? Text('Added $location to $name')
                                            : Text(
                                                'Added new review for $name at $location'),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                _isNewLocation = false;
                                _isNewStall = false;
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
