import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Common_Functions.dart';
import 'Data.dart';
import 'GL_Country.dart';
import 'GL_Street.dart';

class GLCity extends StatefulWidget {
  final City city1;
  final Country country1;

  GLCity({required this.city1, required this.country1});
  @override
  _GLCityState createState() => _GLCityState();
}

class _GLCityState extends State<GLCity> {

  final Set<String> allStreets = {};
  List<String> filteredStreets = [];

  @override
  void initState() {
    var rowByCountryCity = mergedTable.where((entry) => entry['country']?.countryNumber == widget.country1.countryNumber &&
        entry['city']?.cityName == widget.city1.cityName);

    super.initState();
    // Ensure mergedTable doesn't contain duplicates
    for (var entry in rowByCountryCity) {
      if (entry.containsKey('house') && entry['house'] != null) {
        String streetName = entry['house'].streetName;
        allStreets.add(streetName); // Add to Set
      }
    }
    filteredStreets = allStreets.toList(); // Initial filtering
  }
  void filterCountries(String query) {
    setState(() {
      filteredStreets = allStreets.where((Street) => Street.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.city1.cityName ?? 'Default City'} General Look',
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
                        _buildSectionHeader('Streets in City'),
                        _buildList([
                          _buildListItem('1. Search Engine', 'Search for a Street using the search engine.'),
                          _buildListItem('2. Street Selection:', 'Choose a specific Street to view its overview.'),
                        ]),

                        _buildSectionHeader('Show City Data :'),
                        _buildList([
                          _buildListItem('1. Total Number of Victims:', 'Display the total number of victims in this City.'),
                          _buildListItem('2. Gender Table:', 'Show a table of male and female victims in this City.'),
                          _buildListItem('3. Age Table:', 'Show a table of minors, adults, and seniors victims in this City.'),
                        ]),

                        _buildSectionHeader('Return to Country Page :'),
                        _buildListItem(
                          '1. Return to Country Page:',
                          'Click in to Country Page button.',
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
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/poland_background.jpg'), // Your image path
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
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
                                  hintText: 'Search for a Street',
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                onChanged: filterCountries,
                              ),
                              Container(
                                height: 80,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: filteredStreets.length,
                                  itemBuilder: (context, index) {
                                    return StoryCircle(country: widget.country1, city: widget.city1, house: getHouseByName(filteredStreets[index]),);
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
                            '${mergedTable.where((entry) => entry['country']?.countryNumber == widget.country1.countryNumber && entry['city']?.cityNumber == widget.city1.cityNumber).length}',
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
                        mergedTable.where((entry) => entry['country']?.countryNumber == widget.country1.countryNumber && entry['city']?.cityNumber == widget.city1.cityNumber && entry['person'].gender == 'M').length,
                        mergedTable.where((entry) => entry['country']?.countryNumber == widget.country1.countryNumber && entry['city']?.cityNumber == widget.city1.cityNumber && entry['person'].gender == 'F').length,
                        mergedTable.where((entry) => entry['country']?.countryNumber == widget.country1.countryNumber && entry['city']?.cityNumber == widget.city1.cityNumber && entry['person'].gender == null).length),
                    SizedBox(height: 15.0),
                    // ------------------------------------- 4 -------------------------------------
                    buildAgeTable(
                        mergedTable.where((entry) => entry['country']?.countryNumber == widget.country1.countryNumber && entry['city']?.cityNumber == widget.city1.cityNumber && entry['person'].dateOfBirth != null && entry['person'].dateOfDeath != null && (entry['person'].dateOfDeath!.difference(entry['person'].dateOfBirth!).inDays ~/ 365) <= 18).length,
                        mergedTable.where((entry) => entry['country']?.countryNumber == widget.country1.countryNumber && entry['city']?.cityNumber == widget.city1.cityNumber && entry['person'].dateOfBirth != null && entry['person'].dateOfDeath != null && (entry['person'].dateOfDeath!.difference(entry['person'].dateOfBirth!).inDays ~/ 365) > 18 && (entry['person'].dateOfDeath!.difference(entry['person'].dateOfBirth!).inDays ~/ 365) < 66).length,
                        mergedTable.where((entry) => entry['country']?.countryNumber == widget.country1.countryNumber && entry['city']?.cityNumber == widget.city1.cityNumber && entry['person'].dateOfBirth != null && entry['person'].dateOfDeath != null && (entry['person'].dateOfDeath!.difference(entry['person'].dateOfBirth!).inDays ~/ 365) >= 66).length),
                    SizedBox(height: 150.0),
                  ],
                ),
              ),
            ),
          ),
        ],
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
                    MaterialPageRoute(builder: (context) => GLCountry(country1: widget.country1)),
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
                'To Country Page',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      // ------------------------------- end back and menu -------------------------------
    );
  }
  House getHouseByName(String streetName) {
    // Iterate through the list of cities
    for (var house in houses) {
      // Check if the city name matches the provided cityName
      if (house.streetName.toLowerCase() == streetName.toLowerCase()) {
        return house; // Return the city if found
      }
    }
    throw ArgumentError('City with name $streetName not found.'); // Throw an error if the city is not found
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
            builder: (context) => GLStreet(house1 : house ,city1: city, country1: country),
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
                house.streetName[0],
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 2.0),
          Text(
            house.streetName,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}