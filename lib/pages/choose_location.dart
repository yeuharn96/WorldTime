import 'package:flutter/material.dart';

import 'package:world_time/services/world_time.dart';
import 'package:world_time/shared/location.dart';

class ChooseLocation extends StatefulWidget {
  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  final List<WorldTime> locations = [
    WorldTime(url: 'Asia/Singapore', flag: 'sg'),
    WorldTime(url: 'Asia/Kuala_Lumpur', flag: 'my'),
    WorldTime(url: 'Europe/London', flag: 'gb'),
    WorldTime(url: 'America/Los_Angeles', flag: 'us')
  ];

  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {

      Future ft = Future((){});
      for (int i = 0; i < locations.length; i++) {
        ft = ft.then((_) {
          return Future.delayed(Duration(milliseconds: 100), (){
            _listKey.currentState!.insertItem(i, duration: Duration(milliseconds: 500));
          });
        });
      }
    });
  }

  Tween<Offset> _offset = Tween(begin: Offset(1,0), end: Offset(0,0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Choose a Location'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
        child: AnimatedList(
          key: _listKey,
            // initialItemCount: 0,
            itemBuilder: (context, index, animation) {
              return SlideTransition(
                  child: Location(wt: locations[index]),
                  position: animation.drive(_offset),
              );
            }
        )
      ),
    );
  }
}
