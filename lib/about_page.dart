import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class about_page extends StatelessWidget {
  Widget build(BuildContext context) {
    return Center(
      child: ListView(shrinkWrap: true, children: [
        Center(
          child: Column(
            children: [
              Container(
                  width: 250,
                  decoration: BoxDecoration(
                    color: Colors.yellow[600],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 4,
                        offset: Offset(4, 8), // Shadow position
                      ),
                    ],
                  ),
                  child: Text(
                      "This is an app for you to look at the Besquare Posts!."))
            ],
          ),
        ),
      ]),
    );
  }
}
