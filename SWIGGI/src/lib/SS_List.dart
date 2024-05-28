import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'GL_Street.dart';
import 'Data.dart';

class SSList extends StatelessWidget {
  final String selectedStreet;
  final String selectedQuarter;
  final String selectedCity;
  final String selectedCountry;
  final List<String>? selectedHouseList;
  final List<String>? selectedPersonList;

  SSList({
    required this.selectedStreet,
    required this.selectedQuarter,
    required this.selectedCity,
    required this.selectedCountry,
    required this.selectedHouseList,
    required this.selectedPersonList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Show Street Search',
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
                          'Overview:',
                          'This page allows you to search for a Street by specifying various criteria. Here\'s how to use it:',
                        ),
                        SizedBox(height: 10),
                        _buildListItem(
                          '- Each button represents a Street with their relevant information.',
                          '',
                        ),
                        _buildListItem(
                          '- The "Number Correct Value" indicates the number of true values from the search query.',
                          '',
                        ),
                        _buildListItem(
                          '- The Street\'s name and the variables filled in the query are displayed.',
                          '',
                        ),
                        _buildListItem(
                          '- Clicking a button navigates to a page displaying detailed information about that Street.',
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
    Set<String> uniqueStreetNames = Set<String>.from(mergedTable.map((entry) => entry['house'].streetName));

    // Create a list to store the buttons
    List<Widget> listOfButtons = [];

    // Iterate over unique street names
    uniqueStreetNames.forEach((streetName) {
      int count_correct = 0;
      final List<Map<String, dynamic>> entriesStreet =
      mergedTable.where((entry) => entry['house'].streetName == streetName).toList();

      // list of names without duplicates
      List<String> personsNames = entriesStreet.map((entryStreet) {
        final Person person = entryStreet['person'] as Person;
        String name =
            "${person?.firstName ?? ''} ${person?.maidenName ?? ''} ${person?.lastName ?? ''}";
        return name;
      }).toSet().toList();

      // list of houses without duplicates
      List<String> Houses_numbers = entriesStreet.map((entryStreet) {
        final House house = entryStreet['house'] as House;
        String num = '${house.houseNumber}';
        return num;
      }).toSet().toList();

      List<Widget> houseWidgets = [];
      for (String? house in selectedHouseList?? []) {
        if (Houses_numbers.contains(house)) {
          houseWidgets.add(Text('House: $house ✔️', style: TextStyle(color : Colors.white,fontWeight: FontWeight.bold)));
          count_correct++;
        } else {
          houseWidgets.add(Text('House: $house ❌', style: TextStyle(color : Colors.white,fontWeight: FontWeight.bold)));
        }
      }

      List<Widget> personWidgets = [];
      for (String? person in selectedPersonList?? []) {
        if (personsNames.contains(person)) {
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

      if (selectedStreet == streetName) count_correct++;
      if (selectedCity == city.cityName) count_correct++;
      if (selectedQuarter == '${quarter.quarterName} ${quarter.quarterNumber}')
        count_correct++;
      if (selectedCountry == country.countryName) count_correct++;

      if (count_correct != 0) {
        listOfButtons.add(
          Container(
            margin: EdgeInsets.only(bottom: 16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => GLStreet(city1: city, country1: country,house1: house),),);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.grey, // Background color
                onPrimary: Colors.white, // Text color
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Number Correct Value : $count_correct', style: TextStyle(color : Colors.white,fontWeight: FontWeight.bold)),
                  Text('The street Name: $streetName', style: TextStyle(color : Colors.white,fontWeight: FontWeight.bold)),

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
                  for (Widget widget in houseWidgets) ...[widget],
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
