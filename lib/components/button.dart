import 'package:flutter/material.dart';
import 'package:html/parser.dart';

class LoginButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const LoginButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,
        height: MediaQuery.of(context).size.height * 0.08,
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class MaintenanceButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const MaintenanceButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                // Change the surface ripple color here
                return Colors.grey
                    .withOpacity(0.5); // Example: Red with 50% opacity
              }
              // Return null to fallback to the default ripple color
              return Colors.grey.withOpacity(0.5);
            },
          ),
          backgroundColor:
              MaterialStateProperty.all(Color.fromRGBO(0, 0, 0, 1)),
          minimumSize: MaterialStateProperty.all<Size>(
              const Size(200, 50)), // Adjust as needed
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),)) // Adjust as needed
          ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color.fromRGBO(255, 255, 255, 1),
          fontSize: 16,
        ),
      ),
    );
  }
}

class GeneralButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final String color;

  const GeneralButton({super.key, required this.onTap, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                // Change the surface ripple color here
                return Colors.grey
                    .withOpacity(0.5); 
              }
              // Return null to fallback to the default ripple color
              return Colors.grey.withOpacity(0.5);
            },
          ),
          backgroundColor: MaterialStateProperty.all(Color(int.parse(color))),
          minimumSize: MaterialStateProperty.all<Size>(
              const Size(100, 50)), // Adjust as needed
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),)) // Adjust as needed
          ),
      onPressed: onTap,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(255, 255, 255, 1),
          fontSize: 16,
        ),
      ),
    );
  }
}
