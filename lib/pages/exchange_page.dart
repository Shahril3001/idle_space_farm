import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class TransactionExchangePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resource Exchange',
          style: TextStyle(
            fontFamily: 'GameFont', // Use a custom font
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple, // Match the game theme
        elevation: 10,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple, Colors.purpleAccent],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Exchange Option",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Expanded(child: _buildExchangeOptions(context, gameProvider)),
            ],
          ),
        ),
      ),
    );
  }

  /// Exchange Options List
  Widget _buildExchangeOptions(
      BuildContext context, GameProvider gameProvider) {
    List<Map<String, dynamic>> exchanges = [
      {
        "label": "150 Credits ➝ 1000 Minerals",
        "from": "Credits",
        "to": "Minerals",
        "fromAmount": 150.0, // Use double instead of int
        "toAmount": 1000.0, // Use double instead of int
        "fromIcon": Icons.monetization_on,
        "toIcon": Icons.landscape,
      },
      {
        "label": "150 Credits ➝ 500 Energy",
        "from": "Credits",
        "to": "Energy",
        "fromAmount": 150.0, // Use double instead of int
        "toAmount": 500.0, // Use double instead of int
        "fromIcon": Icons.monetization_on,
        "toIcon": Icons.flash_on,
      },
      {
        "label": "1000 Minerals ➝ 150 Credits",
        "from": "Minerals",
        "to": "Credits",
        "fromAmount": 1000.0, // Use double instead of int
        "toAmount": 150.0, // Use double instead of int
        "fromIcon": Icons.landscape,
        "toIcon": Icons.monetization_on,
      },
      {
        "label": "500 Energy ➝ 150 Credits",
        "from": "Energy",
        "to": "Credits",
        "fromAmount": 500.0, // Use double instead of int
        "toAmount": 150.0, // Use double instead of int
        "fromIcon": Icons.flash_on,
        "toIcon": Icons.monetization_on,
      },
      {
        "label": "1000 Minerals ➝ 500 Energy",
        "from": "Minerals",
        "to": "Energy",
        "fromAmount": 1000.0, // Use double instead of int
        "toAmount": 500.0, // Use double instead of int
        "fromIcon": Icons.landscape,
        "toIcon": Icons.flash_on,
      },
      {
        "label": "500 Energy ➝ 1000 Minerals",
        "from": "Energy",
        "to": "Minerals",
        "fromAmount": 500.0, // Use double instead of int
        "toAmount": 1000.0, // Use double instead of int
        "fromIcon": Icons.flash_on,
        "toIcon": Icons.landscape,
      },
    ];

    return ListView.builder(
      itemCount: exchanges.length,
      itemBuilder: (context, index) {
        var exchange = exchanges[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Icon(exchange["fromIcon"], color: Colors.deepPurple),
                SizedBox(width: 8),
                Text(
                  exchange["fromAmount"].toString(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: Colors.grey),
                SizedBox(width: 8),
                Icon(exchange["toIcon"], color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  exchange["toAmount"].toString(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    bool success = gameProvider.exchangeResources(
                      exchange["from"],
                      exchange["to"],
                      exchange["fromAmount"],
                      exchange["toAmount"],
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success
                            ? "✅ Exchange Successful!"
                            : "❌ Not enough ${exchange["from"]}!"),
                        duration: Duration(seconds: 2),
                        backgroundColor: success ? Colors.green : Colors.red,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Exchange",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
