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
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Equipment'),
              Tab(text: 'Potions'),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ImageCacheManager.getImage('assets/images/ui/app-bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: TabBarView(
            controller: _tabController,
            children: [
              EquipmentTab(),
              PotionsTab(),
            ],
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
