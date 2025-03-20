import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/girl_farmer_model.dart';
import '../providers/game_provider.dart';
import 'girl_details_page.dart';

class ManageGirlListPage extends StatefulWidget {
  @override
  _ManageGirlListPageState createState() => _ManageGirlListPageState();
}

class _ManageGirlListPageState extends State<ManageGirlListPage> {
  String _sortBy = 'Level';
  String _filterQuery = '';

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    List<GirlFarmer> girlFarmers = gameProvider.girlFarmers;

    if (_filterQuery.isNotEmpty) {
      girlFarmers = girlFarmers
          .where((girl) =>
              girl.name.toLowerCase().contains(_filterQuery.toLowerCase()))
          .toList();
    }

    switch (_sortBy) {
      case 'Level':
        girlFarmers.sort((a, b) => b.level.compareTo(a.level));
        break;
      case 'Rarity':
        girlFarmers.sort((a, b) => b.rarity.compareTo(a.rarity));
        break;
      case 'Name':
        girlFarmers.sort((a, b) => a.name.compareTo(b.name));
        break;
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Knight',
        height: 40, // Adjust the height of the custom app bar
        padding: EdgeInsets.zero, // Custom padding
        margin: EdgeInsets.zero, // Custom margin
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/ui/app-bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                _buildSortAndFilterUI(),
                Expanded(
                  child: girlFarmers.isEmpty
                      ? Center(
                          child: Text(
                            'No girls available.',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )
                      : ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: girlFarmers.length,
                          itemBuilder: (context, index) {
                            final girl = girlFarmers[index];
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GirlDetailsPage(girl: girl)),
                              ),
                              child: Card(
                                elevation: 8,
                                margin: EdgeInsets.symmetric(vertical: 6),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.grey.shade700,
                                        Colors.grey.shade900,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: AssetImage(girl.image),
                                      radius: 30,
                                    ),
                                    title: Text(
                                      girl.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Level: ${girl.level}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white70)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    trailing:
                                        _buildActionButtons(girl, gameProvider),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSortAndFilterUI() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.purple[800],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                ),
                style: TextStyle(color: Colors.white),
                onChanged: (value) => setState(() => _filterQuery = value),
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.purple[900],
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButton<String>(
              value: _sortBy,
              onChanged: (String? newValue) =>
                  setState(() => _sortBy = newValue!),
              items: ['Level', 'Rarity', 'Name'].map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value, style: TextStyle(color: Colors.white)),
                );
              }).toList(),
              dropdownColor: Colors.purple[900],
              icon: Icon(Icons.sort, color: Colors.white),
              underline: SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(GirlFarmer girl, GameProvider gameProvider) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: 'Upgrade',
          child: IconButton(
            icon: Icon(Icons.upgrade, color: Colors.green),
            onPressed: () {
              if (gameProvider.upgradeGirl(girl.id)) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('${girl.name} upgraded! 🎉'),
                  backgroundColor: Colors.green,
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('❌ Not enough resources!'),
                  backgroundColor: Colors.red,
                ));
              }
            },
          ),
        ),
        Tooltip(
          message: 'Sell',
          child: IconButton(
            icon: Icon(Icons.sell, color: Colors.orange),
            onPressed: () {
              gameProvider.sellGirl(girl.id);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('${girl.name} sold! 💰'),
                backgroundColor: Colors.orange,
              ));
            },
          ),
        ),
      ],
    );
  }
}

// Custom App Bar Implementation
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
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
