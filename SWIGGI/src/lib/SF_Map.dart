import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'Data.dart';
import 'P_Person.dart';

class SFMap extends StatelessWidget {
  final String selectedFamilyName;
  final List<String>? selectedCitys;
  final List<String>? selectedHouses;
  final List<String>? selectedStreets;
  final List<String>? selectedPersons;

  SFMap({
    required this.selectedFamilyName,
    required this.selectedCitys,
    required this.selectedHouses,
    required this.selectedStreets,
    required this.selectedPersons,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> listOfFamilys = buildListOfFamilys(context);
    List<Map<String, dynamic>> listOfPersons = buildListOfPersons(listOfFamilys);
    List<House> listOfHouses = buildListOfHouses(listOfPersons);

    // Check if houses list is not empty
    if (listOfHouses.isNotEmpty) {
      Set<Marker> markers = listOfHouses.map((house) {
        // Filter persons for the current house
        List<Map<String, dynamic>> personsByHome = listOfPersons.where((person) => person['house'] == house).toList();

        return Marker(
          markerId: MarkerId(house.houseId.toString()),
          position: LatLng(house.gpsCoordsX, house.gpsCoordsY),
          infoWindow: InfoWindow(
            title: 'House ${house.houseNumber}-${house.streetName}',
            snippet: 'Press To See All Data',
            onTap: () {
              showInfoWindow(context, house, personsByHome);
            },
          ),
        );
      }).toSet();
      return Scaffold(
        appBar: AppBar(
          title:  Text('Family Search Map',
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
                          _buildSectionHeader('Family Search Page Help'),
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
                            'Clicking on the window will show another window with the house number, street name, and a list of people who lived in this house.',
                          ),
                          SizedBox(height: 10),
                          _buildListItem(
                            'Navigating to Person Page:',
                            'If you click on the button, it will take you to the person page.',
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
                  target: LatLng(listOfHouses.first.gpsCoordsX, listOfHouses.first.gpsCoordsY),
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
          title:  Text('Person Search Map',
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
  // -------------------------------------------- list of Names --------------------------------------------
  List<Map<String, dynamic>> buildListOfFamilys(BuildContext context) {
    // Extract unique street names from mergedTable
    Set<String> uniqueFamilyNames = Set<String>.from(mergedTable.map((entry) => entry['person'].lastName));

    // Create a list to store the buttons
    List<Map<String, dynamic>>  listOfFamilys = [];

    // Iterate over unique street names
    uniqueFamilyNames.forEach((FamilyName) {
      int count_correct = 0;
      //----------------------------------------------------------------------------------
      // take the rows by last name equal FamilyName
      final List<Map<String, dynamic>> entriesFamily = mergedTable.where((entry) => entry['person'].lastName == FamilyName).toList();
      // -------------------------------------------- Person --------------------------------------------
      // list of names without duplicates
      List<String> personsNames = entriesFamily.map((entryFamily) {
        final Person person = entryFamily['person'] as Person;
        String name = "${person?.firstName ?? ''} ${person?.maidenName ?? ''} ${person?.lastName ?? ''}";
        return name;
      }).toSet().toList();

      List<Widget> personWidgets = [];
      for (String? person in selectedPersons?? []) {
        if (personsNames.contains(person)) {
          count_correct++;
        }
      }
      // -------------------------------------------- House --------------------------------------------
      // list of houses without duplicates
      List<String> Houses_numbers = entriesFamily.map((entryFamily) {
        final House house = entryFamily['house'] as House;
        String num = '${house.houseNumber}';
        return num;
      }).toSet().toList();

      List<Widget> HouseWidgets = [];
      for (String? house in selectedHouses?? []) {
        if (Houses_numbers.contains(house)) {
          count_correct++;
        }
      }
      // -------------------------------------------- Street --------------------------------------------
      // list of Streets without duplicates
      List<String> Streets_name = entriesFamily.map((entryFamily) {
        final House house = entryFamily['house'] as House;
        String name = '${house.streetName}';
        return name;
      }).toSet().toList();

      List<Widget> StreetWidgets = [];
      for (String? street in selectedStreets?? []) {
        if (Streets_name.contains(street)) {
          count_correct++;
        }
      }
      // -------------------------------------------- City --------------------------------------------
      // list of Streets without duplicates
      List<String> Citys_name = entriesFamily.map((entryFamily) {
        final City city = entryFamily['city'] as City;
        String name = '${city.cityName}';
        return name;
      }).toSet().toList();

      List<Widget> CitysWidgets = [];
      for (String? city in selectedCitys?? []) {
        if (Citys_name.contains(city)) {
          count_correct++;
        }
      }
      // -------------------------------------------- Family --------------------------------------------
      if (selectedFamilyName == FamilyName) count_correct++;

      if (count_correct != 0) {
        listOfFamilys.add({"familyName": FamilyName , "count_correct":count_correct});
      }
    });

    // Sorting the list by 'count_correct' in descending order
    listOfFamilys.sort((a, b) => b['count_correct'].compareTo(a['count_correct']));

    // Returning only the top 10 entries
    return listOfFamilys.take(10).toList();
  }
  List<Map<String, dynamic>> buildListOfPersons(List<Map<String, dynamic>> ListOfFamilys){
    // Create a list to store the buttons
    List<Map<String, dynamic>>  listOfPersons = [];

    ListOfFamilys.forEach((Family) {
      mergedTable.forEach((itemRow) {
        String lastName = itemRow['person'].lastName;
        if (lastName == Family['familyName']) {
          listOfPersons.add(itemRow);
        }
      });
    });
    return(listOfPersons);
  }
  List<House> buildListOfHouses(List<Map<String, dynamic>> ListOfPersons) {
    Set<House> uniqueHouses = Set<House>();
    for (Map<String, dynamic> entry in ListOfPersons) {
      House house = entry['house'] as House;
      uniqueHouses.add(house);
    }
    // Convert the Set to a List if needed
    List<House> listOfHouses = uniqueHouses.toList();
    return listOfHouses;
  }
  int checkAndAppendCorrectValue_number(dynamic actualValue, String selectedValue) {
    if (actualValue == selectedValue) {return(1);} else {return(0);}}
  void showInfoWindow(BuildContext context, House house, List<Map<String, dynamic>> personsByHome) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.grey, // Set background color to gray
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('House ${house.houseNumber}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 5),
                Text('Street: ${house.streetName}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 10),
                Text('Persons: (Press To See Person Page)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                // Display each person's information
                for (var person in personsByHome)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PPerson(
                            person1: person['person'],
                            house1: person['house'],
                            city1: person['city'],
                            country1: person['country'],
                          ),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.grey), // Set button background color to gray
                    ),
                    child: Text('${person['person'].firstName} ${person['person'].maidenName != null ? '${person['person'].maidenName}' : ''} ${person['person'].lastName}', style: TextStyle(fontSize: 14,color: Colors.white)),
                  ),
              ],
            ),
          ),
        );
      },
    );
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
