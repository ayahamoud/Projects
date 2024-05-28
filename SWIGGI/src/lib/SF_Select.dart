import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'SF_List.dart';
import 'SF_Map.dart';
import 'Data.dart';
import 'Common_Functions.dart';

class SFSelect extends StatefulWidget {
  @override
  _SFSelectState createState() => _SFSelectState();
}

class _SFSelectState extends State<SFSelect> {
  String selectedFamilyName = '';
  List<String>? selectedCitys = [];
  List<String>? selectedHouses = [];
  List<String>? selectedStreets = [];
  List<String>? selectedPersons = [];

  late List<String> FamilyNameList;
  late List<String> CitysList;
  late List<String> HousesList;
  late List<String> StreetsList;
  late List<String> PersonsList;

  void initState() {
    super.initState();
    StreetsList = mergedTable.map<String>((entry) => entry['house'].streetName as String).where((value) => value != null).toSet().toList();
    CitysList = mergedTable.map<String>((entry) => entry['city'].cityName as String).where((value) => value != null).toSet().toList();
    PersonsList =mergedTable.map<String>((entry) => "${entry['person']?.firstName ?? ''} ${entry['person']?.maidenName ?? ''} ${entry['person']?.lastName ?? ''}").toSet().toList();
    HousesList = mergedTable.map<String>((entry) => (entry['house']?.houseNumber as int?).toString()).toSet().toList();
    FamilyNameList = mergedTable.map<String>((entry) => entry['person'].lastName as String).where((value) => value != null).toSet().toList();

    // Sort the lists with the custom comparator
    StreetsList.sort(compareWithEmpty);
    CitysList.sort(compareWithEmpty);
    PersonsList.sort(compareWithEmpty);
    HousesList.sort(compareWithEmpty);
    FamilyNameList.sort(compareWithEmpty);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Family Search Page',
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
                        Text(
                          'This page allows you to search for Familys by specifying various criteria. Here\'s how to use it:',
                        ),
                        SizedBox(height: 10),
                        _buildList([
                          _buildListItem("Select one or more options from the dropdown lists corresponding to each search criterion variable.", ''),
                          _buildListItem('You can leave some criteria blank if you do not want to specify them in your search.', ''),
                          _buildListItem('Once you have selected the desired criteria, press the "Search" button to perform the search.', ''),
                          _buildListItem('At least one field must be filled to perform a search.', ''),
                          _buildListItem('You can view the matching Family in two ways:', ''),
                          _buildListItem('1. Through a list: Shows the 10 most relevant Familys in a list from most relevant to least relevant.', ''),
                          _buildListItem('2. Through a map: Shows the 10 most relevant Familys on a map, without any specific arrangement.', ''),
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
                  //---------------------------------------------------------------
                  DropdownFrameSingle(
                    label: 'Family Name',
                    selectedValue: selectedFamilyName,
                    itemList: FamilyNameList,
                    onChanged: (String? value) {
                      setState(() {
                        selectedFamilyName = value ?? '';
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  //-------------------------------------------------------------------
                  DropdownFrameMultiple(
                    label: 'Citys Number',
                    selectedValues: selectedCitys,
                    itemList: CitysList,
                    onChanged: (List<String>? values) {
                      setState(() {
                        selectedCitys = values ?? [];
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  //-------------------------------------------------------------------
                  DropdownFrameMultiple(
                    label: 'Streets Number',
                    selectedValues: selectedStreets,
                    itemList: StreetsList,
                    onChanged: (List<String>? values) {
                      setState(() {
                        selectedStreets = values ?? [];
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  //-------------------------------------------------------------------
                  DropdownFrameMultiple(
                    label: 'Houses Number',
                    selectedValues: selectedHouses,
                    itemList: HousesList,
                    onChanged: (List<String>? values) {
                      setState(() {
                        selectedHouses = values ?? [];
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  //-------------------------------------------------------------------
                  DropdownFrameMultiple(
                    label: 'Persons Number',
                    selectedValues: selectedPersons,
                    itemList: PersonsList,
                    onChanged: (List<String>? values) {
                      setState(() {
                        selectedPersons = values ?? [];
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  //---------------------------------------------------------------
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
                    if (selectedCitys?.length == 0 && selectedHouses?.length == 0 && selectedStreets?.length == 0 && selectedPersons?.length == 0 && selectedFamilyName == "" ) {
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
                    if (selectedCitys?.length == 0 && selectedHouses?.length == 0 && selectedStreets?.length == 0 && selectedPersons?.length == 0 && selectedFamilyName == "" ) {
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
        builder: (context) => SFList(
          selectedFamilyName: selectedFamilyName,
          selectedCitys: selectedCitys,
          selectedHouses: selectedHouses,
          selectedStreets: selectedStreets,
          selectedPersons: selectedPersons,
        ),
      ),
    );
  }
  void _navigateToShowPersonSearchMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SFMap(
          selectedFamilyName: selectedFamilyName,
          selectedCitys: selectedCitys,
          selectedHouses: selectedHouses,
          selectedStreets: selectedStreets,
          selectedPersons: selectedPersons,
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