import 'package:flutter/material.dart';
import '../main.dart';
import 'inventory_equipment_tab.dart';
import 'inventory_potions_tab.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Inventory',
          height: 40,
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48), // Adjust height as needed
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.9),
                borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
              ),
              child: TabBar(
                labelColor: Color(0xFFCAA04D),
                unselectedLabelColor: Colors.white70,
                indicatorColor: Color(0xFFCAA04D),
                indicatorSize: TabBarIndicatorSize.tab,
                labelPadding: EdgeInsets.symmetric(horizontal: 16),
                controller: _tabController,
                tabs: [
                  Tab(
                    icon: Image.asset(
                      'assets/images/icons/inventory-equipment.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                  Tab(
                    icon: Image.asset(
                      'assets/images/icons/inventory-potion.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ImageCacheManager.getImage('assets/images/ui/app-bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    EquipmentTab(),
                    PotionsTab(),
                  ],
                ),
              ),
              _buildBackButton(context), // Add back button here
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFA12626), //Top color
              const Color(0xFF611818), // Dark red at bottom
            ],
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Colors.transparent, // Make button background transparent
            shadowColor: Colors.transparent, // Remove shadow
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
          child: Text(
            "Back",
            style: TextStyle(
                color: Colors.white, fontFamily: 'GameFont', fontSize: 16),
          ),
        ),
      ),
    );
  }
}

// Custom App Bar Implementation (same as before)
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.height = 56.0,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.bottom,
  }) : super(key: key);

  @override
  Size get preferredSize =>
      Size.fromHeight(height + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/ui/wood-ui.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (bottom == null) Spacer(),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'GameFont',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (bottom == null) Spacer(),
          if (bottom != null) bottom!,
        ],
      ),
    );
  }
}
