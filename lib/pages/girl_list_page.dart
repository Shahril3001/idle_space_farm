import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/girl_farmer_model.dart';
import '../providers/game_provider.dart';
import 'girl_details_page.dart'; // Import the new details page

class ManageGirlListPage extends StatefulWidget {
  @override
  _ManageGirlListPageState createState() => _ManageGirlListPageState();
}

class _ManageGirlListPageState extends State<ManageGirlListPage> {
  String _sortBy = 'Level'; // Default sorting option
  String _filterQuery = ''; // Filter query

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    List<GirlFarmer> girlFarmers = gameProvider.girlFarmers;

    // Apply filtering
    if (_filterQuery.isNotEmpty) {
      girlFarmers = girlFarmers
          .where((girl) =>
              girl.name.toLowerCase().contains(_filterQuery.toLowerCase()))
          .toList();
    }

    // Apply sorting
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
      appBar: AppBar(
        title: Text(
          'Girl List',
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Sorting and Filtering UI
                _buildSortAndFilterUI(),

                // Girl List
                Expanded(
                  child: girlFarmers.isEmpty
                      ? Center(
                          child: Text(
                            'No girls available.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true, // Important for performance
                          // Remove or replace the NeverScrollableScrollPhysics() with a scrollable physics
                          physics: BouncingScrollPhysics(), // Enable scrolling
                          itemCount: girlFarmers.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final girl = girlFarmers[index];

                            return GestureDetector(
                              onTap: () {
                                // Navigate to the GirlDetailsPage
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        GirlDetailsPage(girl: girl),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                color: Colors.purple[100],
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          girl.image,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(Icons.person, size: 80),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              girl.name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.deepPurple,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'Level: ${girl.level}, Rarity: ${girl.rarity}',
                                              style: TextStyle(
                                                color: Colors.deepPurple[700],
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            LinearProgressIndicator(
                                              value: girl.level / 100,
                                              backgroundColor:
                                                  Colors.deepPurple[200],
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.deepPurple),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Column(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              bool success = gameProvider
                                                  .upgradeGirl(girl.id);
                                              if (success) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        '${girl.name} upgraded! 🎉'),
                                                    backgroundColor:
                                                        Colors.green,
                                                    duration:
                                                        Duration(seconds: 1),
                                                  ),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        '❌ Not enough minerals!'),
                                                    backgroundColor: Colors.red,
                                                    duration:
                                                        Duration(seconds: 2),
                                                  ),
                                                );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.deepPurple,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: Text(
                                              'Upgrade',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          ElevatedButton(
                                            onPressed: () {
                                              gameProvider.sellGirl(girl.id);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      '${girl.name} sold! 💰'),
                                                  backgroundColor:
                                                      Colors.orange,
                                                  duration:
                                                      Duration(seconds: 1),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: Text(
                                              'Sell',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
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

  /// Builds the sorting and filtering UI
  Widget _buildSortAndFilterUI() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        children: [
          // Filter Text Field
          TextField(
            decoration: InputDecoration(
              hintText: 'Search by name...',
              prefixIcon: Icon(Icons.search, color: Colors.deepPurple),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _filterQuery = value;
              });
            },
          ),
          SizedBox(height: 8),

          // Sorting Dropdown
          DropdownButton<String>(
            value: _sortBy,
            onChanged: (String? newValue) {
              setState(() {
                _sortBy = newValue!;
              });
            },
            items: <String>['Level', 'Rarity', 'Name']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  'Sort by: $value',
                  style: TextStyle(color: Colors.deepPurple),
                ),
              );
            }).toList(),
            underline: Container(),
            isExpanded: true,
            icon: Icon(Icons.sort, color: Colors.deepPurple),
            style: TextStyle(color: Colors.deepPurple),
            dropdownColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
