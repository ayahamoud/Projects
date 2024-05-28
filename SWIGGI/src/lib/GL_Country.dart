import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Common_Functions.dart';
import 'Data.dart';
import 'GL_World.dart';
import 'GL_City.dart';


class GLCountry extends StatefulWidget {
  final Country country1;
  GLCountry({required this.country1});
  @override
  _GLCountryState createState() => _GLCountryState();
}

class _GLCountryState extends State<GLCountry> {

  final Set<String> allCitys = {};
  List<String> filteredCitys = [];

  @override
  void initState() {
    var rowByCountry = mergedTable.where((entry) => entry['country']?.countryNumber == widget.country1.countryNumber);

    super.initState();
    // Ensure mergedTable doesn't contain duplicates
    for (var entry in rowByCountry) {
      if (entry.containsKey('city') && entry['city'] != null) {
        String cityName = entry['city'].cityName;
        allCitys.add(cityName); // Add to Set
      }
    }
    filteredCitys = allCitys.toList(); // Initial filtering
  }
  void filterCountries(String query) {
    setState(() {
      filteredCitys = allCitys.where((city) => city.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.country1.countryName ?? 'Default Country'} General Look',
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
                        _buildSectionHeader('Citys in Country'),
                        _buildList([
                          _buildListItem('1. Search Engine', 'Search for a city using the search engine.'),
                          _buildListItem('2. City Selection:', 'Choose a specific city to view its overview.'),
                        ]),

                        _buildSectionHeader('Show Country Data :'),
                        _buildList([
                          _buildListItem('1. Total Number of Victims:', 'Display the total number of victims in this country.'),
                          _buildListItem('2. Gender Table:', 'Show a table of male and female victims in this country.'),
                          _buildListItem('3. Age Table:', 'Show a table of minors, adults, and seniors victims in this country.'),
                        ]),

                        _buildSectionHeader('Return to World Page :'),
                        _buildListItem(
                          '1. Return to World Page:',
                          'Click in to World Page button.',
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
                                  hintText: 'Search for a city',
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
                                  itemCount: filteredCitys.length,
                                  itemBuilder: (context, index) {
                                    return StoryCircle(country: widget.country1,city:getCityByName(filteredCitys[index]));
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
                            '${mergedTable.where((entry) => entry['country']?.countryNumber == widget.country1.countryNumber).length}',
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
                    buildGenderTable(mergedTable.where((entry) => entry['country']?.countryNumber == widget.country1.countryNumber && entry['person'].gender == 'M').length,
                        mergedTable.where((entry) => entry['country']?.countryNumber == widget.country1.countryNumber && entry['person'].gender == 'F').length,
                        mergedTable.where((entry) => entry['country']?.countryNumber == widget.country1.countryNumber && entry['person'].gender == null).length),
                    SizedBox(height: 15.0),
                    // ------------------------------------- 4 -------------------------------------
                    buildAgeTable(mergedTable.where((entry) => entry['country']?.countryNumber == widget.country1.countryNumber && entry['person'].dateOfBirth != null && entry['person'].dateOfDeath != null && (entry['person'].dateOfDeath!.difference(entry['person'].dateOfBirth!).inDays ~/ 365) <= 18).length,
                        mergedTable.where((entry) => entry['country']?.countryNumber == widget.country1.countryNumber && entry['person'].dateOfBirth != null && entry['person'].dateOfDeath != null && (entry['person'].dateOfDeath!.difference(entry['person'].dateOfBirth!).inDays ~/ 365) > 18 && (entry['person'].dateOfDeath!.difference(entry['person'].dateOfBirth!).inDays ~/ 365) < 66).length,
                        mergedTable.where((entry) => entry['country']?.countryNumber == widget.country1.countryNumber && entry['person'].dateOfBirth != null && entry['person'].dateOfDeath != null && (entry['person'].dateOfDeath!.difference(entry['person'].dateOfBirth!).inDays ~/ 365) >= 66).length),
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
                    MaterialPageRoute(builder: (context) => GLWorld()),
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
                'To World Page',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      // ------------------------------- end back and menu -------------------------------
    );
  }
  City getCityByName(String cityName) {
    // Iterate through the list of cities
    for (var city in cities) {
      // Check if the city name matches the provided cityName
      if (city.cityName.toLowerCase() == cityName.toLowerCase()) {
        return city; // Return the city if found
      }
    }
    throw ArgumentError('City with name $cityName not found.'); // Throw an error if the city is not found
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

  StoryCircle({required this.country,required this.city});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GLCity(city1: city, country1: country),
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
                city.cityName[0],
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 2.0),
          Text(
            city.cityName,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}