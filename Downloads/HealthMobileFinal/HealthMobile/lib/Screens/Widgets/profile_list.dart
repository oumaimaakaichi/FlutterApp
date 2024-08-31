import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class profile_list extends StatelessWidget {
  const profile_list({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  // Define your color variables here
  final Color tPrimaryColor = Colors.blue; // Example color
  final Color tAccentColor = Colors.red; // Example color

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Icon(
        icon,

        color: Color.fromARGB(255, 116, 180, 234),  // Set the color of the icon
      ),
      title: Text(title, style: Theme.of(context).textTheme.bodyText1?.apply(color: textColor)),
      trailing: endIcon
          ? Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: const Icon(LineAwesomeIcons.angle_right, size: 18.0, color: Colors.grey))
          : null,
    );
  }

}
