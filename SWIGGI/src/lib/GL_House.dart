import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Common_Functions.dart';
import 'Data.dart';
import 'GL_Street.dart';
import 'P_Person.dart';

class GLHouse extends StatefulWidget {
  final House house1;
  final City city1;
  final Country country1;

  GLHouse({required this.house1, required this.city1, required this.country1});
  @override
  _GLHouseState createState() => _GLHouseState();
}

class _GLHouseState extends State<GLHouse> {
  final Set<String> allPerson = {};
  List<String> filteredPerson = [];

  @override
  void initState() {
    var rowByCountryCityStreetHouse = mergedTable.where((entry) => entry['country']?.countryNumber == widget.country1.countryNumber &&
        entry['city']?.cityName == widget.city1.cityName && entry['house']?.streetName == widget.house1.streetName
        && entry['house']?.houseNumber == widget.house1.houseNumber);

    super.initState();
    // Ensure mergedTable doesn't contain duplicates
    for (var entry in rowByCountryCityStreetHouse) {
      if (entry.containsKey('person') && entry['person'] != null) {
        String PersonName = entry['person'].firstName+" "+entry['person'].lastName;
        allPerson.add(PersonName); // Add to Set
      }
    }
    filteredPerson = allPerson.toList(); // Initial filtering
  }
  void filterPersons(String query) {
    setState(() {
      filteredPerson = allPerson.where((person) => person.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.house1.houseNumber ?? 'Default house'} - ${widget.house1.streetName ?? 'Default street'} General Look',
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
                        _buildSectionHeader('Persons in House'),
                        _buildList([
                          _buildListItem('1. Search Engine', 'Search for a Person using the search engine.'),
                          _buildListItem('2. Person Selection:', 'Choose a specific Person to view its overview.'),
                        ]),

                        _buildSectionHeader('Show Street House :'),
                        _buildList([
                          _buildListItem('1. Total Number of Victims:', 'Display the total number of victims in this House.'),
                          _buildListItem('2. Gender Table:', 'Show a table of male and female victims in this House.'),
                          _buildListItem('3. Age Table:', 'Show a table of minors, adults, and seniors victims in this House.'),
                        ]),

                        _buildSectionHeader('Return to Street Page :'),
                        _buildListItem(
                          '1. Return to Street Page:',
                          'Click in to Street Page button.',
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
                                  hintText: 'Search for a Person',
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                onChanged: filterPersons,
                              ),
                              Container(
                                height: 80,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: filteredPerson.length,
                                  itemBuilder: (context, index) {
                                    return StoryCircle(country: widget.country1, city: widget.city1, house:widget.house1 , person: getPersonByName(filteredPerson[index]),);
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
                            '${mergedTable.where((entry) => entry['house']?.houseId == widget.house1.houseId && entry['country']?.countryNumber == widget.country1.countryNumber && entry['city']?.cityNumber == widget.city1.cityNumber && entry['house']?.streetName ==widget. house1.streetName).length}',
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
                        mergedTable.where((entry) =>entry['house']?.houseId == widget.house1.houseId && entry['country']?.countryNumber == widget.country1.countryNumber && entry['city']?.cityNumber == widget.city1.cityNumber && entry['house']?.streetName == widget.house1.streetName && entry['person'].gender == 'M').length,
                        mergedTable.where((entry) =>entry['house']?.houseId == widget.house1.houseId && entry['country']?.countryNumber == widget.country1.countryNumber && entry['city']?.cityNumber == widget.city1.cityNumber && entry['house']?.streetName == widget.house1.streetName && entry['person'].gender == 'F').length,
                        mergedTable.where((entry) =>entry['house']?.houseId == widget.house1.houseId && entry['country']?.countryNumber == widget.country1.countryNumber && entry['city']?.cityNumber == widget.city1.cityNumber && entry['house']?.streetName == widget.house1.streetName && entry['person'].gender == null).length),
                    SizedBox(height: 15.0),
                    // ------------------------------------- 4 -------------------------------------
                    buildAgeTable(
                        mergedTable.where((entry) =>entry['house']?.houseId == widget.house1.houseId && entry['country']?.countryNumber == widget.country1.countryNumber && entry['city']?.cityNumber == widget.city1.cityNumber && entry['house']?.streetName == widget.house1.streetName && entry['person'].dateOfBirth != null && entry['person'].dateOfDeath != null && (entry['person'].dateOfDeath!.difference(entry['person'].dateOfBirth!).inDays ~/ 365) <= 18).length,
                        mergedTable.where((entry) =>entry['house']?.houseId == widget.house1.houseId && entry['country']?.countryNumber == widget.country1.countryNumber && entry['city']?.cityNumber == widget.city1.cityNumber && entry['house']?.streetName == widget.house1.streetName && entry['person'].dateOfBirth != null && entry['person'].dateOfDeath != null && (entry['person'].dateOfDeath!.difference(entry['person'].dateOfBirth!).inDays ~/ 365) > 18 && (entry['person'].dateOfDeath!.difference(entry['person'].dateOfBirth!).inDays ~/ 365) < 66).length,
                        mergedTable.where((entry) =>entry['house']?.houseId == widget.house1.houseId && entry['country']?.countryNumber == widget.country1.countryNumber && entry['city']?.cityNumber == widget.city1.cityNumber && entry['house']?.streetName == widget.house1.streetName && entry['person'].dateOfBirth != null && entry['person'].dateOfDeath != null && (entry['person'].dateOfDeath!.difference(entry['person'].dateOfBirth!).inDays ~/ 365) >= 66).length),
                    SizedBox(height: 150.0),
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
                    MaterialPageRoute(builder: (context) => GLStreet(city1: widget.city1, country1: widget.country1, house1: widget.house1)),
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
                'To Street Page',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Person getPersonByName(String personName) {
    List<String> names = personName.split(" ");

    String firstName = names.length > 1 ? names.sublist(0, names.length - 1).join(" ") : personName;
    String lastName = names.isNotEmpty ? names.last : "";

    // Iterate through the list of cities
    for (var person in persons) {
      // Check if the city name matches the provided cityName
      if (person.firstName?.toLowerCase() == firstName.toLowerCase()
          && person.lastName?.toLowerCase() == lastName.toLowerCase()) {
        return person; // Return the city if found
      }
    }
    throw ArgumentError('City with name $personName not found.'); // Throw an error if the city is not found
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
  final Person person;

  StoryCircle({required this.country,required this.city,required this.house,required this.person});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PPerson(person1: person,house1: house, city1: city, country1: country),
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
                (person.firstName ?? '')[0] + (person.lastName ?? '')[0],
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 2.0),
          Text(
            (person.firstName ?? '') + ' ' + (person.lastName ?? ''),
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}