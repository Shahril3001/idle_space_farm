import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
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
        title: 'Girl',
        height: 40, // Adjust the height of the custom app bar
        padding: EdgeInsets.zero, // Custom padding
        margin: EdgeInsets.zero, // Custom margin
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ImageCacheManager.getImage('assets/images/ui/app-bg.png'),
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
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8), // Add padding for better spacing
                          decoration: BoxDecoration(
                            color: Colors.black
                                .withOpacity(0.8), // Black with 80% opacity
                            borderRadius: BorderRadius.circular(
                                8), // Optional: Add rounded corners
                          ),
                          child: Center(
                            child: Text(
                              'No girls available.',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
                            ),
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
                                color: Colors.black.withOpacity(
                                    0.8), // Black background with 80% opacity
                                elevation:
                                    2, // Lower elevation for a subtle shadow
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Slightly rounded corners
                                ),
                                margin: EdgeInsets.symmetric(
                                    vertical:
                                        4), // Reduce margin around the card
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8), // Reduce internal padding
                                  leading: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        girl.imageFace), // Use the girl's image
                                    radius: 25, // Slightly smaller avatar
                                  ),
                                  title: Text(
                                    girl.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors
                                          .white, // White text for better contrast
                                      fontSize:
                                          16, // Slightly smaller font size
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          height:
                                              2), // Minimal spacing between title and subtitle
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Level: ${girl.level} | Race: ${girl.race}',
                                            style: TextStyle(
                                              fontSize:
                                                  13, // Smaller font size for the level
                                              color: Colors
                                                  .white70, // Lighter text for the level
                                            ),
                                          ),
                                          // Add more details here if needed
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: _buildActionButtons(girl,
                                      gameProvider), // Custom action buttons
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.black),
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                ),
                style: TextStyle(color: Colors.black),
                onChanged: (value) => setState(() => _filterQuery = value),
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFCAA04D),
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
              dropdownColor: Color(0xFFCAA04D),
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
            icon: Image.asset(
              'assets/images/icons/upgrade.png', // Path to your upgrade icon
              width: 30, // Adjust size as needed
              height: 30,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirm Upgrade'),
                    content: Text('Do you want to upgrade ${girl.name}?'),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context), // Cancel action
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(
                              context); // Close the confirmation dialog
                          bool success = gameProvider.upgradeGirl(girl.id);

                          // Show the result in another AlertDialog
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(success ? 'Success' : 'Failed'),
                              content: Text(
                                success
                                    ? '${girl.name} upgraded! 🎉'
                                    : '❌ Not enough resources!',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text('Upgrade'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        Tooltip(
          message: 'Sell',
          child: IconButton(
            icon: Image.asset(
              'assets/images/icons/sell.png', // Replace with your actual image path
              width: 30, // Adjust size as needed
              height: 30,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirm Sale'),
                    content:
                        Text('Are you sure you want to sell ${girl.name}?'),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context), // Cancel action
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(
                              context); // Close the confirmation dialog
                          gameProvider.sellGirl(girl.id);

                          // Show result in AlertDialog instead of SnackBar
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Sold!'),
                              content: Text('${girl.name} has been sold! 💰'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text('Sell'),
                      ),
                    ],
                  );
                },
              );
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
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
