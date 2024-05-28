import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Data.dart';
import 'SH_List.dart';
import 'SH_Map.dart';
import 'Common_Functions.dart';

class SHSelect extends StatefulWidget {
  @override
  _SHSelectState createState() => _SHSelectState();
}
class _SHSelectState extends State<SHSelect> {
  String selectedStreet = '';
  String selectedQuarter = '';
  String selectedCity = '';
  String selectedCountry = '';
  String selectedHouse = '';
  List<String>? selectedPersons = [];

  late List<String> StreetList;
  late List<String> QuarterList;
  late List<String> CityList;
  late List<String> CountryList;
  late List<String> HouseNumberList;
  late List<String> PersonsNameList;


  void initState() {
    super.initState();
    StreetList = mergedTable.map<String>((entry) => entry['house'].streetName as String).where((value) => value != null).toSet().toList();
    QuarterList = mergedTable.map<String>((entry) => "${entry['quarter'].quarterName} ${entry['quarter'].quarterNumber}").where((value) => value != null).toSet().toList();
    CityList = mergedTable.map<String>((entry) => entry['city'].cityName as String).where((value) => value != null).toSet().toList();
    CountryList = mergedTable.map<String>((entry) => entry['country'].countryName as String).where((value) => value != null).toSet().toList();
    HouseNumberList = mergedTable.map<String>((entry) => (entry['house']?.houseNumber as int).toString()).toSet().toList();
    PersonsNameList = mergedTable.map<String>((entry) => "${entry['person']?.firstName ?? ''} ${entry['person']?.maidenName ?? ''} ${entry['person']?.lastName ?? ''}").toSet().toList();
    // Sort the lists with the custom comparator
    StreetList.sort(compareWithEmpty);
    QuarterList.sort(compareWithEmpty);
    CityList.sort(compareWithEmpty);
    CountryList.sort(compareWithEmpty);
    HouseNumberList.sort(compareWithEmpty);
    PersonsNameList.sort(compareWithEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('House Search Page',
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
                        Text(
                          'This page allows you to search for Houses by specifying various criteria. Here\'s how to use it:',
                        ),
                        SizedBox(height: 10),
                        _buildList([
                          _buildListItem("Select one or more options from the dropdown lists corresponding to each search criterion variable.", ''),
                          _buildListItem('You can leave some criteria blank if you do not want to specify them in your search.', ''),
                          _buildListItem('Once you have selected the desired criteria, press the "Search" button to perform the search.', ''),
                          _buildListItem('At least one field must be filled to perform a search.', ''),
                          _buildListItem('You can view the matching House in two ways:', ''),
                          _buildListItem('1. Through a list: Shows the 10 most relevant Houses in a list from most relevant to least relevant.', ''),
                          _buildListItem('2. Through a map: Shows the 10 most relevant Houses on a map, without any specific arrangement.', ''),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //--------------------------------------------------------------------------------
                  DropdownFrameSingle(
                    label: 'House Number',
                    selectedValue: selectedHouse,
                    itemList: HouseNumberList,
                    onChanged: (String? value) {
                      setState(() {
                        selectedHouse = value ?? '';
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  //--------------------------------------------------------------------------------
                  DropdownFrameSingle(
                    label: 'Street Name',
                    selectedValue: selectedStreet,
                    itemList: StreetList,
                    onChanged: (String? value) {
                      setState(() {
                        selectedStreet = value ?? '';
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  //--------------------------------------------------------------------------------
                  DropdownFrameSingle(
                    label: 'Quarter',
                    selectedValue: selectedQuarter,
                    itemList: QuarterList,
                    onChanged: (String? value) {
                      setState(() {
                        selectedQuarter = value ?? '';
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  //--------------------------------------------------------------------------------
                  DropdownFrameSingle(
                    label: 'City Name',
                    selectedValue: selectedCity,
                    itemList: CityList,
                    onChanged: (String? value) {
                      setState(() {
                        selectedCity = value ?? '';
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  //--------------------------------------------------------------------------------
                  DropdownFrameSingle(
                    label: 'Country Name',
                    selectedValue: selectedCountry,
                    itemList: CountryList,
                    onChanged: (String? value) {
                      setState(() {
                        selectedCountry = value ?? '';
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  //--------------------------------------------------------------------------------
                  DropdownFrameMultiple(
                    label: 'Persons Name',
                    selectedValues: selectedPersons,
                    itemList: PersonsNameList,
                    onChanged: (List<String>? values) {
                      setState(() {
                        selectedPersons = values ?? [];
                      });
                    },
                  ),
                  SizedBox(height: 20),
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
                    if (selectedPersons?.length == 0 && selectedStreet == ""
                        && selectedQuarter == "" && selectedCity == ""
                        && selectedCountry == "" && selectedHouse == "") {
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
                    if (selectedPersons?.length == 0 && selectedStreet == ""
                        && selectedQuarter == "" && selectedCity == ""
                        && selectedCountry == "" && selectedHouse == "") {
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
        builder: (context) => SHList(
          selectedStreet: selectedStreet,
          selectedQuarter: selectedQuarter,
          selectedCity: selectedCity,
          selectedCountry: selectedCountry,
          selectedHouse: selectedHouse,
          selectedPersonList: selectedPersons,
        ),
      ),
    );
  }
  void _navigateToShowPersonSearchMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SHMap(
          selectedStreet: selectedStreet,
          selectedQuarter: selectedQuarter,
          selectedCity: selectedCity,
          selectedCountry: selectedCountry,
          selectedHouse: selectedHouse,
          selectedPersonList: selectedPersons,
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