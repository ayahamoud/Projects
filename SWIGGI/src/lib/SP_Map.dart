import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'Data.dart';
import 'P_Person.dart';

class SPMap extends StatelessWidget {
  final String selectedFirstName;
  final String selectedLastName;
  final String selectedMaidenName;
  final String selectedGender;
  final String selectedReligion;
  final String selectedDateBirth;
  final String selectedHouse;
  final String selectedStreet;
  final String selectedCity;
  final String selectedCountry;

  SPMap({
    required this.selectedFirstName,
    required this.selectedLastName,
    required this.selectedMaidenName,
    required this.selectedGender,
    required this.selectedReligion,
    required this.selectedDateBirth,
    required this.selectedHouse,
    required this.selectedStreet,
    required this.selectedCity,
    required this.selectedCountry,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> listOfTopPerson = buildListOfTopPerson(context);
    List<House> listOfHouses = buildListOfHouses(listOfTopPerson);

    // Check if houses list is not empty
    if (listOfHouses.isNotEmpty) {
      Set<Marker> markers = listOfHouses.map((house) {
        // Filter persons for the current house
        List<Map<String, dynamic>> personsByHome = listOfTopPerson.where((person) => person['house'] == house).toList();

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
          title: Text(
            'Person Search Map',
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
                          _buildSectionHeader('Person Search Page Help'),
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
                onMapCreated: (GoogleMapController controller) {},
              ),
            ),
          ],
        ),
      );
    } else {
      // Handle the case where houses list is empty
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Person Search Map',
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
  List<Map<String, dynamic>> buildListOfTopPerson(BuildContext context) {

    List<Map<String, dynamic>>  listOfTopPerson = [];

    mergedTable.forEach((entry) {

      Person person = entry['person'] as Person;
      Religion religion = entry['religion'] as Religion;
      House house = entry['house'] as House;
      City city = entry['city'] as City;
      Country country = entry['country'] as Country;
      Quarter quarter = entry['quarter'] as Quarter;

      // --------------------------------------- define variable ---------------------------------------
      int count_correct = 0;
      // --------------------------------------- FirstName ---------------------------------------
      if (selectedFirstName != '') {
        count_correct += checkAndAppendCorrectValue_number(person.firstName, selectedFirstName);
      }
      // --------------------------------------- LastName ---------------------------------------
      if (selectedLastName != '') {
        count_correct += checkAndAppendCorrectValue_number(person.lastName, selectedLastName);
      }
      // --------------------------------------- MaidenName ---------------------------------------
      if (selectedMaidenName != '') {
        count_correct += checkAndAppendCorrectValue_number(person.maidenName, selectedMaidenName);
      }
      // --------------------------------------- Gender ---------------------------------------
      if (selectedGender != '') {
        count_correct += checkAndAppendCorrectValue_number(person.gender, selectedGender);
      }
      // --------------------------------------- Religion ---------------------------------------
      if (selectedReligion != '') {
        count_correct += checkAndAppendCorrectValue_number(religion.religionName, selectedReligion);
      }
      // --------------------------------------- Year Birth ---------------------------------------
      if (selectedDateBirth != '') {
        count_correct += checkAndAppendCorrectValue_number(person.dateOfBirth!.year.toString(), selectedDateBirth);
      }
      // --------------------------------------- House ---------------------------------------
      if (selectedHouse != '') {
        count_correct += checkAndAppendCorrectValue_number(house.houseNumber.toString(), selectedHouse);
      }
      // --------------------------------------- Street ---------------------------------------
      if (selectedStreet != '') {
        count_correct += checkAndAppendCorrectValue_number(house.streetName, selectedStreet);
      }
      // --------------------------------------- City ---------------------------------------
      if (selectedCity != '') {
        count_correct += checkAndAppendCorrectValue_number(city.cityName, selectedCity);
      }
      // --------------------------------------- Country ---------------------------------------
      if (selectedCountry != '') {
        count_correct += checkAndAppendCorrectValue_number(country.countryName, selectedCountry);
      }
      // --------------------------------------- FullName ---------------------------------------
      var FullName = (person.firstName ?? "") + ((person.maidenName ?? "").isNotEmpty ? " " + (person.maidenName ?? "") : "") + ((person.lastName ?? "").isNotEmpty ? " " + (person.lastName ?? "") : "");
      FullName = FullName.trim();
      // --------------------------------------- Create a Frames ---------------------------------------
      if (count_correct != 0) {
        listOfTopPerson.add({'FullName':FullName,'religion':religion, 'person': person, 'house': house, 'quarter': quarter, 'city': city, 'country': country , 'count_correct' : count_correct});
      }
    });

    // Sorting the list by 'count_correct' in descending order
    listOfTopPerson.sort((a, b) => b['count_correct'].compareTo(a['count_correct']));

    // Returning only the top 10 entries
    return listOfTopPerson.take(10).toList();
  }
  int checkAndAppendCorrectValue_number(dynamic actualValue, String selectedValue) {if (actualValue == selectedValue) {return(1);} else {return(0);}}
  List<House> buildListOfHouses(List<Map<String, dynamic>> listOfTopPerson) {
    Set<House> uniqueHouses = Set<House>();

    for (Map<String, dynamic> entry in listOfTopPerson) {
      House house = entry['house'] as House;
      uniqueHouses.add(house);
    }

    // Convert the Set to a List if needed
    List<House> listOfHouses = uniqueHouses.toList();

    return listOfHouses;
  }
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
                    child: Text('${person['FullName']}', style: TextStyle(fontSize: 14, color: Colors.white)),
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