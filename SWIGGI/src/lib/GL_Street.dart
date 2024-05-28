import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Common_Functions.dart';
import 'Data.dart';
import 'GL_City.dart';
import 'GL_House.dart';

class GLStreet extends StatefulWidget {
  final City city1;
  final Country country1;
  final House house1;

  GLStreet({required this.house1, required this.city1, required this.country1,});
  @override
  _GLStreetState createState() => _GLStreetState();
}

class _GLStreetState extends State<GLStreet> {

  final Set<String> allHouses = {};
  List<String> filteredHouses = [];

  @override
  void initState() {
    var rowByCountryCityStreet = mergedTable.where((entry) => entry['country']?.countryNumber == widget.country1.countryNumber &&
        entry['city']?.cityName == widget.city1.cityName && entry['house']?.streetName == widget.house1.streetName);

    super.initState();
    // Ensure mergedTable doesn't contain duplicates
    for (var entry in rowByCountryCityStreet) {
      if (entry.containsKey('house') && entry['house'] != null) {
        String houseNumber = entry['house'].houseNumber.toString();
        allHouses.add(houseNumber);
      }
    }
    filteredHouses = allHouses.toList(); // Initial filtering
  }
  void filterHouses(String query) {
    setState(() {
      filteredHouses = allHouses.where((house) => house.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.house1.streetName ?? 'Default street'} General Look',
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
                  title: Text(
                    'How to Use This Page',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Adjust color as needed
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('Houses in Street'),
                        _buildList([
                          _buildListItem('1. Search Engine', 'Search for a House using the search engine.'),
                          _buildListItem('2. House Selection:', 'Choose a specific House to view its overview.'),
                        ]),

                        _buildSectionHeader('Show Street Data :'),
                        _buildList([
                          _buildListItem('1. Total Number of Victims:', 'Display the total number of victims in this Street.'),
                          _buildListItem('2. Gender Table:', 'Show a table of male and female victims in this Street.'),
                          _buildListItem('3. Age Table:', 'Show a table of minors, adults, and seniors victims in this Street.'),
                        ]),

                        _buildSectionHeader('Return to City Page :'),
                        _buildListItem(
                          '1. Return to City Page:',
                          'Click in to City Page button.',
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
            image: AssetImage('images/poland_background.jpg'), // Adjust the path as needed
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          // ---------------------------------------------------------------------------------------------
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Divider(color: Colors.black, thickness: 2.0),
                                    TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Search for a House',
                                        prefixIcon: Icon(Icons.search),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      onChanged: filterHouses,
                                    ),
                                    Container(
                                      height: 80,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: filteredHouses.length,
                                        itemBuilder: (context, index) {
                                          return StoryCircle(country: widget.country1, city: widget.city1, house: getHouseByNumber(filteredHouses[index],widget.house1),);
                                        },
                                        separatorBuilder: (context, index) {
                                          return VerticalDivider(color: Colors.black, thickness: 2.0,);
                                        },
                                      ),
                                    ),
                                    Divider(color: Colors.black, thickness: 2.0),

                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5.0),
                          // ------------------------------------- 2 -------------------------------------
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Number Of Victims: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  '${mergedTable.where((entry) => entry['country']?.countryNumber == widget.country1.countryNumber && entry['city']?.cityNumber == widget.city1.cityNumber && entry['house']?.streetName == widget.house1.streetName).length}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15.0),
                          // ------------------------------------- 3 -------------------------------------
                          buildGenderTable(
                              mergedTable.where((entry) => entry['country']?.countryNumber == widget.country1.countryNumber && entry['city']?.cityNumber == widget.city1.cityNumber && entry['house']?.streetName == widget.house1.streetName && entry['person'].gender == 'M').length,
                              mergedTable.where((entry) => entry['country']?.countryNumber == widget.country1.countryNumber && entry['city']?.cityNumber == widget.city1.cityNumber && entry['house']?.streetName == widget.house1.streetName && entry['person'].gender == 'F').length,
                              mergedTable.where((entry) => entry['country']?.countryNumber == widget.country1.countryNumber && entry['city']?.cityNumber == widget.city1.cityNumber && entry['house']?.streetName == widget.house1.streetName&& entry['person'].gender == null).length),
                          SizedBox(height: 15.0),
                          // ------------------------------------- 4 -------------------------------------
                          buildAgeTable(
                              mergedTable.where((entry) => entry['country']?.countryNumber == widget.country1.countryNumber && entry['city']?.cityNumber == widget.city1.cityNumber && entry['house']?.streetName == widget.house1.streetName && entry['person'].dateOfBirth != null && entry['person'].dateOfDeath != null && (entry['person'].dateOfDeath!.difference(entry['person'].dateOfBirth!).inDays ~/ 365) <= 18).length,
                              mergedTable.where((entry) => entry['country']?.countryNumber == widget.country1.countryNumber && entry['city']?.cityNumber == widget.city1.cityNumber && entry['house']?.streetName == widget.house1.streetName && entry['person'].dateOfBirth != null && entry['person'].dateOfDeath != null && (entry['person'].dateOfDeath!.difference(entry['person'].dateOfBirth!).inDays ~/ 365) > 18 && (entry['person'].dateOfDeath!.difference(entry['person'].dateOfBirth!).inDays ~/ 365) < 66).length,
                              mergedTable.where((entry) => entry['country']?.countryNumber == widget.country1.countryNumber && entry['city']?.cityNumber == widget.city1.cityNumber && entry['house']?.streetName == widget.house1.streetName && entry['person'].dateOfBirth != null && entry['person'].dateOfDeath != null && (entry['person'].dateOfDeath!.difference(entry['person'].dateOfBirth!).inDays ~/ 365) >= 66).length),
                          SizedBox(height: 150.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // ------------------------------- back and menu -------------------------------
      floatingActionButton: Container(
        padding: EdgeInsets.only(left: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => GLCity(city1:widget.city1 ,country1:widget.country1)),
                  );
                },
                child: Icon(Icons.arrow_back,size: 50),
                backgroundColor: Colors.transparent, // Set background color to transparent
                foregroundColor: Colors.white, // Set font color to white
              ),
            ),
            SizedBox(width: 1), // Add some spacing between the icon and the text
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Text(
                'To City Page',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      // ------------------------------- end back and menu -------------------------------
    );

  }
  House getHouseByNumber(String houseNumber ,House house1) {
    // Iterate through the list of cities
    for (var house in houses) {
      // Check if the city name matches the provided cityName
      if (house.houseNumber.toString().toLowerCase() == houseNumber.toLowerCase()
          &&(house.streetName.toLowerCase() == house1.streetName.toLowerCase())) {
        return house;
      }
    }
    throw ArgumentError('City with name $houseNumber not found.'); // Throw an error if the city is not found
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
class StoryCircle extends StatelessWidget {
  final Country country;
  final City city;
  final House house;

  StoryCircle({required this.country,required this.city,required this.house});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GLHouse(house1: house, city1: city, country1: country),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(8.0),
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
              border: Border.all(color: Colors.black, width: 2.0),
            ),
            child: Center(
              child: Text(
                house.houseNumber.toString(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 2.0),
          Text(
            house.houseNumber.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}