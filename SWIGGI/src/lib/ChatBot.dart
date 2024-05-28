import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Data.dart';
import 'Common_Functions.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'P_Person.dart';

class ChatMessage {
  final String content;
  final Function()? action; // Function to execute when the message is interacted with

  ChatMessage(this.content, {this.action});
}
class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0), // Adjust the height as needed

          child: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // Navigate back when the back button is pressed
              },
            ),
            title: Text('Chat Bot',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
                            _buildSectionHeader('Chat with AI to search person :'),
                            _buildSectionHeader('Write down what you know about the person'),
                            _buildList([
                              _buildListItem("* Because the algorithm does not Corrects words, try not to write down wrong words.", ''),
                              _buildListItem('* Write down words such as name, sex, date of birth, date of death, place of birth (state, city), place of death (state, city), place of residence (state, city, house, road).', ''),
                            ]),
                            _buildSectionHeader('Results Search'),
                            _buildList([
                              _buildListItem("* Shows the algorithm links to people, if I clicked on a person it will take you to their page.", ''),
                              _buildListItem('* Displays the person\'s name and also the similarity percentage with what you wrote.', ''),
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


        ),
        body: ChatScreen(),
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
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<ChatMessage> chatHistory = [ChatMessage("ChatBot: Please provide any information you have about the individual so that I can assist you further.",),];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: chatHistory.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: _buildMessage(chatHistory[index]),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(hintText: 'Type your message...'),
                ),
              ),
              IconButton(
                icon: Icon(Icons.keyboard_voice), // Icon for recording speech
                onPressed: () {
                  // Implement functionality for recording speech
                },
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  sendMessage();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildMessage(ChatMessage message) {
    if (message.content.startsWith("You:")) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
        ),
        child: Text(
          message.content,
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.start,
        ),
      );
    } else if (message.content.startsWith("ChatBot:")) {
      return SizedBox(
        width: double.infinity,
        child: Container(
          color: Colors.black, // Background color
          child: ElevatedButton(
            onPressed: message.action,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.centerLeft,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              backgroundColor: Colors.black, // Change button color to black
            ),
            child: Text(
              message.content,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.start,
            ),
          ),
        ),
      );
    }
    return Container();
  }
  void sendMessage() {
    setState(() {
      String messageText = _controller.text
          .trim(); // Trim any leading or trailing whitespaces

      if (messageText.isNotEmpty) {
        chatHistory.add(
          ChatMessage(
            "You: $messageText",
          ),
        );

        Map<String, int> invertedIndexOfText = convertTextToIndex(messageText);
        _controller.clear();

        List<Map<String, dynamic>> rowItemsWithCosineSimilarity = [];

        for (Map<String, dynamic> rowItem in mergedTable) {
          Map<String, int> invertedIndexOfPerson = buildInvertedIndex(rowItem);
          double cosineSimilarity = CosineSimilarity(
              invertedIndexOfText, invertedIndexOfPerson);
          Map<String, dynamic> rowItemWithCosineSimilarity = {
            'rowItem': rowItem,
            'cosineSimilarity': cosineSimilarity
          };
          rowItemsWithCosineSimilarity.add(rowItemWithCosineSimilarity);
        }

        rowItemsWithCosineSimilarity.sort((a, b) => b['cosineSimilarity'].compareTo(a['cosineSimilarity']));

        int count = 1;
        bool foundRelevantData = false;

        for (var item in rowItemsWithCosineSimilarity) {
          if (item['cosineSimilarity'] > 0 && count <= 5) {

            // select the show value
            String firstName = item['rowItem']['person'].firstName ?? "";
            String maidenName = item['rowItem']['person'].maidenName ?? "";
            String lastName = item['rowItem']['person'].lastName ?? "";
            double similarityPercentage = item['cosineSimilarity'] * 100;
            String formattedSimilarity = similarityPercentage.toStringAsFixed(1);

            // list Of Sen Of Person
            List <String> listOfSenOfPerson =getSenOfPerson(item['rowItem']);
            String Sen =listOfSenOfPerson.join("\n");

            // the word of the user text
            List<String> keysList = invertedIndexOfText.keys.toList();
            Set<String> keysSet = keysList.map((key) => key.toLowerCase()).toSet();

            // Show the sentences Containing Key
            List<String> sentencesContainingKey = [];
            for (String sentence in listOfSenOfPerson) {
              String sentenceLower=sentence.toLowerCase();
              Set<String> wordSet = Set.from(sentenceLower.split(" "));
              Set<String> commonWordsSet = keysSet.intersection(wordSet);
              if(commonWordsSet.length != 0){
                sentencesContainingKey.add(sentence);
              }
            }
            String joinSentencesContainingKey =sentencesContainingKey.join("\n");

            chatHistory.add(
              ChatMessage(
                "ChatBot: $count - $firstName $maidenName $lastName  $formattedSimilarity% \n$joinSentencesContainingKey",
                action: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PPerson(
                            person1: item['rowItem']['person'],
                            house1: item['rowItem']['house'],
                            city1: item['rowItem']['city'],
                            country1: item['rowItem']['country'],
                          ),
                    ),
                  );
                },
              ),
            );
            foundRelevantData = true;
            count++;
          }
        }

        if (!foundRelevantData) {
          chatHistory.add(
            ChatMessage(
              "ChatBot: No relevant data found.",
            ),
          );
        }
      }
    });
  }
  Map<String, int> buildInvertedIndex(Map<String, dynamic> rowItem) {
    List<String> listOfWord = [];

    // 1- Add the name of person in this case and after replaceNonASCIIChars
    listOfWord.addAll(rowItem['person'].firstName?.split(" ") ?? []);
    listOfWord.addAll(rowItem['person'].maidenName?.split(" ") ?? []);
    listOfWord.addAll(rowItem['person'].lastName?.split(" ") ?? []);
    listOfWord.addAll(replaceNonASCIICharsAndSplit(rowItem['person'].firstName));
    listOfWord.addAll(replaceNonASCIICharsAndSplit(rowItem['person'].maidenName));
    listOfWord.addAll(replaceNonASCIICharsAndSplit(rowItem['person'].lastName));

    // 2- add the gender of the person
    listOfWord.add(rowItem['person'].gender == "M" ? "Male" : (rowItem['person'].gender == "F" ? "Female" : "Other"));
    listOfWord.add(rowItem['person'].gender);

    // 3- add a Date
    if (rowItem['person'].dateOfBirth != null) listOfWord.addAll(getFormatDate(rowItem['person'].dateOfBirth));
    if (rowItem['person'].dateOfDeath != null) listOfWord.addAll(getFormatDate(rowItem['person'].dateOfDeath));
    if (rowItem['person'].dateOfDeport != null) listOfWord.addAll(getFormatDate(rowItem['person'].dateOfDeport));

    // 4- place Birth
    listOfWord.addAll(getCityName(rowItem['person'].placeBirth).split(" "));
    listOfWord.addAll(getCountryName(rowItem['person'].placeBirth).split(" "));

    // 5- place Death
    listOfWord.addAll(getConcentrationCampName(rowItem['person'].placeDeath).split(" "));
    listOfWord.addAll(getCityNameFromConcentrationCamp(rowItem['person'].placeDeath).split(" "));
    listOfWord.addAll(getCountryNameFromConcentrationCamp(rowItem['person'].placeDeath).split(" "));

    // 6- deported From
    listOfWord.addAll(getCityName(rowItem['person'].deportedFrom).split(" "));
    listOfWord.addAll(getCountryName(rowItem['person'].deportedFrom).split(" "));

    // 7- deported To
    listOfWord.addAll(getConcentrationCampName(rowItem['person'].deportedTo).split(" "));
    listOfWord.addAll(getCityNameFromConcentrationCamp(rowItem['person'].deportedTo).split(" "));
    listOfWord.addAll(getCountryNameFromConcentrationCamp(rowItem['person'].deportedTo).split(" "));

    // 8- Lived
    listOfWord.addAll(rowItem['house'].streetName.split(" ") ?? []);
    listOfWord.addAll(rowItem['house'].houseNumber.toString().split(" "));
    listOfWord.addAll(rowItem['quarter'].quarterName.split(" ") ?? []);
    listOfWord.addAll(rowItem['quarter'].quarterNumber.toString().split(" "));
    listOfWord.addAll(rowItem['city'].cityName.split(" ") ?? []);
    listOfWord.addAll(rowItem['country'].countryName.split(" ") ?? []);

    // Convert alphabetical elements to lowercase and remove "--"
    listOfWord = listOfWord.map((element) {
      if (element.contains(RegExp(r'[a-zA-Z]'))) {return element.toLowerCase();
      } else {return element;}
    }).where((element) => element != "--").toList();

    Map<String, int> wordCountMap = listOfWord.fold({}, (Map<String, int> map, String word) => map..update(word, (value) => value + 1, ifAbsent: () => 1));

    return (wordCountMap);
  }
  Map<String, int> convertTextToIndex(String text) {
    // Split the text into individual words and convert only alphabetical words to lowercase
    List<String> words = text.split(RegExp(r'\s+'))
        .map((word) => word.replaceAllMapped(
        RegExp(r'[a-zA-Z]+'), (match) => match.group(0)!.toLowerCase()))
        .toList();

    // Count occurrences of each word
    Map<String, int> wordCountMap = words.fold(
        {}, (Map<String, int> map, String word) =>
    map
      ..update(word, (value) => value + 1, ifAbsent: () => 1));

    return wordCountMap;
  }
  double dotProduct(Map<String, int> vector1, Map<String, int> vector2) {
    double dotProduct = 0;
    for (var key in vector1.keys) {
      if (vector2.containsKey(key)) {
        dotProduct += vector1[key]! * vector2[key]!;
      }
    }
    return dotProduct;
  }
  double magnitude(Map<String, int> vector) {
    double sumOfSquares = 0;
    for (var value in vector.values) {
      sumOfSquares += value * value;
    }
    return sqrt(sumOfSquares);
  }
  double CosineSimilarity(Map<String, int> vector1, Map<String, int> vector2) {
    double dot = dotProduct(vector1, vector2);
    double mag1 = magnitude(vector1);
    double mag2 = magnitude(vector2);

    // Handle division by zero
    if (mag1 == 0 || mag2 == 0) {
      return 0;
    }

    return dot / (mag1 * mag2);
  }
  List<String> replaceNonASCIICharsAndSplit(String? str) {
    if (str == null) return [];

    Map<String, String> charMap = {
      'á': 'a', 'à': 'a', 'â': 'a', 'ä': 'a', 'å': 'a', 'æ': 'ae', 'ã': 'a',
      'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e', 'æ': 'ae',
      'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i', 'ĳ': 'ij', 'ī': 'i', 'į': 'i',
      'ó': 'o', 'ò': 'o', 'ô': 'o', 'ö': 'o', 'ø': 'o', 'œ': 'oe', 'õ': 'o', 'ō': 'o',
      'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u', 'ū': 'u', 'ų': 'u', 'ů': 'u', 'ű': 'u',
      'ÿ': 'y', 'ý': 'y',
      'ñ': 'n', 'ç': 'c', 'ć': 'c', 'č': 'c',
      'ß': 'ss', 'ś': 's', 'š': 's',
      'ž': 'z', 'ź': 'z', 'ż': 'z',
      // Uppercase letters
      'Á': 'A', 'À': 'A', 'Â': 'A', 'Ä': 'A', 'Å': 'A', 'Æ': 'AE', 'Ã': 'A',
      'É': 'E', 'È': 'E', 'Ê': 'E', 'Ë': 'E',
      'Í': 'I', 'Ì': 'I', 'Î': 'I', 'Ï': 'I', 'Ĳ': 'IJ', 'Ī': 'I', 'Į': 'I',
      'Ó': 'O', 'Ò': 'O', 'Ô': 'O', 'Ö': 'O', 'Ø': 'O', 'Œ': 'OE', 'Õ': 'O', 'Ō': 'O',
      'Ú': 'U', 'Ù': 'U', 'Û': 'U', 'Ü': 'U', 'Ů': 'U', 'Ų': 'U', 'Ű': 'U',
      'Ÿ': 'Y', 'Ý': 'Y',
      'Ñ': 'N', 'Ç': 'C', 'Ć': 'C', 'Č': 'C',
      'Ś': 'S', 'Š': 'S',
      'Ž': 'Z', 'Ź': 'Z', 'Ż': 'Z',
    };

    // Replace non-ASCII characters with their ASCII equivalents
    String replacedString = '';
    for (int i = 0; i < str.length; i++) {
      String char = str[i];
      String? replacement = charMap[char];
      if (replacement != null) {
        replacedString += replacement;
      } else if (char.runes.any((rune) => rune < 0 || rune > 127)) {
        continue;
      } else {
        replacedString += char;
      }
    }

    // Split the replaced string into words and return as a list
    return replacedString.split(" ");
  }
  List<String> getFormatDate(DateTime dateTime){
    List<String> allFormat=[];
    allFormat.add(DateFormat('yyyy-MM-dd').format(dateTime));
    allFormat.add(DateFormat('dd-MM-yyyy').format(dateTime));
    allFormat.add(DateFormat('d-M-yyyy').format(dateTime));

    allFormat.add(DateFormat('d').format(dateTime));
    allFormat.add(DateFormat('M').format(dateTime));
    allFormat.add(DateFormat('dd').format(dateTime));
    allFormat.add(DateFormat('MM').format(dateTime));
    allFormat.add(DateFormat('yyyy').format(dateTime));

    allFormat.add(DateFormat('yyyy/MM/dd').format(dateTime));
    allFormat.add(DateFormat('dd/MM/yyyy').format(dateTime));
    allFormat.add(DateFormat('d/M/yyyy').format(dateTime));

    // Manually mapping the month names
    List<String> monthNamesAbbr = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    List<String> monthNamesFull = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    allFormat.add(monthNamesAbbr[dateTime.month - 1]);
    allFormat.add(monthNamesFull[dateTime.month - 1]);

    return(allFormat);
  }
  List<String> getFormatDateSen(DateTime dateTime , String typDate){
    List<String> allFormat=[];

    String d1=DateFormat('yyyy-MM-dd').format(dateTime);
    String d2=DateFormat('dd-MM-yyyy').format(dateTime);
    String d3=DateFormat('d-M-yyyy').format(dateTime);
    allFormat.add("$typDate Date is $d1");
    allFormat.add("$typDate Date is $d2");
    allFormat.add("$typDate Date is $d3");

    String d4=DateFormat('d').format(dateTime);
    allFormat.add("$typDate Day is $d4");
    String d5=DateFormat('M').format(dateTime);
    allFormat.add("$typDate Month is $d5");
    String d6=DateFormat('dd').format(dateTime);
    allFormat.add("$typDate Day is $d6");
    String d7=DateFormat('MM').format(dateTime);
    allFormat.add("$typDate Month is $d7");
    String d8=DateFormat('yyyy').format(dateTime);
    allFormat.add("$typDate Year is $d8");

    String d9=DateFormat('yyyy/MM/dd').format(dateTime);
    String d10=DateFormat('dd/MM/yyyy').format(dateTime);
    String d11=DateFormat('d/M/yyyy').format(dateTime);
    allFormat.add("$typDate Date is $d9");
    allFormat.add("$typDate Date is $d10");
    allFormat.add("$typDate Date is $d11");

    // Manually mapping the month names
    List<String> monthNamesAbbr = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    List<String> monthNamesFull = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    String d12=monthNamesAbbr[dateTime.month - 1];
    String d13=monthNamesFull[dateTime.month - 1];
    allFormat.add("$typDate Month is $d12");
    allFormat.add("$typDate Month is $d13");

    return(allFormat);
  }
  List<String> getSenOfPerson (Map<String, dynamic> rowItem){
    List<String> listOfSen = [];

    // 1- Add the name of person in this case and after replaceNonASCIIChars
    String FnBefore =rowItem['person'].firstName;
    String FnAfter =replaceNonASCIICharsAndSplit(rowItem['person'].firstName).join(" ");
    listOfSen.add("First Name is $FnBefore");
    listOfSen.add("First Name is $FnAfter");
    String MnBefore = rowItem['person'].maidenName ?? '';
    String MnAfter =replaceNonASCIICharsAndSplit(rowItem['person'].maidenName).join(" ");
    listOfSen.add("Maiden Name is $MnBefore");
    listOfSen.add("Maiden Name is $MnAfter");
    String LnBefore =rowItem['person'].lastName;
    String LnAfter =replaceNonASCIICharsAndSplit(rowItem['person'].lastName).join(" ");
    listOfSen.add("Last Name is $LnBefore");
    listOfSen.add("Last Name is $LnAfter");

    // 2- add the gender of the person
    String Gender1 =rowItem['person'].gender == "M" ? "Male" : (rowItem['person'].gender == "F" ? "Female" : "Other");
    String Gender2 =rowItem['person'].gender;
    listOfSen.add("Gender is $Gender1");
    listOfSen.add("Gender is $Gender2");

    // 3- add a Date
    if (rowItem['person'].dateOfBirth != null) listOfSen.addAll(getFormatDateSen(rowItem['person'].dateOfBirth,'Birth'));
    if (rowItem['person'].dateOfDeath != null) listOfSen.addAll(getFormatDateSen(rowItem['person'].dateOfDeath, 'Death'));
    if (rowItem['person'].dateOfDeport != null) listOfSen.addAll(getFormatDateSen(rowItem['person'].dateOfDeport,'Deport'));


    // 4- place Birth
    String CityBirth =getCityName(rowItem['person'].placeBirth);
    String CountryBirth =getCountryName(rowItem['person'].placeBirth);
    listOfSen.add("City of Birth $CityBirth");
    listOfSen.add("Country of Birth $CountryBirth");

    // 5- place Death
    String CityDeath =getCityNameFromConcentrationCamp(rowItem['person'].placeDeath);
    String CountryDeath =getCountryNameFromConcentrationCamp(rowItem['person'].placeDeath);
    String CampDeath =getConcentrationCampName(rowItem['person'].placeDeath);
    listOfSen.add("City of Death $CityDeath");
    listOfSen.add("Country of Death $CountryDeath");
    listOfSen.add("Camp of Death $CampDeath");

    // 6- deported From
    String CityDeportedFrom =getCityName(rowItem['person'].deportedFrom);
    String CountryDeportedFrom =getCountryName(rowItem['person'].deportedFrom);
    listOfSen.add("City of Deported From $CityDeportedFrom");
    listOfSen.add("Country of Deported From $CountryDeportedFrom");

    // 7- deported To
    String CityDeportedTo =getCityNameFromConcentrationCamp(rowItem['person'].deportedTo);
    String CountryDeportedTo =getCountryNameFromConcentrationCamp(rowItem['person'].deportedTo);
    String CampDeportedTo =getConcentrationCampName(rowItem['person'].deportedTo);
    listOfSen.add("City of Deported To $CityDeportedTo");
    listOfSen.add("Country of Deported To $CountryDeportedTo");
    listOfSen.add("Camp of Deported To $CampDeportedTo");

    // 8- Lived
    String houseLived = rowItem['house'].streetName;
    String streetLived = rowItem['house'].houseNumber.toString();
    String quarterLived1 = rowItem['quarter'].quarterName;
    String quarterLived2 = rowItem['quarter'].quarterNumber.toString();
    String cityLived = rowItem['city'].cityName;
    String countryLived = rowItem['country'].countryName;
    listOfSen.add("House Lived $houseLived");
    listOfSen.add("Street Lived $streetLived");
    listOfSen.add("Quarter Lived $quarterLived1");
    listOfSen.add("Quarter Lived $quarterLived2");
    listOfSen.add("city Lived $cityLived");
    listOfSen.add("country Lived $countryLived");

    List<String> filteredSentences = listOfSen.where((sentence) => !sentence.contains('--')).toList();

    return(filteredSentences.toSet().toList());
  }
}