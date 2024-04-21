import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StallsSearchWidget extends SearchDelegate<String> {
  final _stallsSearcher = HitsSearcher(
    applicationID: dotenv.env['ALGOLIA_APPLICATION_ID'] ?? '',
    apiKey: dotenv.env['ALGOLIA_API_KEY'] ?? '',
    indexName: 'stalls',
  );
  // final Uri _placesApiUri =
  //     Uri.parse('https://places.googleapis.com/v1/places:autocomplete');

  Stream<SearchResponse> get searchResponses {
    return _stallsSearcher.responses;
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query == '') {
      return const SizedBox.shrink();
    }
    _stallsSearcher.query(query);

    // Future<http.Response> placesApiResponse = http.post(_placesApiUri, body: {
    //   'input': query,
    //   'languageCode': 'en',
    //   'includedRegionCodes': 'sg'
    // }, headers: {
    //   'X-Goog-Api-key': dotenv.env['PLACES_API_KEY']!
    // });

    // return FutureBuilder<http.Response>(
    //     future: placesApiResponse,
    //     builder: ((context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return const LinearProgressIndicator();
    //       } else if (snapshot.hasData) {
    //         final json = jsonDecode(snapshot.data!.body);
    //         print((const JsonEncoder.withIndent('  '))
    //             .convert(json)); // pretty print
    //         final List<Map<String, dynamic>> suggestions;
    //         switch (json) {
    //           case ({'suggestions': List placePrediction}):
    //             suggestions = placePrediction.map((suggestion) {
    //               final nameLocation =
    //                   suggestion['placePrediction']['text']['text'];
    //               final name = suggestion['placePrediction']['structuredFormat']
    //                   ['mainText']['text'];
    //               final location = suggestion['placePrediction']
    //                   ['structuredFormat']['secondaryText']['text'];
    //               return {
    //                 'nameLocation': nameLocation,
    //                 'name': name,
    //                 'location': location
    //               };
    //             }).toList();
    //           default:
    //             throw 'Unexpected JSON format';
    //         }
    //         return ListView.builder(
    //           itemBuilder: (context, index) => ListTile(
    //             title: Text(suggestions[index]['nameLocation']),
    //             // title: index < names.length
    //             // ? Text(names[index])
    //             // : Align(
    //             //     alignment: Alignment.centerLeft,
    //             //     child: TextButton.icon(
    //             //       icon: Icon(
    //             //         Icons.add,
    //             //         color: Theme.of(context).hintColor,
    //             //       ),
    //             //       label: Text(
    //             //         'Create new stall',
    //             //         style: TextStyle(color: Theme.of(context).hintColor),
    //             //       ),
    //             //       onPressed: () => close(context, query),
    //             //     ),
    //             //   ),
    //             onTap: () {
    //               close(context, '');
    //             },
    //             shape: Border(
    //               bottom: BorderSide(color: Theme.of(context).dividerColor),
    //             ),
    //           ),
    //           itemCount: suggestions.length,
    //         );
    //       } else {
    //         print(snapshot.error);
    //         return const Text('An error has occurred.');
    //       }
    //     }));

    return StreamBuilder<SearchResponse>(
      // We will put the api call here
      stream: searchResponses,
      builder: (context, snapshot) {
        // print(snapshot);
        // print(snapshot.data?.nbHits ?? '0 hits');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator();
        } else if (snapshot.hasData && snapshot.data!.nbHits > 0) {
          List<String> names =
              snapshot.data!.hits.map<String>((item) => item['Name']).toList();
          return ListView.builder(
            itemBuilder: (context, index) => ListTile(
              // we will display the data returned from our future here
              title: index < names.length
                  ? Text(names[index])
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).hintColor,
                        ),
                        label: Text(
                          'Create new stall',
                          style: TextStyle(color: Theme.of(context).hintColor),
                        ),
                        onPressed: () => close(context, query),
                      ),
                    ),
              onTap: () {
                close(context, names[index]);
              },
              shape: Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            itemCount: names.length + 1,
          );
        } else if (snapshot.hasData && snapshot.data!.nbHits == 0) {
          return ListView(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).hintColor,
                  ),
                  label: Text(
                    'Create new stall',
                    style: TextStyle(color: Theme.of(context).hintColor),
                  ),
                  onPressed: () => close(context, query),
                ),
              ),
            ],
          );
        } else {
          print(snapshot.error);
          return const Text('An error has occurred.');
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // return an empty widget
    return const SizedBox.shrink();
  }

  @override
  void showResults(BuildContext context) {
    super.showSuggestions(context);
  }
}
