import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'GL_Street.dart';
import 'Data.dart';
import 'dart:math';

class SSMap extends StatelessWidget {
  final String selectedStreet;
  final String selectedQuarter;
  final String selectedCity;
  final String selectedCountry;
  final List<String>? selectedHouseList;
  final List<String>? selectedPersonList;
  SSMap({required this.selectedStreet, required this.selectedQuarter, required this.selectedCity, required this.selectedCountry, required this.selectedHouseList, required this.selectedPersonList,});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> listOfTopStreet = buildListOfTopStreet(context);
    Set<Marker> markers = {};

    if (listOfTopStreet.isNotEmpty) {
      // Predefined list of colors for streets
      List<Color> streetColors = [
        Colors.blue,
        Colors.red,
        Colors.green,
        Colors.orange,
        Colors.purple,
        Colors.yellow,
        Colors.teal,
        Colors.indigo,
        Colors.cyan,
        Colors.pink,
      ];

      // Map to associate each street with a color
      Map<String, Color> streetColorMap = {};

      markers = listOfTopStreet
          .map((street) {
        String currentStreetName = street['house'].streetName;

        // Assign a color to the current street if not assigned
        streetColorMap.putIfAbsent(
            currentStreetName, () => streetColors[streetColorMap.length % streetColors.length]);

        // Filter houses for the current street
        List<House> housesByStreet = houses
            .where((house1) => house1.streetName == currentStreetName)
            .toList();

        // Create markers for each house on the street with assigned color
        return housesByStreet.map((house1) {
          return Marker(
            markerId: MarkerId(house1.houseId.toString()),
            position: LatLng(house1.gpsCoordsX, house1.gpsCoordsY),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              _getHueFromColor(streetColorMap[currentStreetName]),
            ),
            infoWindow: InfoWindow(
              title: 'House ${house1.houseNumber}-${house1.streetName}',
              snippet: 'Press To See Street page',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GLStreet(
                      city1: street['city'],
                      country1: street['country'],
                      house1: house1,
                    ),
                  ),
                );
              },
            ),
          );
        }).toSet();
      })
          .expand((markers) => markers)
          .toSet();
    }

    if (listOfTopStreet.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title:  Text('Street Search Map',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.grey,
          actions: [
            IconButton(
              icon: Icon(Icons.help_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('How to Use This Page'),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader('Street Search Page Help'),
                          SizedBox(height: 10),
                          _buildListItem(
                            'Viewing Houses on Google Map:',
                            'In this page, you can view a Google Map showing the houses lived. Each marker on the map represents a house. Each color on the map represents a different street',
                          ),
                          SizedBox(height: 10),
                          _buildListItem(
                            'Clicking on a Marker:',
                            'Clicking on a marker will display a window containing the name of the house.',
                          ),
                          SizedBox(height: 10),
                          _buildListItem(
                            'Viewing House Details:',
                            'Clicking on the window it will take you to the Street page. ',
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'images/poland_background.jpg',
                fit: BoxFit.cover,
              ),
            ),
            // Introductory title
            Positioned(
              top: 0,
              left: -5,
              right: -5,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Embark on a journey through history as you explore our interactive map, discovering the poignant legacies of Holocaust survivors. Gain insight into their experiences, reflect on the enduring lessons of tolerance, and connect with the past through geographical representation.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            // Google Map
            Positioned(
              top: 200,
              left: 10,
              right: 10,
              bottom: 10,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    listOfTopStreet.first['house'].gpsCoordsX,
                    listOfTopStreet.first['house'].gpsCoordsY,
                  ),
                  zoom: 15.0,
                ),
                markers: markers,
                onMapCreated: (GoogleMapController controller) {
                  // Do something with the controller if needed
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title:  Text('Street Search Map',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.grey,
        ),
        body: Center(
          child: Text('No houses available to display on the map.'),
        ),
      );
    }
  }
  double _getHueFromColor(Color? color) {
    if (color != null) {
      HSVColor hsvColor = HSVColor.fromColor(color);
      return hsvColor.hue;
    } else {
      // Default hue value, you can change it as needed
      return 0.0;
    }
  }
  Color generateRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
  List<Map<String, dynamic>> buildListOfTopStreet (BuildContext context) {
    // Extract unique street names from mergedTable
    Set<String> uniqueStreetNames = Set<String>.from(mergedTable.map((entry) => entry['house'].streetName));

    List<Map<String, dynamic>>  listOfTopStreet = [];

    // Iterate over unique street names
    uniqueStreetNames.forEach((streetName) {
      int count_correct = 0;
      final List<Map<String, dynamic>> entriesStreet = mergedTable.where((entry) => entry['house'].streetName == streetName).toList();

      // list of names without duplicates
      List<String> personsNames = entriesStreet.map((entryStreet) {
        final Person person = entryStreet['person'] as Person;
        String name = "${person?.firstName ?? ''} ${person?.maidenName ?? ''} ${person?.lastName ?? ''}";
        return name;
      }).toSet().toList();

      // list of houses without duplicates
      List<String> Houses_numbers = entriesStreet.map((entryStreet) {
        final House house = entryStreet['house'] as House;
        String num = '${house.houseNumber}';
        return num;
      }).toSet().toList();

      for (String? house in selectedHouseList?? []) {if (Houses_numbers.contains(house)) {count_correct++;} else {}}
      for (String? person in selectedPersonList?? []) {if (personsNames.contains(person)) {count_correct++;} else {}}

      final entry = mergedTable.firstWhere((entry) => entry['house'].streetName == streetName, orElse: () => Map<String, dynamic>(),);
      final quarter = entry['quarter'];
      final city = entry['city'];
      final country = entry['country'];
      final house = entry['house'];

      if (selectedStreet == streetName) count_correct++;
      if (selectedCity == city.cityName) count_correct++;
      if (selectedQuarter == '${quarter.quarterName} ${quarter.quarterNumber}') count_correct++;
      if (selectedCountry == country.countryName) count_correct++;

      if (count_correct != 0) {
        listOfTopStreet.add({'house': house, 'quarter': quarter, 'city': city, 'country': country , 'count_correct' : count_correct});
      }
    });

    // Sorting the list by 'count_correct' in descending order
    listOfTopStreet.sort((a, b) => b['count_correct'].compareTo(a['count_correct']));

    // Returning only the top 10 entries
    return listOfTopStreet.take(10).toList();
  }
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
  Widget _buildListItem(String title, String description) {
    return ListTile(
      title: Text(title),
      subtitle: Text(description),
    );
  }
}
