import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'P_Person.dart';
import 'Data.dart';

class SFList extends StatelessWidget {
  final String selectedFamilyName;
  final List<String>? selectedCitys;
  final List<String>? selectedHouses;
  final List<String>? selectedStreets;
  final List<String>? selectedPersons;

  SFList({
    required this.selectedFamilyName,
    required this.selectedCitys,
    required this.selectedHouses,
    required this.selectedStreets,
    required this.selectedPersons,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Show Family Search',
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
                          'Overview:',
                          'This page allows you to search for a Family by specifying various criteria. Here\'s how to use it:',
                        ),
                        SizedBox(height: 10),
                        _buildListItem(
                          '- Each button represents a Family with their relevant information.',
                          '',
                        ),
                        _buildListItem(
                          '- The "Number Correct Value" indicates the number of true values from the search query.',
                          '',
                        ),
                        _buildListItem(
                          '- The Family\'s name and the variables filled in the query are displayed.',
                          '',
                        ),
                        _buildListItem(
                          '- When a button is clicked, a window appears containing buttons for each person in the family.',
                          '',
                        ),
                        _buildListItem(
                          '- Clicking a button navigates to a page displaying detailed information about that person.',
                          '',
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Feel free to explore and use the various features available!',
                          style: TextStyle(fontStyle: FontStyle.italic),
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/poland_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                ...buildListOfButtons(context),
                SizedBox(height: 1000),
              ],
            ),
          ),
        ),
      ),
    );
  }
  List<Widget> buildListOfButtons(BuildContext context) {
    // Extract unique street names from mergedTable
    Set<String> uniqueFamilyNames = Set<String>.from(mergedTable.map((entry) => entry['person'].lastName));

    // Create a list to store the buttons
    List<Widget> listOfButtons = [];

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
          personWidgets.add(Text('Person: $person ✔️', style: TextStyle(color : Colors.white,fontWeight: FontWeight.bold)));
          count_correct++;
        } else {
          personWidgets.add(Text('Person: $person ❌', style: TextStyle(color : Colors.white,fontWeight: FontWeight.bold)));
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
          HouseWidgets.add(Text('House: $house ✔️', style: TextStyle(color : Colors.white,fontWeight: FontWeight.bold)));
          count_correct++;
        } else {
          HouseWidgets.add(Text('House: $house ❌', style: TextStyle(color : Colors.white,fontWeight: FontWeight.bold)));
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
          StreetWidgets.add(Text('Street: $street ✔️', style: TextStyle(color : Colors.white,fontWeight: FontWeight.bold)));
          count_correct++;
        } else {
          StreetWidgets.add(Text('Street: $street ❌', style: TextStyle(color : Colors.white,fontWeight: FontWeight.bold)));
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
          CitysWidgets.add(Text('City: $city ✔️', style: TextStyle(color : Colors.white,fontWeight: FontWeight.bold)));
          count_correct++;
        } else {
          CitysWidgets.add(Text('City: $city ❌', style: TextStyle(color : Colors.white,fontWeight: FontWeight.bold)));
        }
      }
      // -------------------------------------------- Family --------------------------------------------
      if (selectedFamilyName == FamilyName) count_correct++;

      if (count_correct != 0) {
        listOfButtons.add(
          Container(
            margin: EdgeInsets.only(bottom: 16.0),
            child: ElevatedButton(
              onPressed: () {
                showInfoWindow(context, FamilyName);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.grey, // Background color
                onPrimary: Colors.white, // Text color
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Number Correct Value : $count_correct',
                    style: TextStyle(
                      color : Colors.white,
                      fontWeight: FontWeight.bold, // Bold text
                    ),
                  ),
                  Text('The Family Name: $FamilyName'),

                  if (selectedFamilyName != '')
                    if (selectedFamilyName == FamilyName)
                      Text('Family Name: $FamilyName ($selectedFamilyName) ✔️', style: TextStyle(color : Colors.white,fontWeight: FontWeight.bold))
                    else
                      Text('Family Name: $FamilyName ($selectedFamilyName) ❌', style: TextStyle(color : Colors.white,fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  for (Widget widget in CitysWidgets) ...[widget],
                  SizedBox(height: 8),
                  for (Widget widget in StreetWidgets) ...[widget],
                  SizedBox(height: 8),
                  for (Widget widget in HouseWidgets) ...[widget],
                  SizedBox(height: 8),
                  for (Widget widget in personWidgets) ...[widget],
                ],
              ),
            ),
          ),
        );
      }
    });

    // Sort the listOfButtons by count_correct
    listOfButtons.sort((a, b) {
      int countCorrectA = getCountCorrectFromButton(a);
      int countCorrectB = getCountCorrectFromButton(b);
      return countCorrectB.compareTo(countCorrectA);
    });

    // Return the top 10 buttons
    return listOfButtons.sublist(0, listOfButtons.length < 10 ? listOfButtons.length : 10);
  }
  int getCountCorrectFromButton(Widget button) {
    if (button is Container) {
      ElevatedButton elevatedButton = (button.child as ElevatedButton);
      Column column = (elevatedButton.child as Column);
      List<String> textDataList = column.children
          .whereType<Text>()
          .map((textWidget) => textWidget.data ?? '')
          .toList();

      String buttonText = textDataList.join(' ');
      RegExpMatch? match = RegExp(r'Number Correct Value : (\d+)').firstMatch(buttonText);

      if (match != null) {
        return int.parse(match.group(1) ?? '0');
      }
    }

    return 0;
  }
  void showInfoWindow(BuildContext context, String familyname) {
    final List<Map<String, dynamic>> entriesFamily = mergedTable.where((entry) => entry['person'].lastName == familyname).toList();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey, // Background color of the window
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Persons: (Press To See Person Page)', style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                // Display each person's information
                for (var entry in entriesFamily)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PPerson(
                            person1: entry['person'] as Person,
                            house1: entry['house'] as House,
                            city1: entry['city'] as City,
                            country1: entry['country'] as Country,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey, // Background color of the button
                    ),
                    child: Text('${(entry['person'].firstName ?? "") + ((entry['person'].maidenName ?? "").isNotEmpty ? " " + (entry['person'].maidenName ?? "") : "") + ((entry['person'].lastName ?? "").isNotEmpty ? " " + (entry['person'].lastName ?? "") : "")}', style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold)),
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