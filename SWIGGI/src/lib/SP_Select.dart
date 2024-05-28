import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Data.dart';
import 'Common_Functions.dart';
import 'SP_List.dart';
import 'SP_Map.dart';

class SPSelect extends StatefulWidget {
  @override
  _SPSelectState createState() => _SPSelectState();
}

class _SPSelectState extends State<SPSelect> {
  String selectedFirstName = '';
  String selectedLastName = '';
  String selectedMaidenName = '';
  String selectedGender = '';
  String selectedReligion = '';
  String selectedDateBirth = '';
  String selectedHouse = '';
  String selectedStreet = '';
  String selectedCity = '';
  String selectedCountry = '';

  late List<String> FirstNameList;
  late List<String> LastNameList;
  late List<String> MaidenNameList;
  late List<String> GenderList;
  late List<String> ReligionList;
  late List<String> dateOfBirthList;
  late List<String> houseNumberList;
  late List<String> StreetList;
  late List<String> CityList;
  late List<String> CountryList;

  void initState() {
    super.initState();

    FirstNameList = mergedTable.map<String?>((entry) => entry['person'].firstName as String?).where((value) => value != null).toList().cast<String>().toSet().toList();
    LastNameList = mergedTable.map<String?>((entry) => entry['person'].lastName as String?).where((value) => value != null).toList().cast<String>().toSet().toList();
    MaidenNameList = mergedTable.map<String?>((entry) => entry['person'].maidenName as String?).where((value) => value != null).toList().cast<String>().toSet().toList();
    GenderList = mergedTable.map<String?>((entry) => entry['person'].gender as String?).where((value) => value != null).toList().cast<String>().toSet().toList();
    ReligionList = mergedTable.map<String?>((entry) => entry['religion'].religionName as String?).where((value) => value != null).toList().cast<String>().toSet().toList();
    dateOfBirthList = mergedTable.map<DateTime?>((entry) => entry['person']?.dateOfBirth as DateTime?).where((value) => value != null).map<String>((date) => date?.year.toString() ?? '').toSet().toList();
    houseNumberList = mergedTable.map<String?>((entry) => (entry['house']?.houseNumber as int?)?.toString()).where((value) => value != null).toList().cast<String>().toSet().toList();
    StreetList = mergedTable.map<String?>((entry) => entry['house'].streetName as String?).where((value) => value != null).toList().cast<String>().toSet().toList();
    CityList = mergedTable.map<String?>((entry) => entry['city'].cityName as String?).where((value) => value != null).toList().cast<String>().toSet().toList();
    CountryList = mergedTable.map<String?>((entry) => entry['country'].countryName as String?).where((value) => value != null).toList().cast<String>().toSet().toList();

    FirstNameList.sort(compareWithEmpty);
    LastNameList.sort(compareWithEmpty);
    MaidenNameList.sort(compareWithEmpty);
    GenderList.sort(compareWithEmpty);
    ReligionList.sort(compareWithEmpty);
    dateOfBirthList.sort();
    houseNumberList.sort(compareWithEmpty);
    StreetList.sort(compareWithEmpty);
    CityList.sort(compareWithEmpty);
    CountryList.sort(compareWithEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Person Search Page',
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
                        Text(
                          'This page allows you to search for a person by specifying various criteria. Here\'s how to use it:',
                        ),
                        SizedBox(height: 10),
                        _buildList([
                          _buildListItem('Choose one option for each search criterion from the provided dropdown lists.', ''),
                          _buildListItem('You can leave some criteria blank if you do not want to specify them in your search.', ''),
                          _buildListItem('Once you have selected the desired criteria, press the "Search" button to perform the search.', ''),
                          _buildListItem('At least one field must be filled to perform a search.', ''),
                          _buildListItem('You can view the matching people in two ways:', ''),
                          _buildListItem('1. Through a list: Shows the 10 most relevant people in a list from most relevant to least relevant.', ''),
                          _buildListItem('2. Through a map: Shows the 10 most relevant people on a map, without any specific arrangement.', ''),
                        ]),
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'images/poland_background.jpg', // Replace with your image path
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ------------------------------------------- First Name -------------------------------------------
                  DropdownFrameSingle(
                    label: 'First Name',
                    selectedValue: selectedFirstName,
                    itemList: FirstNameList,
                    onChanged: (String? value) {
                      setState(() {
                        selectedFirstName = value ?? '';
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  // ------------------------------------------- Last Name -------------------------------------------
                  DropdownFrameSingle(
                    label: 'Last Name',
                    selectedValue: selectedLastName,
                    itemList: LastNameList,
                    onChanged: (String? value) {
                      setState(() {
                        selectedLastName = value ?? '';
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  // ------------------------------------------- Maiden Name -------------------------------------------
                  DropdownFrameSingle(
                    label: 'Maiden Name',
                    selectedValue: selectedMaidenName,
                    itemList: MaidenNameList,
                    onChanged: (String? value) {
                      setState(() {
                        selectedMaidenName = value ?? '';
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  // ------------------------------------------- Gender -------------------------------------------
                  DropdownFrameSingle(
                    label: 'Gender',
                    selectedValue: selectedGender,
                    itemList: GenderList,
                    onChanged: (String? value) {
                      setState(() {
                        selectedGender = value ?? '';
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  // ------------------------------------------- Religion -------------------------------------------
                  DropdownFrameSingle(
                    label: 'Religion',
                    selectedValue: selectedReligion,
                    itemList: ReligionList,
                    onChanged: (String? value) {
                      setState(() {
                        selectedReligion = value ?? '';
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  // ------------------------------------------- Year of Birth -------------------------------------------
                  DropdownFrameSingle(
                    label: 'Year of Birth',
                    selectedValue: selectedDateBirth,
                    itemList: dateOfBirthList, // Ensure the type is List<String?>
                    onChanged: (String? value) {
                      setState(() {
                        selectedDateBirth = value ?? '';
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  // ------------------------------------------- House Lived -------------------------------------------
                  DropdownFrameSingle(
                    label: 'House Lived',
                    selectedValue: selectedHouse,
                    itemList: houseNumberList.map((String? value) => value?.toString()).toList().cast<String>(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedHouse = value ?? '';
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  // ------------------------------------------- Street Lived -------------------------------------------
                  DropdownFrameSingle(
                    label: 'Street Lived',
                    selectedValue: selectedStreet,
                    itemList: StreetList,
                    onChanged: (String? value) {
                      setState(() {
                        selectedStreet = value ?? '';
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  // ------------------------------------------- City Lived -------------------------------------------
                  DropdownFrameSingle(
                    label: 'City Lived',
                    selectedValue: selectedCity,
                    itemList: CityList,
                    onChanged: (String? value) {
                      setState(() {
                        selectedCity = value ?? '';
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  // ------------------------------------------- Country Lived -------------------------------------------
                  DropdownFrameSingle(
                    label: 'Country Lived',
                    selectedValue: selectedCountry,
                    itemList: CountryList,
                    onChanged: (String? value) {
                      setState(() {
                        selectedCountry = value ?? '';
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  // ------------------------------------------- End -------------------------------------------
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        tooltip: 'Search',
        onPressed: (){},
        child: const Icon(Icons.search, size: 28),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    if (selectedFirstName == "" && selectedLastName == ""
                        && selectedMaidenName == "" && selectedGender == ""
                        && selectedReligion == "" && selectedDateBirth == ""
                        && selectedHouse == "" && selectedStreet == ""
                        && selectedCity == "" && selectedCountry == "") {
                      return null;
                    } else {_navigateToShowPersonSearchList();}
                  },
                  icon: const Icon(Icons.list, color: Colors.white),
                ),
                Text('Show IN List\n', style: TextStyle(color: Colors.white)),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    if (selectedFirstName == "" && selectedLastName == ""
                        && selectedMaidenName == "" && selectedGender == ""
                        && selectedReligion == "" && selectedDateBirth == ""
                        && selectedHouse == "" && selectedStreet == ""
                        && selectedCity == "" && selectedCountry == "") {
                      return null;
                    } else {_navigateToShowPersonSearchMap();}
                  },
                  icon: const Icon(Icons.map, color: Colors.white),
                ),
                Text('Show IN Map\n', style: TextStyle(color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }
  void _navigateToShowPersonSearchList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SPList(
          selectedFirstName: selectedFirstName,
          selectedLastName: selectedLastName,
          selectedMaidenName: selectedMaidenName,
          selectedGender: selectedGender,
          selectedReligion: selectedReligion,
          selectedDateBirth: selectedDateBirth,
          selectedHouse: selectedHouse,
          selectedStreet: selectedStreet,
          selectedCity: selectedCity,
          selectedCountry: selectedCountry,
        ),
      ),
    );
  }
  void _navigateToShowPersonSearchMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SPMap(
          selectedFirstName: selectedFirstName,
          selectedLastName: selectedLastName,
          selectedMaidenName: selectedMaidenName,
          selectedGender: selectedGender,
          selectedReligion: selectedReligion,
          selectedDateBirth: selectedDateBirth,
          selectedHouse: selectedHouse,
          selectedStreet: selectedStreet,
          selectedCity: selectedCity,
          selectedCountry: selectedCountry,
        ),
      ),
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
  Widget _buildList(List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items,
    );
  }
}