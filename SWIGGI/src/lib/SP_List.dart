import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Data.dart';
import 'P_Person.dart';

class SPList extends StatelessWidget {
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
  SPList({required this.selectedFirstName, required this.selectedLastName, required this.selectedMaidenName, required this.selectedGender, required this.selectedReligion, required this.selectedDateBirth, required this.selectedHouse, required this.selectedStreet, required this.selectedCity, required this.selectedCountry,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Show Person Search',
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
                          'Overview:',
                          'This page allows you to search for a person by specifying various criteria. Here\'s how to use it:',
                        ),
                        SizedBox(height: 10),
                        _buildListItem(
                          '- Each button represents a person with their relevant information.',
                          '',
                        ),
                        _buildListItem(
                          '- The "Number Correct Value" indicates the number of true values from the search query.',
                          '',
                        ),
                        _buildListItem(
                          '- The person\'s full name and the variables filled in the query are displayed.',
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
    List<Widget> listOfButtons = [];

    mergedTable.forEach((entry) {

      Person person = entry['person'] as Person;
      Religion religion = entry['religion'] as Religion;
      House house = entry['house'] as House;
      City city = entry['city'] as City;
      Country country = entry['country'] as Country;

      // --------------------------------------- define variable ---------------------------------------
      List<String> text = [];
      int count_correct = 0;
      // --------------------------------------- FirstName ---------------------------------------
      if (selectedFirstName != '') {
        text.add('First Name : ${person.firstName} ($selectedFirstName)' + checkAndAppendCorrectValue_string(person.firstName, selectedFirstName));
        count_correct += checkAndAppendCorrectValue_number(person.firstName, selectedFirstName);
      }
      // --------------------------------------- LastName ---------------------------------------
      if (selectedLastName != '') {
        text.add('Last Name : ${person.lastName} ($selectedLastName)' + checkAndAppendCorrectValue_string(person.lastName, selectedLastName));
        count_correct += checkAndAppendCorrectValue_number(person.lastName, selectedLastName);
      }
      // --------------------------------------- MaidenName ---------------------------------------
      if (selectedMaidenName != '') {
        text.add('Maiden Name : ${person.maidenName} ($selectedMaidenName)' + checkAndAppendCorrectValue_string(person.maidenName, selectedMaidenName));
        count_correct += checkAndAppendCorrectValue_number(person.maidenName, selectedMaidenName);
      }
      // --------------------------------------- Gender ---------------------------------------
      if (selectedGender != '') {
        String genderText = person.gender == 'M' ? 'Male' : 'Female';
        text.add('Gender : $genderText ($selectedGender)' + checkAndAppendCorrectValue_string(person.gender, selectedGender));
        count_correct += checkAndAppendCorrectValue_number(person.gender, selectedGender);
      }
      // --------------------------------------- Religion ---------------------------------------
      if (selectedReligion != '') {
        text.add('Religion : ${religion.religionName} ($selectedReligion)' + checkAndAppendCorrectValue_string(religion.religionName, selectedReligion));
        count_correct += checkAndAppendCorrectValue_number(religion.religionName, selectedReligion);
      }
      // --------------------------------------- Year Birth ---------------------------------------
      if (selectedDateBirth != '') {
        text.add('Year Birth : ${person.dateOfBirth?.year} ($selectedDateBirth)' + checkAndAppendCorrectValue_string(person.dateOfBirth!.year.toString(), selectedDateBirth));
        count_correct += checkAndAppendCorrectValue_number(person.dateOfBirth!.year.toString(), selectedDateBirth);
      }
      // --------------------------------------- House ---------------------------------------
      if (selectedHouse != '') {
        text.add('House Lived : ${house.houseNumber} ($selectedHouse)' + checkAndAppendCorrectValue_string(house.houseNumber.toString(), selectedHouse));
        count_correct += checkAndAppendCorrectValue_number(house.houseNumber.toString(), selectedHouse);
      }
      // --------------------------------------- Street ---------------------------------------
      if (selectedStreet != '') {
        text.add('Street Lived : ${house.streetName} ($selectedStreet)' + checkAndAppendCorrectValue_string(house.streetName, selectedStreet));
        count_correct += checkAndAppendCorrectValue_number(house.streetName, selectedStreet);
      }
      // --------------------------------------- City ---------------------------------------
      if (selectedCity != '') {
        text.add('City Lived : ${city.cityName} ($selectedCity)' + checkAndAppendCorrectValue_string(city.cityName, selectedCity));
        count_correct += checkAndAppendCorrectValue_number(city.cityName, selectedCity);
      }
      // --------------------------------------- Country ---------------------------------------
      if (selectedCountry != '') {
        text.add('Country Lived : ${country.countryName} ($selectedCountry)' + checkAndAppendCorrectValue_string(country.countryName, selectedCountry));
        count_correct += checkAndAppendCorrectValue_number(country.countryName, selectedCountry);
      }
      // --------------------------------------- FullName ---------------------------------------
      var FullName = (person.firstName ?? "") + ((person.maidenName ?? "").isNotEmpty ? " " + (person.maidenName ?? "") : "") + ((person.lastName ?? "").isNotEmpty ? " " + (person.lastName ?? "") : "");
      FullName = FullName.trim();
      // --------------------------------------- Create a Frames ---------------------------------------
      if (count_correct != 0) {
        listOfButtons.add(
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey), // Change border color to gray
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PPerson(person1: person, house1: house, city1: city, country1: country,),),);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.all(8.0),
                backgroundColor: Colors.grey,
              ),
              child: Column(
                children: [
                  Text(
                    'Number Correct Value : $count_correct \nFull Name : $FullName',
                    style: TextStyle(color : Colors.white,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: text.map((line) => Text(
                      line,
                      style: TextStyle(color : Colors.white,fontWeight: FontWeight.bold),
                    )).toList(),
                  ),
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

    // --------------------------------------- Return the lists ---------------------------------------
    // Return the top 10 buttons
    return listOfButtons.sublist(0, listOfButtons.length < 10 ? listOfButtons.length : 10);
  }
  String checkAndAppendCorrectValue_string(String? actualValue, String selectedValue) {if (actualValue == selectedValue) {return ' ✔️';} else {return ' ❌';}}
  int checkAndAppendCorrectValue_number(dynamic actualValue, String selectedValue) {if (actualValue == selectedValue) {return(1);} else {return(0);}}
  int getCountCorrectFromButton(Widget button) {
    if (button is Container) {
      TextButton textButton = (button.child as TextButton);
      Column column = (textButton.child as Column);
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
