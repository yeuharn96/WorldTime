import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';
import 'package:world_time/shared/flag.dart';
import 'package:world_time/shared/heart.dart';
import 'package:world_time/utils/common.dart';

class Location extends StatefulWidget {
  final WorldTime wt;

  const Location({required this.wt});

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          onTap: () async {
            print(widget.wt.location);

            showLoadingDialog(context);
            await widget.wt.getTime();
            Navigator.pop(context); // pop loading dialog
            Navigator.pop(context, widget.wt.getData()); // back to home page
          },
          title: Text(widget.wt.location),
          leading: Flag(flag: widget.wt.flag,),
          trailing: Heart()
        // leading: Image.network('https://www.countryflags.io/${widget.wt.flag}/flat/64.png'),
      ),
    );
  }
}
