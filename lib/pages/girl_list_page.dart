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
                              'No girl available.',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ),
                        )
                      : GridView.builder(
                          physics: BouncingScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.67,
                          ),
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
                                color: Colors.black.withOpacity(0.8),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(
                                            8), // Only round top corners to match Card
                                      ),
                                      child: Image.asset(
                                        girl.imageFace,
                                        width: double.infinity,
                                        height: 110,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              8.0), // Padding only for text
                                      child: Column(
                                        children: [
                                          Text(
                                            girl.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            'Level: ${girl.level}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
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
}
