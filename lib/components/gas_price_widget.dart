import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class GasPriceWidget extends StatefulWidget {
  const GasPriceWidget({super.key});

  @override
  _GasPriceWidgetState createState() => _GasPriceWidgetState();
}

class _GasPriceWidgetState extends State<GasPriceWidget> {
  Map<String, String> gasPrices = {};

  @override
  void initState() {
    super.initState();
    fetchGasPrices();
  }

  Future<void> fetchGasPrices() async {
    try {
      String url =
          'https://corsproxy.io/?https://www.motorist.my/petrol-prices/'; //CORS Proxy
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var document = parser.parse(response.body);
        final elements = document
            .querySelectorAll('.d-flex.justify-content-between.p-3.font-chart');

        Map<String, String> prices = {};
        for (var element in elements) {
          var fuelType = element.children[0].text.trim();
          var price = element.children[1].text.trim();
          prices[fuelType] = price;
        }

        setState(() {
          gasPrices = prices;
        });
      } else {
        throw Exception('Failed to load the latest gas prices');
      }
    } catch (e) {
      throw Exception('Failed to load the latest gas prices: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return gasPrices.isEmpty
        ? const Center(child: 
        CircularProgressIndicator(
          color: Color(0xFF3331c6),
        ))
        : Column(
            children: gasPrices.entries
                .map((entry) => SizedBox(
                  height: 50,
                  child: ListTile(
                        title: Text(entry.key),
                        subtitle: Text(entry.value),
                      ),
                ))
                .toList(),
          );
  }
}
