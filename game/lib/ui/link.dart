import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";

import "label.dart";

class Link extends StatelessWidget {

  final String link;

  Link({ this.link });

  Widget build(BuildContext context) {
    return GestureDetector(
        child: Label(label: link, fontColor: const Color(0xFF55a894)),
        onTap: () async {
          if (await canLaunch(link)) {
            await launch(link);
          }
        }
    );
  }
}

