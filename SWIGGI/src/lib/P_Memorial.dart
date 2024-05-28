import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Data.dart';
import 'package:intl/intl.dart';
import 'Common_Functions.dart';
import 'package:video_player/video_player.dart';

class PMemorialPage extends StatefulWidget {
  final Person person;
  final House house;
  final City city;
  final Country country;

  PMemorialPage({
    required this.person,
    required this.house,
    required this.city,
    required this.country,
  });

  @override
  _PMemorialPageState createState() => _PMemorialPageState();
}

class _PMemorialPageState extends State<PMemorialPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('images/candle_Video.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    var matchingEntries = mergedTable.where((entry) =>
    entry['person']?.personID == widget.person.personID &&
        entry['house']?.houseId == widget.house.houseId &&
        entry['country']?.countryNumber == widget.country.countryNumber &&
        entry['city']?.cityNumber == widget.city.cityNumber &&
        entry['house']?.streetName == widget.house.streetName,);
    var firstEntry = matchingEntries.isNotEmpty ? matchingEntries.first : null;

    // Name
    var First_Name = widget.person.firstName ?? "";
    var Maiden_Name = widget.person.maidenName ?? "";
    var Last_Name = widget.person.lastName ?? "";
    var FullName =
        First_Name + (Maiden_Name.isNotEmpty ? " " + Maiden_Name : "") + (Last_Name.isNotEmpty ? " " + Last_Name : "");
    FullName = FullName.trim();

    // Gender
    var Gender = widget.person.gender == "M" ? "Male" : (widget.person.gender == "F" ? "Female" : widget.person.gender);

    // Date_Birth and Date_Death
    var Date_Birth = widget.person.dateOfBirth != null ? DateFormat('yyyy-MM-dd').format(widget.person.dateOfBirth!) : "--";
    var Date_Death = widget.person.dateOfDeath != null ? DateFormat('yyyy-MM-dd').format(widget.person.dateOfDeath!) : "--";

    // place_birth and place_Death
    var Country_Birth = getCountryName(getCountryNumber(matchingEntries?.first['person']?.placeBirth));
    var City_Birth = getCityName(matchingEntries?.first['person']?.placeBirth);
    var place_Birth = '$City_Birth - $Country_Birth';
    place_Birth = place_Birth == '-- - --' ? '--' : place_Birth;

    var Country_Death = getCountryNameFromConcentrationCamp(matchingEntries?.first['person']?.placeDeath);
    var City_Death = getCityNameFromConcentrationCamp(matchingEntries?.first['person']?.placeDeath);
    var Camp_Death = getConcentrationCampName(matchingEntries?.first['person']?.placeDeath);
    var place_Death = '$Camp_Death - $City_Death - $Country_Death';
    place_Death = place_Death == '-- - -- - --' ? '--' : place_Death;

    // Deported
    var Date_of_Deport = widget.person.dateOfDeport != null ? DateFormat('yyyy-MM-dd').format(widget.person.dateOfDeport!) : "--";
    var Country_Deport_From = getCountryName(getCountryNumber(matchingEntries?.first['person']?.deportedFrom));
    var City_Deport_From = getCityName(matchingEntries?.first['person']?.deportedFrom);
    var Deport_From = '$City_Deport_From - $Country_Deport_From';
    Deport_From = Deport_From == '-- - --' ? '--' : Deport_From;
    var Country_Deport_To = getCountryNameFromConcentrationCamp(matchingEntries?.first['person']?.deportedTo);
    var City_Deport_To = getCityNameFromConcentrationCamp(matchingEntries?.first['person']?.deportedTo);
    var Camp_Deport_To = getConcentrationCampName(matchingEntries?.first['person']?.deportedTo);
    var Deport_To = '$Camp_Deport_To - $City_Deport_To - $Country_Deport_To';
    Deport_To = Deport_To == '-- - -- - --' ? '--' : Deport_To;
    var Biography_deported = 'Was deported from $Deport_From to $Deport_To on $Date_of_Deport';

    // lived
    var House_Lived = widget.house.houseNumber ?? "--";
    var Street_Lived = widget.house.streetName ?? "--";
    var Quarter_Lived = "${firstEntry?['quarter']?.quarterName ?? '--'} ${firstEntry?['quarter']?.quarterNumber ?? '--'}";
    var City_Lived = widget.city.cityName ?? "--";
    var Country_Lived = widget.country.countryName ?? "--";
    var Biography_Lived = 'Last address in $Country_Lived - $City_Lived was $Street_Lived $House_Lived, $Quarter_Lived';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Memorial Page',
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
                        _buildSectionHeader('Memorial about the person'),
                        _buildList([
                          _buildListItem('1. Name person:', 'Contains a person\'s full name.'),
                          _buildListItem('2. Light a Candle:', 'can Light a Candle for a person.'),
                          _buildListItem('3. Birth Information:', 'Contains place and date of birth for a person.'),
                          _buildListItem('4. Death Information:', 'Contains place and date of death for a person.'),
                          _buildListItem('5. Place of commemoration:', 'Contains place of commemoration for a person.'),
                          _buildListItem('6. Biography:', 'Contains information about the person.'),
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
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'images/poland_background.jpg', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  // ----------------------  ----------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Add some space between candle and full name
                      Expanded(
                        child: Text(
                          FullName,
                          style: TextStyle(fontSize: 24,color: Colors.white, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  // ---------------------- first row (image_candle and full_name and image_person) ----------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Video Player Widget
                      _controller.value.isInitialized
                          ? Column(
                        children: [
                          Container(
                            height: 150,
                            width: 150,
                            child: AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            ),
                          ),
                          // Button to play/pause the video
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (_controller.value.isPlaying) {
                                  _controller.pause();
                                } else {
                                  _controller.play();
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.grey, // Set background color to black
                              minimumSize: Size(150, 30), // Set the width of the button to 150
                            ),
                            child: Text(
                              "Light a Candle",
                              style: TextStyle(
                                color: Colors.white, // White text color
                              ),
                            ),
                          ),
                        ],
                      )
                          : CircularProgressIndicator(), // Show loading indicator while video is loading

                      SizedBox(width: 50), // Add some space between button and circular avatar
                      CircleAvatar(
                        backgroundImage: AssetImage(
                          Gender == "Male"
                              ? 'images/Memorial_Male.png'
                              : (Gender == "Female"
                              ? 'images/Memorial_Female.png'
                              : 'images/Memorial_Male.png'),
                        ),
                        radius: 90,
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  // ---------------------- second row (Birth, Date_Birth, place_Birth & Death, Date_Death, place_Death) ----------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // First part (Birth, Date_Birth, place_Birth)
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Birth',
                              style: TextStyle(fontSize: 18,color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '$Date_Birth',
                              style: TextStyle(fontSize: 18,color: Colors.white),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '$place_Birth',
                              style: TextStyle(fontSize: 18,color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      // Second part (Death, Date_Death, place_Death)
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Death',
                              style: TextStyle(fontSize: 18,color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '$Date_Death',
                              style: TextStyle(fontSize: 18,color: Colors.white),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '$place_Death',
                              style: TextStyle(fontSize: 18,color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  // ---------------------- third row ("Place of commemoration: Vienna, Austria") ----------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Place of commemoration:',
                        style: TextStyle(fontSize: 18,color: Colors.white ,fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Vienna, Austria',
                        style: TextStyle(fontSize: 18,color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  // ---------------------- fourth row ("Place of commemoration: Vienna, Austria") ----------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Biography',
                        style: TextStyle(fontSize: 18,color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  // ---------------------- fifth row ("Biography_deported") ----------------------
                  if(!((Deport_From == '--') && (Deport_To == '--') && (Date_of_Deport == '--')))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8, // Adjust the width as needed
                          child: Text(
                            '$Biography_deported',
                            style: TextStyle(fontSize: 18,color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  // ---------------------- sixth row ("Biography_Lived") ----------------------
                  if(!((Country_Lived == '--') && (City_Lived == '--') && (Street_Lived == '--') && (House_Lived == '--') && (Quarter_Lived == '--')))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8, // Adjust the width as needed
                          child: Text(
                            '$Biography_Lived',
                            style: TextStyle(fontSize: 18,color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  // ---------------------- seventh row ("Biography_all") ----------------------
                  if (widget.person.Biography != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8, // Adjust the width as needed
                          child: Text(
                            widget.person.Biography!,
                            style: TextStyle(fontSize: 18,color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  // ---------------------- end ----------------------
                  SizedBox(height: 300),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
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

