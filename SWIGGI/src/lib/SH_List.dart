import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'GL_House.dart';
import 'Data.dart';

class SHList extends StatelessWidget {
  final String selectedStreet;
  final String selectedQuarter;
  final String selectedCity;
  final String selectedCountry;
  final String selectedHouse;
  final List<String>? selectedPersonList;

  SHList({
    required this.selectedStreet,
    required this.selectedQuarter,
    required this.selectedCity,
    required this.selectedCountry,
    required this.selectedHouse,
    required this.selectedPersonList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Show House Search',
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
                          'Overview:',
                          'This page allows you to search for a House by specifying various criteria. Here\'s how to use it:',
                        ),
                        SizedBox(height: 10),
                        _buildListItem(
                          '- Each button represents a House with their relevant information.',
                          '',
                        ),
                        _buildListItem(
                          '- The "Number Correct Value" indicates the number of true values from the search query.',
                          '',
                        ),
                        _buildListItem(
                          '- The House\'s name and the variables filled in the query are displayed.',
                          '',
                        ),
                        _buildListItem(
                          '- Clicking a button navigates to a page displaying detailed information about that House.',
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
    Set<String> uniqueStreetNamesHouseNumber = Set<String>.from(mergedTable.map((entry) => "${entry['house'].houseNumber}-${entry['house'].streetName}"));

    // Create a list to store the buttons
    List<Widget> listOfButtons = [];

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


      List<Widget> personWidgets = [];
      for (String? person in selectedPersonList ?? []) {
        if (person != null && personsNames.contains(person)) {
          personWidgets.add(Text('Person: $person ✔️', style: TextStyle(color : Colors.white,fontWeight: FontWeight.bold)));
          count_correct++;
        } else {
          personWidgets.add(Text('Person: $person ❌', style: TextStyle(color : Colors.white,fontWeight: FontWeight.bold)));
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
        listOfButtons.add(
          Container(
            margin: EdgeInsets.only(bottom: 16.0),
            color: Colors.grey, // Background color of the container
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => GLHouse(house1: house,city1: city, country1: country),),);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.grey, // Background color of the button
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
                  Text('The House : $houseNumber-$streetName'),

                  if (selectedHouse != '')
                    if (selectedHouse == houseNumber.toString())
                      Text('House Number: $houseNumber ($selectedHouse) ✔️', style: TextStyle(color : Colors.white,fontWeight: FontWeight.bold))
                    else
                      Text('House Number: $houseNumber ($selectedHouse) ❌', style: TextStyle(color : Colors.white,fontWeight: FontWeight.bold)),

                  if (selectedStreet != '')
                    if (selectedStreet == streetName)
                      Text('Street Name: $streetName ($selectedStreet) ✔️', style: TextStyle(color : Colors.white,fontWeight: FontWeight.bold))
                    else
                      Text('Street Name: $streetName ($selectedStreet) ❌', style: TextStyle(color : Colors.white,fontWeight: FontWeight.bold)),

                  if (selectedCity != '')
                    if (selectedCity == city.cityName)
                      Text('City Name: ${city.cityName} ($selectedCity) ✔️', style: TextStyle(color : Colors.white,fontWeight: FontWeight.bold))
                    else
                      Text('City Name: ${city.cityName} ($selectedCity) ❌', style: TextStyle(color : Colors.white,fontWeight: FontWeight.bold)),

                  if (selectedQuarter != '')
                    if (selectedQuarter ==
                        '${quarter.quarterName} ${quarter.quarterNumber}')
                      Text(
                          'Quarter: ${quarter.quarterName} ${quarter.quarterNumber} ($selectedQuarter) ✔️', style: TextStyle(color : Colors.white,fontWeight: FontWeight.bold))
                    else
                      Text(
                          'Quarter: ${quarter.quarterName} ${quarter.quarterNumber} ($selectedQuarter) ❌', style: TextStyle(color : Colors.white,fontWeight: FontWeight.bold)),

                  if (selectedCountry != '')
                    if (selectedCountry == country.countryName)
                      Text(
                          'Country Name: ${country.countryName} ($selectedCountry) ✔️', style: TextStyle(color : Colors.white,fontWeight: FontWeight.bold))
                    else
                      Text(
                          'Country Name: ${country.countryName} ($selectedCountry) ❌', style: TextStyle(color : Colors.white,fontWeight: FontWeight.bold)),

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
