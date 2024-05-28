import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ChatBot.dart';
import 'SS_Select.dart';
import 'SH_Select.dart';
import 'SF_Select.dart';
import 'SP_Select.dart';
import 'GL_World.dart';
import 'Simon_Wiesenthal.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SWIGGI Home Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // Show SplashScreen initially
    );
  }
}
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  bool showImage = false;
  bool showArrow = false;
  bool showText1 = false;
  bool showText2 = false;
  bool showText3 = false;
  bool showText4 = false;
  bool showSkip = false;
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {setState(() {showImage = true;});});
    Timer(Duration(seconds: 2), () {setState(() {showText1 = true;});});
    Timer(Duration(seconds: 3), () {setState(() {showSkip = true;});});
    Timer(Duration(seconds: 5), () {setState(() {showText2 = true;});});
    Timer(Duration(seconds: 8), () {setState(() {showText3 = true;});});
    Timer(Duration(seconds: 11), () {setState(() {showText4 = true;});});
    Timer(Duration(seconds: 13), () {setState(() {showArrow = true; showSkip=false;});});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey, // Change the background color if needed
      body: Stack(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 100.0),
                Padding(padding: EdgeInsets.only(), child: Text('SWIGGI APP', style: TextStyle(fontSize: 24,color: Colors.white, fontWeight: FontWeight.bold,),),),
                SizedBox(height: 40.0),
                if (showImage)
                  Padding(padding: EdgeInsets.only(), child: Image.asset('images/SWIGGI_LOGO.png',),),
                SizedBox(height: 40.0),
                if (showText1)
                  Padding(padding: EdgeInsets.only(), child: Text('🌐 Welcome to SWIGGI – the Simon Wiesenthal Genealogy Geolocation Initiative. Discover ancestral homes and explore family trees with ease.', style: TextStyle(fontSize: 20,color: Colors.white, fontWeight: FontWeight.bold),),),
                SizedBox(height: 20.0),
                if (showText2)
                  Padding(padding:EdgeInsets.only(), child: Text('🕯️ Unveil Holocaust memorial pages and connect to the past like never before.', style: TextStyle(fontSize: 20,color: Colors.white, fontWeight: FontWeight.bold,),),),
                SizedBox(height: 20.0),
                if (showText3)
                  Padding(padding:EdgeInsets.only(), child: Text('🔍 Search by names, addresses, and professions, accessing diverse records effortlessly.', style: TextStyle(fontSize: 20,color: Colors.white, fontWeight: FontWeight.bold,),),),
                SizedBox(height: 20.0),
                if (showText4)
                  Padding(padding: EdgeInsets.only(), child: Text('📜 Experience historys intersection with technology with SWIGGI.', style: TextStyle(fontSize: 20,color: Colors.white, fontWeight: FontWeight.bold,),),),
              ],
            ),
          ),
          Positioned(
            bottom: 15,
            right: 2,
            child: Visibility(
              visible: showArrow,
              child: GestureDetector(
                onTap: () {
                  // Navigate to the main page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage(title: 'SWIGGI Home Page')),
                  );
                },
                child: Icon(
                  Icons.arrow_forward,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            right: 2,
            child: Visibility(
              visible: showSkip,
              child: GestureDetector(
                onTap: () {
                  // Navigate to the main page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage(title: 'SWIGGI Home Page')),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Skip the explanation',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),


        ],
      ),
    );
  }
}
class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),), backgroundColor: Colors.grey,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('How to Use This Page'),
                  content: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8, // Set max height for the dialog
                    child: SingleChildScrollView( // Wrap content in SingleChildScrollView
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Welcome to the Holocaust Information Page!',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'This page serves as a comprehensive resource for information related to the Holocaust. Here\'s what you can find here:',
                          ),
                          SizedBox(height: 20),
                          _buildSectionHeader('Explore the Holocaust:'),
                          _buildList([
                            _buildListItem('Fast Searches', 'Quickly find information about specific individuals, locations, and families associated with the Holocaust.'),
                            _buildListItem('General Look', 'View a summary of worldwide data and historical context related to the Holocaust.'),
                            _buildListItem('Simon Wiesenthal', 'Learn about Simon Wiesenthal, the founder of the site, and his contributions to Holocaust remembrance.'),
                            _buildListItem('Chat Search Person', 'Engage in a chat interface to search for individuals related to the Holocaust.'),
                          ]),
                          SizedBox(height: 20),
                          Text(
                            'Feel free to explore and learn more about the Holocaust through the various features available!',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'The Holocaust was a tragic period in human history during World War II when millions of Jews and other marginalized groups were persecuted and murdered by the Nazi regime. Remembering the Holocaust is crucial to honor the victims and ensure that such atrocities are never forgotten or repeated.',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/poland_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 12),
                Text(
                  'May the memory of Simon Wiesenthal be a blessing to all those who believe in Justice, in Tolerance and in Humanity.',
                  style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 25),
                Text(
                  'Fast Search',
                  style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => SPSelect()),);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                          fixedSize: Size(10, 60),
                        ),
                        child: Text('Person', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 22),),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SSSelect()),);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                          fixedSize: Size(10, 60),
                        ),
                        child: Text('Street', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SHSelect()),);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                          fixedSize: Size(10, 60),
                        ),
                        child: Text('House', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SFSelect()),);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                          fixedSize: Size(10, 60),
                        ),
                        child: Text('Family', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => GLWorld()),);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                    fixedSize: Size(10, 60),
                  ),
                  child: Text('General Look', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TimelinePage()),);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                    fixedSize: Size(10, 60),
                  ),
                  child: Text('Simon Wiesenthal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage()),);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                    fixedSize: Size(10, 60),
                  ),
                  child: Text('Chat Search Person', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),),
                ),
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
