import 'package:flutter/material.dart';
import 'package:search_choices/search_choices.dart';
import 'Data.dart';

// ************************************************************* 1 *************************************************************
Widget buildGenderTable(int maleCount, int femaleCount, int UnKnownCount) {
  return Table(
    border: TableBorder.all(color: Colors.white, width: 3),
    children: [
      TableRow(
        children: [
          TableCell(
            child: Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.grey,
              child: Text(
                ' Genders ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      TableRow(
        children: [
          TableCell(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildGenderRow(Icons.male, Colors.blue, 'Male', maleCount),
                  buildGenderDivider(),
                  buildGenderRow(
                      Icons.female, Colors.pink, 'Female', femaleCount),
                ],
              ),
            ),
          ),
        ],
      ),
      TableRow(
        children: [
          TableCell(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '$maleCount',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  buildGenderDivider(),
                  Text(
                    '$femaleCount',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
Widget buildGenderRow(IconData icon, Color iconColor, String gender, int count) {
  return Row(
    children: [
      Icon(icon, color: iconColor,size: 20,),
      SizedBox(width: 5), // Adjust the space between icon and text
      Text(
        ' $gender',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    ],
  );
}
Widget buildGenderDivider() {
  return VerticalDivider(thickness: 1, color: Colors.white);
}
// ************************************************************* 2 *************************************************************
Widget buildAgeTable(int childCount, int youthCount, int oldCount) {
  return Table(
    border: TableBorder.all(color: Colors.white, width: 3),
    children: [
      TableRow(
        children: [
          TableCell(
            child: Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.grey,
              child: Text(
                'Age Stages',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      TableRow(
        children: [
          TableCell(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildAgeRow('Minors\n(0-18)', childCount),
                  buildAgeDivider(),
                  buildAgeRow(' Adults\n(19-65)', youthCount),
                  buildAgeDivider(),
                  buildAgeRow('Seniors\n  (66+)', oldCount),
                ],
              ),
            ),
          ),
        ],
      ),
      TableRow(
        children: [
          TableCell(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '$childCount',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  buildAgeDivider(),
                  Text(
                    '$youthCount',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  buildAgeDivider(),
                  Text(
                    '$oldCount',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
Widget buildAgeRow(String ageStage, int count) {
  return Row(
    children: [
      Text(
        ageStage,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    ],
  );
}
Widget buildAgeDivider() {
  return VerticalDivider(thickness: 1, color: Colors.white);
}
// **************************************************************************************************************************

// ---------------------------------------------------- Birth ----------------------------------------------------
String getCityName(int? cityNumber) {
  if (cityNumber == null){return("--");}
  City? matchingCity = cities.firstWhere((city) => city.cityNumber == cityNumber, orElse: () => City(cityNumber: 0, cityName: "--", countryNumber: 0),);
  return matchingCity.cityName;
}
int getCountryNumber(int? cityNumber) {
  if (cityNumber == null){return(-1);}
  City? matchingCity = cities.firstWhere((city) => city.cityNumber == cityNumber, orElse: () => City(cityNumber: 0, cityName: "--", countryNumber: 0),);
  return matchingCity.countryNumber;
}
String getCountryName(int? countryNumber) {
  if(countryNumber == -1){return("--");}
  Country? matchingCountry = countries.firstWhere((country) => country.countryNumber == countryNumber, orElse: () => Country(countryNumber: 0, countryName: "--"),);
  return matchingCountry.countryName;
}
// ---------------------------------------------------- Death ----------------------------------------------------
String getConcentrationCampName(int? concentrationCampNumber) {
  ConcentrationCamp? matchingCamp = concentrationCamps.firstWhere((camp) => camp.concentrationCampNumber == concentrationCampNumber, orElse: () => ConcentrationCamp(concentrationCampNumber: 0, concentrationCampName: "--", cityNumber: 0),);
  return matchingCamp.concentrationCampName;
}
String getCityNameFromConcentrationCamp(int? concentrationCampNumber) {
  if(concentrationCampNumber==null){return("--");}
  ConcentrationCamp? matchingCamp = concentrationCamps.firstWhere((camp) => camp.concentrationCampNumber == concentrationCampNumber, orElse: () => ConcentrationCamp(concentrationCampNumber: 0, concentrationCampName: "--", cityNumber: 0),);
  City? matchingCity = cities.firstWhere((city) => city.cityNumber == matchingCamp.cityNumber, orElse: () => City(cityNumber: 0, cityName: "--", countryNumber: 0),);
  return matchingCity.cityName;
}
String getCountryNameFromConcentrationCamp(int? concentrationCampNumber) {
  if(concentrationCampNumber==null){return("--");}
  final Map<int, String> cityToCountry = {};
  for (var city in cities) {cityToCountry[city.cityNumber] = countries.firstWhere((country) => country.countryNumber == city.countryNumber).countryName;}
  final Map<int, String> campToCountry = {};
  for (var camp in concentrationCamps) {campToCountry[camp.concentrationCampNumber] = cityToCountry[camp.cityNumber] ?? 'Unknown Country';}
  return campToCountry[concentrationCampNumber] ?? 'Unknown Country';
}



class DropdownFrameSingle extends StatefulWidget {
  final String label;
  final String? selectedValue;
  final List<String> itemList;
  final ValueChanged<String?> onChanged;

  DropdownFrameSingle({
    required this.label,
    required this.selectedValue,
    required this.itemList,
    required this.onChanged,
  });

  @override
  _DropdownFrameStateSingle createState() => _DropdownFrameStateSingle();
}
class _DropdownFrameStateSingle extends State<DropdownFrameSingle> {
  String? _selectedValue;
  late List<DropdownMenuItem<String>> _dropdownItems;

  @override
  void initState() {
    super.initState();
    _dropdownItems = widget.itemList
        .where((item) => item != null)
        .map((item) => DropdownMenuItem<String>(
      value: item!,
      child: Text(item),
    ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SearchChoices.single(
            items: widget.itemList
                .map((item) => DropdownMenuItem<String>(
              value: item,
              child: Container(
                child: Text(
                  item,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )).toList(),
            value: _selectedValue,
            hint: Text("Select one", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            searchHint: "Select one",
            onChanged: (value) {
              setState(() {
                _selectedValue = value;
              });
              widget.onChanged(value);
            },
            doneButton: "Done",
            displayItem: (item, selected) {
              return Row(
                children: [
                  selected
                      ? Icon(
                    Icons.radio_button_checked,
                    color: Colors.grey,
                  )
                      : Icon(
                    Icons.radio_button_unchecked,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      item.value, // Accessing the value property of DropdownMenuItem<String>
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              );
            },
            isExpanded: true,
          ),
        ],
      ),
    );
  }
}
class DropdownFrameMultiple extends StatefulWidget {
  final String label;
  final List<String>? selectedValues;
  final List<String> itemList;
  final ValueChanged<List<String>> onChanged;

  DropdownFrameMultiple({
    required this.label,
    required this.selectedValues,
    required this.itemList,
    required this.onChanged,
  });

  @override
  _DropdownFrameStateMultiple createState() => _DropdownFrameStateMultiple();
}
class _DropdownFrameStateMultiple extends State<DropdownFrameMultiple> {
  late List<int> _selectedIndices;
  late List<DropdownMenuItem<String>> _dropdownItems;

  @override
  void initState() {
    super.initState();
    _selectedIndices = widget.selectedValues?.map((item) => widget.itemList.indexOf(item)).toList() ?? [];
    _dropdownItems = widget.itemList
        .where((item) => item != null)
        .map((item) => DropdownMenuItem<String>(
      value: item!,
      child: Text(item),
    ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SearchChoices.multiple(
            items: widget.itemList
                .map((item) => DropdownMenuItem<String>(
              value: item,
              child: Container(
                child: Text(
                  item,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )).toList(),
            selectedItems: _selectedIndices,
            hint: Text("Select multiple", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            searchHint: "Select multiple",
            onChanged: (selectedIndices) {
              setState(() {
                _selectedIndices = selectedIndices.cast<int>();
              });
              widget.onChanged(_selectedIndices.map((index) => widget.itemList[index]).toList());
            },
            doneButton: "Done",
            displayItem: (item, selected) {
              return Row(
                children: [
                  selected
                      ? Icon(
                    Icons.check_box,
                    color: Colors.grey,
                  )
                      : Icon(
                    Icons.check_box_outline_blank,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      item.value, // Accessing the value property of DropdownMenuItem<String>
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              );
            },
            isExpanded: true,
          ),
        ],
      ),
    );
  }
}
int compareWithEmpty(String? a, String? b) {
  if (a == null && b == null) {
    return 0;
  } else if (a == null || a.isEmpty) {
    return -1;
  } else if (b == null || b.isEmpty) {
    return 1;
  } else {
    return a.compareTo(b);
  }
}