import 'package:http/http.dart';
import 'dart:convert';

import 'package:intl/intl.dart';

class WorldTime {
  late String location;
  late String time;
  late bool isDayTime = true;
  String url;
  String flag;

  WorldTime({required this.url, required this.flag}){
    this.location = this.url.substring(this.url.lastIndexOf('/') + 1).replaceAll('_', ' ');
  }

  Future<void> getTime() async{
    try{
      var uri = Uri.parse('http://worldtimeapi.org/api/timezone/$url');
      Response response = await get(uri);
      Map data = jsonDecode(response.body);
      print(data);

      String datetime = data['utc_datetime'];
      String offset = data['utc_offset'].substring(0,3);

      DateTime now = DateTime.parse(datetime);
      now = now.add(Duration(hours: int.parse(offset)));
      time = DateFormat.jm().format(now);
      isDayTime = now.hour >= 6 && now.hour < 18;
      // print('hour >>> ${now.hour}');
    }
    catch (e) {
      print('caught error: $e');
      time = '';
      location = 'Could not get time data.';
    }
  }

  Map getData(){
    return {
      'time': time,
      'location': location,
      'isDayTime': isDayTime
    };
  }
}
