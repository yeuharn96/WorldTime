import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';
import 'package:world_time/shared/clock_time.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Map data = {};

  void initTime() async{
    WorldTime wt = WorldTime(url: 'Asia/Singapore', flag: 'sg');
    await wt.getTime();

    setState(() {
      data = wt.getData();
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      initTime();
    });
  }

  @override
  Widget build(BuildContext context) {

    var isDayTime = data['isDayTime'] ?? true;
    Color bgColor = isDayTime ? Colors.white : Colors.black;
    Color textColor = isDayTime ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/${isDayTime ? 'day' : 'night'}.jpg'),
                  fit: BoxFit.cover
              ),
            ),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    (data.isEmpty ?
                    CircularProgressIndicator(color: Colors.black,) :
                    data['time'].toString().length == 0 ?
                    Center(child: Text(data['location'], style: TextStyle(color: Colors.red[700], fontSize: 30))) :
                    ClockTime(location: data['location'], time: data['time'], textColor: textColor,)
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        dynamic result = await Navigator.pushNamed(context, '/location');
                        // data.clear();
                        if(result != null){
                          setState(() {
                            data = result as Map;
                          });
                        }
                      },
                      icon: Icon(
                        Icons.edit_location,
                        color: textColor,
                        size: 20,
                      ),
                      label: Text(
                        'Edit Location',
                        style: TextStyle(color: textColor, fontSize: 20),
                      ),
                    ),
                  ]
              ),
            ),
          )
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: bgColor,
        unselectedItemColor: textColor,
        selectedItemColor: Colors.amber,
        showUnselectedLabels: true,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.ac_unit), label: 'MineSweeper'),
          BottomNavigationBarItem(icon: Icon(Icons.all_inclusive), label: 'Snake'),
          BottomNavigationBarItem(icon: Icon(Icons.circle_outlined), label: 'TicTacToe')
        ],
        onTap: (int index){
          String route = '';
          switch(index){
            case 1: route = '/minesweeper'; break;
            case 2: route = '/snake'; break;
            case 3: route = '/tictactoe'; break;
          }

          if(route.length > 0)
            Navigator.pushNamed(context, route);
        },
      ),
    );
  }
}

