import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeCard extends StatefulWidget {
  const HomeCard({super.key, required this.carName});

  final String carName;

  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  @override
  Widget build(BuildContext context) {
    return widget.carName != "Car" ? InkWell(
      onTap: () {
        
      },
      overlayColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              // Change the surface ripple color here
              return Colors.grey.withOpacity(0.5); // Example: Grey with 50% opacity
            }
            // Return null to fallback to the default ripple color
            return Colors.grey.withOpacity(0.5);;
          },
        ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.18,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: NetworkImage(
                "https://images.unsplash.com/photo-1566008885218-90abf9200ddb?q=80&w=1932&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
            fit: BoxFit.cover,
            
          ),
        ),
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end, 
            crossAxisAlignment: CrossAxisAlignment.start,
            children: 
            
            [
            Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Text(
                  widget.carName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    ) : Text("ADD A CAR");
  }
}
