import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import 'Common_Functions.dart';
import 'Data.dart';
import 'package:intl/intl.dart';

class PTreePage extends StatelessWidget {
  final Person person;
  final House house;
  final City city;
  final Country country;
  PTreePage({required this.person, required this.house, required this.city, required this.country,});

  @override
  Widget build(BuildContext context) {
    var matchingEntries = mergedTable.where((entry) =>
    entry['person']?.personID == person.personID &&
        entry['house']?.houseId == house.houseId &&
        entry['country']?.countryNumber == country.countryNumber &&
        entry['city']?.cityNumber == city.cityNumber &&
        entry['house']?.streetName == house.streetName);
    var firstEntry =
    matchingEntries.isNotEmpty ? matchingEntries.first : null;

    var fullName = '${person.firstName ?? "--"}${person.maidenName != null ? ' ${person.maidenName}' : ''} ${person.lastName ?? "--"}'.trim();
    var Gender = person.gender == "M" ? "Male" : (person.gender == "F" ? "Female" : person.gender);

    List<String> Father =buildFamilyFrame('Father');
    List<String> Mother =buildFamilyFrame('Mother');
    List<String> Brother =buildFamilyFrame('Brother');
    List<String> Sister =buildFamilyFrame('Sister');
    List<String> Wife_Husband =buildFamilyFrame(person.gender == 'M' ? 'Wife' : 'Husband');
    List<String> Daughter =buildFamilyFrame('Daughter');
    List<String> Son =buildFamilyFrame('Son');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tree Page',
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
                        _buildSectionHeader('Family Tree about the person'),
                        _buildList([
                          _buildListItem('1. Name person:', 'Contains a person\'s full name.'),
                          _buildListItem('2. Father Information', ''),
                          _buildListItem('3. Mother Information', ''),
                          _buildListItem('4. Brothers Information:', ''),
                          _buildListItem('5. Sisters Information', ''),
                          _buildListItem('6. Wife or Husband Information', ''),
                          _buildListItem('7. Daughters Information', ''),
                          _buildListItem('8. Sons Information', ''),
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
            image: AssetImage('images/poland_background.jpg'), // Replace with your image path
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
                Text('$fullName', style: TextStyle(fontSize: 24,color: Colors.white, fontWeight: FontWeight.bold,),),
                SizedBox(height: 15),
                //-----------------------------------------------------------------------------------------
                ExpansionTile(
                  title: Text('Father',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),
                  children: [
                    ...Father.map((text) => ListTile(title: Text(text,style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)))),
                  ],
                ),
                //-----------------------------------------------------------------------------------------
                ExpansionTile(
                  title: Text('Mother',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),
                  children: [
                    ...Mother.map((text) => ListTile(title: Text(text,style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)))),
                  ],
                ),
                //-----------------------------------------------------------------------------------------
                ExpansionTile(
                  title: Text('Brothers',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),
                  children: [
                    ...Brother.map((text) => ListTile(title: Text(text,style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)))),
                  ],
                ),
                //-----------------------------------------------------------------------------------------
                ExpansionTile(
                  title: Text('Sisters',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),
                  children: [
                    ...Sister.map((text) => ListTile(title: Text(text,style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)))),
                  ],
                ),
                //-----------------------------------------------------------------------------------------
                ExpansionTile(
                  title: Text((person.gender == 'M' ? 'Wives' : 'Husband'),style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),
                  children: [
                    ...Wife_Husband.map((text) => ListTile(title: Text(text,style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)))),
                  ],
                ),
                //-----------------------------------------------------------------------------------------
                ExpansionTile(
                  title: Text('Daughters',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),
                  children: [
                    ...Daughter.map((text) => ListTile(title: Text(text,style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)))),
                  ],
                ),
                //-----------------------------------------------------------------------------------------
                ExpansionTile(
                  title: Text('Sons',style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)),
                  children: [
                    ...Son.map((text) => ListTile(title: Text(text,style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)))),
                    ...Son.map((text) => ListTile(title: Text(text,style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.bold)))),
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
  // -------------------------------------------------------------------------------------------------------------------------
  List<String> buildFamilyFrame(String type) {
    List<FamilyRelation> relations = getFamilyRelationsByType(type);
    if (relations.isEmpty) {
      return [];
    }

    List<String> textWidgets = [];

    for (int index = 0; index < relations.length; index++) {
      FamilyRelation relation = relations[index];
      textWidgets.add(get_person_text(findPersonById(relation.personID2), relation.biography));
    }

    return textWidgets;
  }
  // -------------------------------------------------------------------------------------------------------------------------
  List<FamilyRelation> getFamilyRelationsByType(String type) {
    return familyRelations.where((relation) => relation.personID1 == person.personID && relation.type == type).toList();
  }
  Person? findPersonById(int? personID) {
    // Search in the persons list
    Person? personInPersons = persons.firstWhereOrNull((person) => person.personID == personID,);
    // Search in the familyPersons list if not found in persons
    if (personInPersons == null) {
      FamilyPerson? familyPerson = familyPersons.firstWhereOrNull((familyPerson) => familyPerson.personID == personID,);
      // Convert FamilyPerson to Person
      if (familyPerson != null) {
        personInPersons = Person(personID: familyPerson.personID, firstName: familyPerson.firstName, maidenName: familyPerson.maidenName, lastName: familyPerson.lastName, gender: familyPerson.gender, religionID: familyPerson.religionID, dateOfBirth: familyPerson.dateOfBirth, placeBirth: familyPerson.placeBirth, dateOfDeath: familyPerson.dateOfDeath, placeDeath: familyPerson.placeDeath, houseID: familyPerson.houseID, deportedFrom: familyPerson.deportedFrom, deportedTo: familyPerson.deportedTo, dateOfDeport: familyPerson.dateOfDeport, Biography: familyPerson.biography,);
      }
    }
    return personInPersons;
  }
  String get_person_text(Person? p,String? biography){
    if(p==null){return("--");}
    else{
      // full name
      var First_Name = p.firstName ?? "";
      var Maiden_Name = p.maidenName ?? "";
      var Last_Name = p.lastName ?? "";
      var FullName = First_Name + (Maiden_Name.isNotEmpty ? " " + Maiden_Name : "") + (Last_Name.isNotEmpty ? " " + Last_Name : "");
      FullName = FullName.trim();


      // Birth
      var Date_Birth = p.dateOfBirth != null ? DateFormat('yyyy-MM-dd').format(p.dateOfBirth!) : "--";
      var Country_Birth = getCountryName(getCountryNumber(p.placeBirth));
      var City_Birth = getCityName(p.placeBirth);
      var place_Birth = '$City_Birth - $Country_Birth';
      place_Birth = place_Birth == '-- - --' ? '--' : place_Birth;
      var birth;
      if (Date_Birth == '--' && place_Birth != '--')
        birth = 'Born in $place_Birth.';
      else if(Date_Birth != '--' && place_Birth == '--')
        birth = 'Born on $Date_Birth.';
      else if(Date_Birth != '--' && place_Birth != '--')
        birth = 'Born on $Date_Birth in $place_Birth.';
      else if(Date_Birth == '--' && place_Birth == '--')
        birth = '--';


      // Death
      var Date_Death = person.dateOfDeath != null ? DateFormat('yyyy-MM-dd').format(person.dateOfDeath!) : "--";
      var Country_Death = getCountryNameFromConcentrationCamp(p.placeDeath);
      var City_Death = getCityNameFromConcentrationCamp(p.placeDeath);
      var Camp_Death = getConcentrationCampName(p.placeDeath);
      var place_Death = '$Camp_Death - $City_Death - $Country_Death';
      place_Death = place_Death == '-- - -- - --' ? '--' : place_Death;
      var death;
      if (Date_Death == '--' && place_Death != '--')
        death = 'Died in $place_Death.';
      else if(Date_Death != '--' && place_Death == '--')
        death = 'Died on $Date_Death.';
      else if(Date_Death != '--' && place_Death != '--')
        death = 'Died on $Date_Death in $place_Death.';
      else if(Date_Death == '--' && place_Death == '--')
        death = '--';


      // Deported
      var Date_of_Deport = p.dateOfDeport != null ? DateFormat('yyyy-MM-dd').format(p.dateOfDeport!) : "--";
      var Country_Deport_From = getCountryName(getCountryNumber(p.deportedFrom));
      var City_Deport_From = getCityName(p.deportedFrom);
      var Deport_From = '$City_Deport_From - $Country_Deport_From';
      Deport_From = Deport_From == '-- - --' ? '--' : Deport_From;
      var Country_Deport_To = getCountryNameFromConcentrationCamp(p.deportedTo);
      var City_Deport_To = getCityNameFromConcentrationCamp(p.deportedTo);
      var Camp_Deport_To = getConcentrationCampName(p.deportedTo);
      var Deport_To = '$Camp_Deport_To - $City_Deport_To - $Country_Deport_To';
      Deport_To = Deport_To == '-- - -- - --' ? '--' : Deport_To;
      var Deport ;
      if(Deport_From != '--' && Deport_To != '--'&& Date_of_Deport != '--')
        Deport = 'Was deported from $Deport_From to $Deport_To on $Date_of_Deport.';
      else
        Deport = '--';

      // create all text
      var the_person_text="-"+ FullName;
      if(biography != null){
        the_person_text += "\n";
        the_person_text += biography;
      }
      if (birth != '--') {
        the_person_text += "\n";
        the_person_text += birth;
      }
      if (death != '--') {
        the_person_text += "\n";
        the_person_text += death;
      }
      if (Deport != '--') {
        the_person_text += "\n";
        the_person_text += Deport;
      }
      if(p.Biography!= null){
        the_person_text += "\n";
        the_person_text += p.Biography!;
      }
      return(the_person_text);
    }
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
