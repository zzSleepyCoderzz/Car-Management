import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:car_management/components/globals.dart' as globals;

class HomeCard extends StatefulWidget {
  const HomeCard({super.key, required this.carNumber});

  final String carNumber;

  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  @override
  Widget build(BuildContext context) {
    
    return globals.carData[widget.carNumber]["Car Model"].contains("Car")
        ? InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: (){
             Navigator.pushNamed(context, '/add_car', arguments: widget.carNumber);
          },
          
          child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.18,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Add a car"),
                    Icon(Icons.add, size: 50)]),
            ),
        )
        : InkWell(
          borderRadius: BorderRadius.circular(20),
            onTap: (){
             Navigator.pushNamed(context, '/add_car', arguments: widget.carNumber);
          },
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
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(globals.carData[widget.carNumber]['Pic']),
                  fit: BoxFit.cover,
                ),
              ),
              child: Card(
                color: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          child: Text(
                            globals.carData[widget.carNumber]['Car Model'],
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
          );
  }
}
