import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Common_Functions.dart';
import 'Data.dart';
import 'package:intl/intl.dart';
import 'P_Memorial.dart';
import 'P_Tree.dart';
import 'GL_House.dart';

class PPerson extends StatefulWidget {
  final Person person1;
  final House house1;
  final City city1;
  final Country country1;
  PPerson({required this.person1, required this.house1, required this.city1, required this.country1});

  @override
  _PPersonState createState() => _PPersonState();
}

class _PPersonState extends State<PPerson> {
  @override
  Widget build(BuildContext context) {
    var matchingEntries = mergedTable.where((entry) =>
    entry['person']?.personID == widget.person1.personID &&
        entry['house']?.houseId == widget.house1.houseId &&
        entry['country']?.countryNumber == widget.country1.countryNumber &&
        entry['city']?.cityNumber == widget.city1.cityNumber &&
        entry['house']?.streetName == widget.house1.streetName);
    var firstEntry =
    matchingEntries.isNotEmpty ? matchingEntries.first : null;

    var fullName = '${widget.person1.firstName ?? "--"}${widget.person1.maidenName != null ? ' ${widget.person1.maidenName}' : ''} ${widget.person1.lastName ?? "--"}'.trim();

    var Gender = widget.person1.gender == "M" ? "Male" : (widget.person1.gender == "F" ? "Female" : widget.person1.gender);
    var Religion =matchingEntries.isNotEmpty ? matchingEntries.first['religion'].religionName : "--";

    var Date_of_Birth = widget.person1.dateOfBirth != null ? DateFormat('yyyy-MM-dd').format(widget.person1.dateOfBirth!) : "--";
    var Country_Birth =getCountryName(getCountryNumber(matchingEntries?.first['person']?.placeBirth));
    var City_Birth =getCityName(matchingEntries?.first['person']?.placeBirth);

    var Date_of_Death =widget.person1.dateOfDeath != null? DateFormat('yyyy-MM-dd').format(widget.person1.dateOfDeath!): "--";
    var Country_Death = getCountryNameFromConcentrationCamp(matchingEntries?.first['person']?.placeDeath);
    var City_Death = getCityNameFromConcentrationCamp(matchingEntries?.first['person']?.placeDeath);
    var Camp_Death = getConcentrationCampName(matchingEntries?.first['person']?.placeDeath);

    var House_Lived = widget.house1.houseNumber ?? "--";
    var Street_Lived = widget.house1.streetName ?? "--";
    var Quarter_Lived = "${firstEntry?['quarter']?.quarterName ?? '--'} ${firstEntry?['quarter']?.quarterNumber ?? '--'}";
    var City_Lived = widget.city1.cityName ?? "--";
    var Country_Lived = widget.country1.countryName ?? "--";

    var Date_of_Deport =widget.person1.dateOfDeport != null ? DateFormat('yyyy-MM-dd').format(widget.person1.dateOfDeport!) : "--";
    var Country_Deport_From =getCountryName(getCountryNumber(matchingEntries?.first['person']?.deportedFrom));
    var City_Deport_From =getCityName(matchingEntries?.first['person']?.deportedFrom);
    var Country_Deport_To =getCountryNameFromConcentrationCamp(matchingEntries?.first['person']?.deportedTo);
    var City_Deport_To =getCityNameFromConcentrationCamp(matchingEntries?.first['person']?.deportedTo);
    var Camp_Deport_To =getConcentrationCampName(matchingEntries?.first['person']?.deportedTo);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Person Profile page',
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
                        _buildSectionHeader('Information about the person'),
                        _buildList([
                          _buildListItem('1. Name person:', 'Contains a person\'s full name.'),
                          _buildListItem('2. Personal Information:', 'Contains the religion and gender of the person.'),
                          _buildListItem('3. Birth Information:', 'Contains place and date of birth for a person.'),
                          _buildListItem('4. Death Information:', 'Contains place and date of death for a person.'),
                          _buildListItem('5. Lived Information:', 'Contains place of lived for a person.'),
                          _buildListItem('6. Deported Information:', 'Contains place Deported to and from and date Deported'),
                        ]),

                        _buildSectionHeader('Show other pages :'),
                        _buildList([
                          _buildListItem('1. Memorial page:', 'Takes me to this person\'s memorial page.'),
                          _buildListItem('2. Tree Family page:', 'Takes me to this person\'s family tree page.'),
                          _buildListItem('3. House Lived page:', 'Takes me to the home page where this person lived.'),
                        ]),
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
            image: AssetImage('images/poland_background.jpg'), // Change the image path as necessary
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //-----------------------------------------------------------------------------------------
                Column(
                  children: [
                    if (Gender == "Male")
                      CircleAvatar(
                        radius: 75,
                        backgroundImage: AssetImage('images/Memorial_Male.png'),
                      )
                    else
                      CircleAvatar(
                        radius: 75,
                        backgroundImage: AssetImage('images/Memorial_Female.png'),
                      ),
                  ],
                ),
                SizedBox(height: 16),
                Text('$fullName', style: TextStyle(fontSize: 24,color: Colors.white, fontWeight: FontWeight.bold,)),
                SizedBox(height: 15),
                //-----------------------------------------------------------------------------------------
                ExpansionTile(
                  title: Text('Personal Information',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),
                  children: [
                    ListTile(title: Text('Gender : $Gender',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),),
                    ListTile(title: Text('Religion : $Religion',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),),
                  ],
                ),
                //-----------------------------------------------------------------------------------------
                ExpansionTile(
                  title: Text('Birth',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),
                  children: [
                    ListTile(title: Text('Date Of Birth : $Date_of_Birth',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),),
                    ListTile(title: Text('Country Birth : $Country_Birth',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),),
                    ListTile(title: Text('City Birth : $City_Birth',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),),
                  ],
                ),
                //-----------------------------------------------------------------------------------------
                ExpansionTile(
                  title: Text('Death',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),
                  children: [
                    ListTile(title: Text('Date Of Death : $Date_of_Death',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),),
                    ListTile(title: Text('Country Death : $Country_Death',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),),
                    ListTile(title: Text('City Death : $City_Death',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),),
                    ListTile(title: Text('Camp Death : $Camp_Death',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),),
                  ],
                ),
                //-----------------------------------------------------------------------------------------
                ExpansionTile(
                  title: Text('Lived',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),
                  children: [
                    ListTile(title: Text('House Lived : $House_Lived',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),),
                    ListTile(title: Text('Street Lived : $Street_Lived',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),),
                    ListTile(title: Text('Quarter Lived : $Quarter_Lived',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),),
                    ListTile(title: Text('City Lived : $City_Lived',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),),
                    ListTile(title: Text('Country Lived : $Country_Lived',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),),
                  ],
                ),
                //-----------------------------------------------------------------------------------------
                ExpansionTile(
                  title: Text('Deported',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),
                  children: [
                    ListTile(title: Text('Country Deport From : $Country_Deport_From',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),),
                    ListTile(title: Text('City Deport From : $City_Deport_From',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),),
                    ListTile(title: Text('Date of Deport : $Date_of_Deport',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),),
                    ListTile(title: Text('Country Deport To : $Country_Deport_To',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),),
                    ListTile(title: Text('City Deport To : $City_Deport_To',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),),
                    ListTile(title: Text('Camp Deport To : $Camp_Deport_To',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),),
                  ],
                ),
                //-----------------------------------------------------------------------------------------
                ExpansionTile(
                  title: Text('Memorial Page',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),
                  children: [
                    ListTile(
                      title: Text('-> To Memorial Page',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PMemorialPage(person: widget.person1, house: widget.house1, city: widget.city1, country: widget.country1,),),);
                      },
                    ),
                  ],
                ),
                //-----------------------------------------------------------------------------------------
                ExpansionTile(
                  title: Text('Tree Family Page',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),
                  children: [
                    ListTile(
                      title: Text('-> To Tree Family Page',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PTreePage(person: widget.person1, house: widget.house1, city: widget.city1, country: widget.country1,),),);
                      },
                    ),
                  ],
                ),
                //-----------------------------------------------------------------------------------------
                ExpansionTile(
                  title: Text('House Lived Page',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),
                  children: [
                    ListTile(
                      title: Text('-> To House Lived Page',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GLHouse(house1: widget.house1, city1: widget.city1, country1: widget.country1,),),);
                      },
                    ),
                  ],
                ),
                //-----------------------------------------------------------------------------------------
                SizedBox(height: 200),
              ],
            ),
          ),
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
