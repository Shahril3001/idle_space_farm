import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class TransactionExchangePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Exchange',
        height: 40,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
      ),
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
        "fromIcon": 'assets/images/icons/golds.png', // Updated to image asset
        "toIcon": 'assets/images/icons/minerals.png', // Updated to image asset
      },
      {
        "label": "150 Golds ➝ 500 Mana",
        "from": "Credits",
        "to": "Energy",
        "fromAmount": 150.0, // Use double instead of int
        "toAmount": 500.0, // Use double instead of int
        "fromIcon": 'assets/images/icons/golds.png', // Updated to image asset
        "toIcon": 'assets/images/icons/mana.png', // Updated to image asset
      },
      {
        "label": "1000 Minerals ➝ 150 Golds",
        "from": "Minerals",
        "to": "Credits",
        "fromAmount": 1000.0, // Use double instead of int
        "toAmount": 150.0, // Use double instead of int
        "fromIcon":
            'assets/images/icons/minerals.png', // Updated to image asset
        "toIcon": 'assets/images/icons/golds.png', // Updated to image asset
      },
      {
        "label": "500 Mana ➝ 150 Golds",
        "from": "Energy",
        "to": "Credits",
        "fromAmount": 500.0, // Use double instead of int
        "toAmount": 150.0, // Use double instead of int
        "fromIcon": 'assets/images/icons/mana.png', // Updated to image asset
        "toIcon": 'assets/images/icons/golds.png', // Updated to image asset
      },
      {
        "label": "1000 Minerals ➝ 500 Mana",
        "from": "Minerals",
        "to": "Energy",
        "fromAmount": 1000.0, // Use double instead of int
        "toAmount": 500.0, // Use double instead of int
        "fromIcon":
            'assets/images/icons/minerals.png', // Updated to image asset
        "toIcon": 'assets/images/icons/mana.png', // Updated to image asset
      },
      {
        "label": "500 Mana ➝ 1000 Minerals",
        "from": "Energy",
        "to": "Minerals",
        "fromAmount": 500.0, // Use double instead of int
        "toAmount": 1000.0, // Use double instead of int
        "fromIcon": 'assets/images/icons/mana.png', // Updated to image asset
        "toIcon": 'assets/images/icons/minerals.png', // Updated to image asset
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
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.height = 56.0, // Default height similar to AppBar
    this.padding = EdgeInsets.zero, // Custom padding
    this.margin = EdgeInsets.zero, // Custom margin
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: padding, // Apply custom padding
      margin: margin, // Apply custom margin
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/ui/wood-ui.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'GameFont',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
