import 'package:flutter/material.dart';

class TimeSelect extends StatefulWidget {
  final String mainText;
  final bool isSelected;
  final VoidCallback onTap;

  TimeSelect({required this.mainText, required this.isSelected, required this.onTap});

  @override
  _TimeSelectState createState() => _TimeSelectState();
}

class _TimeSelectState extends State<TimeSelect> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Appel de la fonction onTap lorsque le widget est tapé
        widget.onTap();
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width * 0.2700,
        decoration: BoxDecoration(
          color: widget.isSelected
              ? const Color.fromARGB(255, 116, 180, 234)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black12),
        ),
        child: Center(
          child: Text(
            widget.mainText,
            style: TextStyle(
              color: widget.isSelected ? Colors.white : Color.fromARGB(255, 85, 85, 85),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
