import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class TransactionExchangePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/ui/app-bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity, // Ensures full width
                    height: 40, // Adjust height as needed
                    decoration: BoxDecoration(
                      color: Colors.black
                          .withOpacity(0.8), // Black background with opacity
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center, // Align text properly
                      child: Text(
                        "Select Exchange Option",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
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
        "label": "150 Golds ➝ 1000 Minerals",
        "from": "Credits",
        "to": "Minerals",
        "fromAmount": 150.0, // Use double instead of int
        "toAmount": 1000.0, // Use double instead of int
        "fromIcon":
            'assets/images/icons/resources-golds.png', // Updated to image asset
        "toIcon":
            'assets/images/icons/resources-minerals.png', // Updated to image asset
      },
      {
        "label": "150 Golds ➝ 500 Runes",
        "from": "Credits",
        "to": "Energy",
        "fromAmount": 150.0, // Use double instead of int
        "toAmount": 500.0, // Use double instead of int
        "fromIcon":
            'assets/images/icons/resources-golds.png', // Updated to image asset
        "toIcon":
            'assets/images/icons/resources-runes.png', // Updated to image asset
      },
      {
        "label": "1000 Minerals ➝ 150 Golds",
        "from": "Minerals",
        "to": "Credits",
        "fromAmount": 1000.0, // Use double instead of int
        "toAmount": 150.0, // Use double instead of int
        "fromIcon":
            'assets/images/icons/resources-minerals.png', // Updated to image asset
        "toIcon":
            'assets/images/icons/resources-golds.png', // Updated to image asset
      },
      {
        "label": "500 Runes ➝ 150 Golds",
        "from": "Energy",
        "to": "Credits",
        "fromAmount": 500.0, // Use double instead of int
        "toAmount": 150.0, // Use double instead of int
        "fromIcon":
            'assets/images/icons/resources-runes.png', // Updated to image asset
        "toIcon":
            'assets/images/icons/resources-golds.png', // Updated to image asset
      },
      {
        "label": "1000 Minerals ➝ 500 Runes",
        "from": "Minerals",
        "to": "Energy",
        "fromAmount": 1000.0, // Use double instead of int
        "toAmount": 500.0, // Use double instead of int
        "fromIcon":
            'assets/images/icons/resources-minerals.png', // Updated to image asset
        "toIcon":
            'assets/images/icons/resources-runes.png', // Updated to image asset
      },
      {
        "label": "500 Runes ➝ 1000 Minerals",
        "from": "Energy",
        "to": "Minerals",
        "fromAmount": 500.0, // Use double instead of int
        "toAmount": 1000.0, // Use double instead of int
        "fromIcon":
            'assets/images/icons/resources-runes.png', // Updated to image asset
        "toIcon":
            'assets/images/icons/resources-minerals.png', // Updated to image asset
      },
    ];

    return ListView.builder(
      itemCount: exchanges.length,
      itemBuilder: (context, index) {
        var exchange = exchanges[index];
        return Card(
          color: Colors.black.withOpacity(0.8),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Image.asset(
                  exchange["fromIcon"], // Use image asset
                  width: 24, // Adjust size as needed
                  height: 24,
                ),
                SizedBox(width: 8),
                Text(
                  exchange["fromAmount"].toString(),
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: Colors.white),
                SizedBox(width: 8),
                Image.asset(
                  exchange["toIcon"], // Use image asset
                  width: 24, // Adjust size as needed
                  height: 24,
                ),
                SizedBox(width: 8),
                Text(
                  exchange["toAmount"].toString(),
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
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

                    _showExchangeResultDialog(
                      context,
                      success: success,
                      fromResource: exchange["from"],
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    backgroundColor: Color(0xFFCAA04D),
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

  void _showExchangeResultDialog(BuildContext context,
      {required bool success, required String fromResource}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: success ? Colors.green : Colors.red,
              width: 2,
            ),
          ),
          title: Row(
            children: [
              Icon(
                success ? Icons.check_circle : Icons.error,
                color: success ? Colors.green : Colors.red,
              ),
              SizedBox(width: 10),
              Text(
                success ? "Success!" : "Failed!",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            success
                ? "Exchange completed successfully!"
                : "Not enough $fromResource available!",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "OK",
                style: TextStyle(color: Color(0xFFCAA04D)),
              ),
            ),
          ],
        );
      },
    );
  }
}
