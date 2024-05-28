import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Common_Functions.dart';
import 'Data.dart';
import 'main.dart';
import 'GL_Country.dart';

class GLWorld extends StatefulWidget {
  @override
  _GLWorldState createState() => _GLWorldState();
}
class _GLWorldState extends State<GLWorld> {

  final Set<String> allCountries = {};
  List<String> filteredCountries = [];
  @override
  void initState() {
    super.initState();
    // Ensure mergedTable doesn't contain duplicates
    for (var entry in mergedTable) {
      if (entry.containsKey('country') && entry['country'] != null) {
        String countryName = entry['country'].countryName;
        allCountries.add(countryName); // Add to Set
      }
    }
    filteredCountries = allCountries.toList(); // Initial filtering
  }
  void filterCountries(String query) {
    setState(() {
      filteredCountries = allCountries.where((country) => country.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "General Look World",
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
                        _buildSectionHeader('Countrys in World'),
                        _buildList([
                          _buildListItem('1. Search Engine', 'Search for a country using the search engine.'),
                          _buildListItem('2. Country Selection:', 'Choose a specific country to view its overview.'),
                        ]),

                        _buildSectionHeader('Show World Data :'),
                        _buildList([
                          _buildListItem('1. Total Number of Victims:', 'Display the total number of victims worldwide.'),
                          _buildListItem('2. Gender Table:', 'Show a table of male and female victims worldwide.'),
                          _buildListItem('3. Age Table:', 'Show a table of minors, adults, and seniors victims worldwide'),
                        ]),

                        _buildSectionHeader('Return to Home Page :'),
                        _buildListItem(
                          '1. Return to Home Page:',
                          'Click in to main button.',
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
                                  hintText: 'Search for a country',
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
                                  itemCount: filteredCountries.length,
                                  itemBuilder: (context, index) {
                                    return StoryCircle(country: getCountryByName(filteredCountries[index]));
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
                    // ---------------------------------------------------------------------------------------------
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ---------------------------------------------------------------------------------------------
                          Text(
                            'Number Of Victims: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            '${mergedTable.length}',
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
                    // ---------------------------------------------------------------------------------------------
                    buildGenderTable(
                      mergedTable.where((entry) => entry['person'].gender == 'M').length,
                      mergedTable.where((entry) => entry['person'].gender == 'F').length,
                      mergedTable.where((entry) => entry['person'].gender == null).length,
                    ),
                    SizedBox(height: 15.0),
                    // ---------------------------------------------------------------------------------------------
                    buildAgeTable(
                      mergedTable.where((entry) => entry['person'].dateOfBirth != null && entry['person'].dateOfDeath != null && (entry['person'].dateOfDeath!.difference(entry['person'].dateOfBirth!).inDays ~/ 365) <= 18).length,
                      mergedTable.where((entry) => entry['person'].dateOfBirth != null && entry['person'].dateOfDeath != null && (entry['person'].dateOfDeath!.difference(entry['person'].dateOfBirth!).inDays ~/ 365) > 18 && (entry['person'].dateOfDeath!.difference(entry['person'].dateOfBirth!).inDays ~/ 365) < 66).length,
                      mergedTable.where((entry) => entry['person'].dateOfBirth != null && entry['person'].dateOfDeath != null && (entry['person'].dateOfDeath!.difference(entry['person'].dateOfBirth!).inDays ~/ 365) >= 66).length,
                    ),
                    SizedBox(height: 150.0),
                    // ---------------------------------------------------------------------------------------------
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
                    MaterialPageRoute(builder: (context) => MyHomePage(title: 'SWIGGI Home Page')),
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
                'To Main Page',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),


    );
  }
  Country getCountryByName(String countryName) {
    Country? country = mergedTable
        .map((entry) => entry['country'])
        .whereType<Country>()
        .firstWhere((country) => country.countryName == countryName);

    return country!;
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

  StoryCircle({required this.country});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GLCountry(country1: country),
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
                country.countryName[0],
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 2.0),
          Text(
            country.countryName,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}