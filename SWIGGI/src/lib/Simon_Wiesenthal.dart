import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'Data.dart';

class TimelinePage extends StatefulWidget {
  TimelinePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _TimelinePageState createState() => _TimelinePageState();
}
class _TimelinePageState extends State<TimelinePage> {
  final PageController pageController =
  PageController(initialPage: 1, keepPage: true);
  int pageIx = 1;

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      timelineModel(TimelinePosition.Left),
      timelineModel(TimelinePosition.Center),
      timelineModel(TimelinePosition.Right)
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIx,
        onTap: (i) => pageController.animateToPage(i,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.format_align_left),
            label: "LEFT",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_align_center),
            label: "CENTER",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_align_right),
            label: "RIGHT",
          ),
        ],
      ),
      appBar: AppBar(
        title:  Text('Simon Wiesenthal Life Story',
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
                        _buildSectionHeader('Simon Wiesenthal Life Story'),
                        _buildList([
                          _buildListItem("* This page is show of Simon Wiesenthal Life Story.", ''),
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
      body: PageView(
        onPageChanged: (i) => setState(() => pageIx = i),
        controller: pageController,
        children: pages,
      ),
    );
  }

  timelineModel(TimelinePosition position) => Timeline.builder(
    itemBuilder: (BuildContext context, int index) {
      final LifeStep lifeStep = lifeSteps[index];
      final textTheme = Theme.of(context).textTheme;
      return TimelineModel(
        Card(
          margin: EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: Colors.black, width: 1.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  lifeStep.year,
                  style: textTheme!.headline6!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  lifeStep.title,
                  style: textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (lifeStep.imagePath.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Image.asset(
                      lifeStep.imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  lifeStep.text,
                  style: textTheme.bodyText1!.copyWith(
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        position: index % 2 == 0
            ? TimelineItemPosition.right
            : TimelineItemPosition.left,
        isFirst: index == 0,
        isLast: index == lifeSteps.length - 1,
      );
    },
    itemCount: lifeSteps.length,
    physics: position == TimelinePosition.Left
        ? ClampingScrollPhysics()
        : BouncingScrollPhysics(),
    position: position,
  );
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
