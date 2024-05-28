import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'GL_House.dart';
import 'Data.dart';

class SHMap extends StatelessWidget {
  final String selectedStreet;
  final String selectedQuarter;
  final String selectedCity;
  final String selectedCountry;
  final String selectedHouse;
  final List<String>? selectedPersonList;

  SHMap({
    required this.selectedStreet,
    required this.selectedQuarter,
    required this.selectedCity,
    required this.selectedCountry,
    required this.selectedHouse,
    required this.selectedPersonList,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> listOfHouses = buildListOfHouses(context);

    // Check if houses list is not empty
    if (listOfHouses.isNotEmpty) {
      Set<Marker> markers = listOfHouses.map((DataHouse) {

        return Marker(
          markerId: MarkerId(DataHouse['house'].houseId.toString()),
          position: LatLng(DataHouse['house'].gpsCoordsX, DataHouse['house'].gpsCoordsY),
          infoWindow: InfoWindow(
            title: 'House ${DataHouse['house'].houseNumber}-${DataHouse['house'].streetName}',
            snippet: 'Press To See House Page',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => GLHouse(house1: DataHouse['house'],city1: DataHouse['city'], country1: DataHouse['country']),),);
            },
          ),
        );
      }).toSet();
      return Scaffold(
        appBar: AppBar(
          title:  Text('House Search Map',
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
                          _buildSectionHeader('House Search Page Help'),
                          SizedBox(height: 10),
                          _buildListItem(
                            'Viewing Houses on Google Map:',
                            'In this page, you can view a Google Map showing the houses lived. Each marker on the map represents a house.',
                          ),
                          SizedBox(height: 10),
                          _buildListItem(
                            'Clicking on a Marker:',
                            'Clicking on a marker will display a window containing the name of the house.',
                          ),
                          SizedBox(height: 10),
                          _buildListItem(
                            'Viewing House Details:',
                            'Clicking on the window it will take you to the House page.',
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
                  target: LatLng(listOfHouses.first['house'].gpsCoordsX, listOfHouses.first['house'].gpsCoordsY),
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
      // Handle the case where houses list is empty
      return Scaffold(
        appBar: AppBar(
          title:  Text('House Search Map',
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

  List<Map<String, dynamic>> buildListOfHouses(BuildContext context) {
    // Extract unique street names from mergedTable
    Set<String> uniqueStreetNamesHouseNumber = Set<String>.from(mergedTable.map((entry) => "${entry['house'].houseNumber}-${entry['house'].streetName}"));

    // Create a list to store the buttons
    List<Map<String, dynamic>>  listOfTopHouse = [];

    // Iterate over unique street names
    uniqueStreetNamesHouseNumber.forEach((StreetNamesHouseNumber) {

      List<String> parts = StreetNamesHouseNumber.split('-');
      String streetName = parts[1];
      int houseNumber = int.tryParse(parts[0]) ?? 0; // Use 0 if parsing fails

      int count_correct = 0;
      final List<Map<String, dynamic>> entriesStreet =
      mergedTable.where((entry) => (entry['house'].streetName == streetName && entry['house'].houseNumber == houseNumber)).toList();

      // list of names without duplicates
      List<String> personsNames = entriesStreet.map((entryStreet) {
        final Person person = entryStreet['person'] as Person;
        String name = "${person?.firstName ?? ''} ${person?.maidenName ?? ''} ${person?.lastName ?? ''}";
        return name;
      }).toSet().toList();

      for (String? person in selectedPersonList ?? []) {
        if (person != null && personsNames?.contains(person) == true) {
          count_correct++;
        }
      }

      final entry = mergedTable.firstWhere((entry) => entry['house'].streetName == streetName, orElse: () => Map<String, dynamic>(),);
      final quarter = entry['quarter'];
      final city = entry['city'];
      final country = entry['country'];
      final house = entry['house'];

      if (selectedHouse == houseNumber.toString()) count_correct++;
      if (selectedStreet == streetName) count_correct++;
      if (selectedCity == city.cityName) count_correct++;
      if (selectedQuarter == '${quarter.quarterName} ${quarter.quarterNumber}') count_correct++;
      if (selectedCountry == country.countryName) count_correct++;

      if (count_correct != 0) {
        listOfTopHouse.add({'house': house, 'quarter': quarter, 'city': city, 'country': country , 'count_correct' : count_correct});
      }
    });

    // Sorting the list by 'count_correct' in descending order
    listOfTopHouse.sort((a, b) => b['count_correct'].compareTo(a['count_correct']));

    // Returning only the top 10 entries
    return listOfTopHouse.take(10).toList();
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
